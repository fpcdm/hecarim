//
//  FWRuntime.m
//  Framework
//
//  Created by 吴勇 on 16/2/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWRuntime.h"
#import <objc/runtime.h>

@implementation FWRuntime

@def_static_integer( UNKNOWN,		0 )
@def_static_integer( OBJECT,		1 )
@def_static_integer( NSNUMBER,		2 )
@def_static_integer( NSSTRING,		3 )
@def_static_integer( NSARRAY,		4 )
@def_static_integer( NSDICTIONARY,	5 )
@def_static_integer( NSDATE,		6 )

+ (NSInteger)typeOf:(const char *)attr
{
    if ( attr[0] != 'T' )
        return self.UNKNOWN;
    
    const char * type = &attr[1];
    if ( type[0] == '@' )
    {
        if ( type[1] != '"' )
            return self.UNKNOWN;
        
        char typeClazz[128] = { 0 };
        
        const char * clazz = &type[2];
        const char * clazzEnd = strchr( clazz, '"' );
        
        if ( clazzEnd && clazz != clazzEnd )
        {
            unsigned int size = (unsigned int)(clazzEnd - clazz);
            strncpy( &typeClazz[0], clazz, size );
        }
        
        if ( 0 == strcmp((const char *)typeClazz, "NSNumber") )
        {
            return self.NSNUMBER;
        }
        else if ( 0 == strcmp((const char *)typeClazz, "NSString") )
        {
            return self.NSSTRING;
        }
        else if ( 0 == strcmp((const char *)typeClazz, "NSDate") )
        {
            return self.NSDATE;
        }
        else if ( 0 == strcmp((const char *)typeClazz, "NSArray") )
        {
            return self.NSARRAY;
        }
        else if ( 0 == strcmp((const char *)typeClazz, "NSDictionary") )
        {
            return self.NSDICTIONARY;
        }
        else
        {
            return self.OBJECT;
        }
    }
    else if ( type[0] == '[' )
    {
        return self.UNKNOWN;
    }
    else if ( type[0] == '{' )
    {
        return self.UNKNOWN;
    }
    else
    {
        if ( type[0] == 'c' || type[0] == 'C' )
        {
            return self.UNKNOWN;
        }
        else if ( type[0] == 'i' || type[0] == 's' || type[0] == 'l' || type[0] == 'q' )
        {
            return self.UNKNOWN;
        }
        else if ( type[0] == 'I' || type[0] == 'S' || type[0] == 'L' || type[0] == 'Q' )
        {
            return self.UNKNOWN;
        }
        else if ( type[0] == 'f' )
        {
            return self.UNKNOWN;
        }
        else if ( type[0] == 'd' )
        {
            return self.UNKNOWN;
        }
        else if ( type[0] == 'B' )
        {
            return self.UNKNOWN;
        }
        else if ( type[0] == 'v' )
        {
            return self.UNKNOWN;
        }
        else if ( type[0] == '*' )
        {
            return self.UNKNOWN;
        }
        else if ( type[0] == ':' )
        {
            return self.UNKNOWN;
        }
        else if ( 0 == strcmp(type, "bnum") )
        {
            return self.UNKNOWN;
        }
        else if ( type[0] == '^' )
        {
            return self.UNKNOWN;
        }
        else if ( type[0] == '?' )
        {
            return self.UNKNOWN;
        }
        else
        {
            return self.UNKNOWN;
        }
    }
    
    return self.UNKNOWN;
}

+ (NSInteger)typeOfAttribute:(const char *)attr
{
    return [self typeOf:attr];
}

+ (NSInteger)typeOfObject:(id)obj
{
    if ( nil == obj )
        return self.UNKNOWN;
    
    if ( [obj isKindOfClass:[NSNumber class]] )
    {
        return self.NSNUMBER;
    }
    else if ( [obj isKindOfClass:[NSString class]] )
    {
        return self.NSSTRING;
    }
    else if ( [obj isKindOfClass:[NSArray class]] )
    {
        return self.NSARRAY;
    }
    else if ( [obj isKindOfClass:[NSDictionary class]] )
    {
        return self.NSDICTIONARY;
    }
    else if ( [obj isKindOfClass:[NSDate class]] )
    {
        return self.NSDATE;
    }
    else if ( [obj isKindOfClass:[NSObject class]] )
    {
        return self.OBJECT;
    }
    
    return self.UNKNOWN;
}

+ (NSString *)classNameOf:(const char *)attr
{
    if ( attr[0] != 'T' )
        return nil;
    
    const char * type = &attr[1];
    if ( type[0] == '@' )
    {
        if ( type[1] != '"' )
            return nil;
        
        char typeClazz[128] = { 0 };
        
        const char * clazz = &type[2];
        const char * clazzEnd = strchr( clazz, '"' );
        
        if ( clazzEnd && clazz != clazzEnd )
        {
            unsigned int size = (unsigned int)(clazzEnd - clazz);
            strncpy( &typeClazz[0], clazz, size );
        }
        
        return [NSString stringWithUTF8String:typeClazz];
    }
    
    return nil;
}

+ (NSString *)classNameOfAttribute:(const char *)attr
{
    return [self classNameOf:attr];
}

+ (Class)classOfAttribute:(const char *)attr
{
    NSString * className = [self classNameOf:attr];
    if ( nil == className )
        return nil;
    
    return NSClassFromString( className );
}

+ (BOOL)isAtomClass:(Class)clazz
{
    if ( clazz == [NSArray class] )
        return YES;
    if ( clazz == [NSData class] )
        return YES;
    if ( clazz == [NSDate class] )
        return YES;
    if ( clazz == [NSDictionary class] )
        return YES;
    if ( clazz == [NSNull class] )
        return YES;
    if ( clazz == [NSNumber class])
        return YES;
    if ( clazz == [NSObject class] )
        return YES;
    if ( clazz == [NSString class] )
        return YES;
    if ( clazz == [NSURL class] )
        return YES;
    if ( clazz == [NSValue class] )
        return YES;
    
    //__NSCFArray,__NSCFNumber,__NSArrayI,...
    if ( [[clazz description] hasPrefix:@"__NS"] )
        return YES;
    
    return NO;
}

//Runtime
+ (NSArray *)allInstanceMethods:(Class)clazz
{
    static NSMutableDictionary * __cache = nil;
    
    if ( nil == __cache )
    {
        __cache = [[NSMutableDictionary alloc] init];
    }
    
    NSString *cacheKey = NSStringFromClass(clazz);
    
    NSMutableArray * methodNames = [__cache objectForKey:cacheKey];
    if ( nil == methodNames )
    {
        methodNames = [NSMutableArray array];
        
        while (clazz != NULL) {
            unsigned int methodCount = 0;
            Method *methods = class_copyMethodList(clazz, &methodCount);
            
            for (unsigned int i = 0; i < methodCount; ++i) {
                SEL selector = method_getName(methods[i]);
                if (selector) {
                    const char *cstrName = sel_getName(selector);
                    if (NULL == cstrName) continue;
                    
                    NSString *selectorName = [NSString stringWithUTF8String:cstrName];
                    if (NULL == selectorName) continue;
                    if ([methodNames containsObject:selectorName]) continue;
                    
                    [methodNames addObject:selectorName];
                }
            }
            
            clazz = class_getSuperclass(clazz);
            if (clazz == [NSObject class]) break;
        }
        
        [__cache setObject:methodNames forKey:cacheKey];
    }
    
    return methodNames;
}

+ (NSArray *)allInstanceMethods:(Class)clazz withPrefix:(NSString *)prefix
{
    NSArray *methods = [self allInstanceMethods:clazz];
    if (nil == methods || 0 == methods.count) {
        return nil;
    }
    
    if (nil == prefix) {
        return methods;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *method in methods) {
        if (![method hasPrefix:prefix]) continue;
        
        [result addObject:method];
    }
    return result;
}

+ (NSArray *)allInstanceProperties:(Class)clazz
{
    static NSMutableDictionary * __cache = nil;
    
    if ( nil == __cache )
    {
        __cache = [[NSMutableDictionary alloc] init];
    }
    
    NSString *cacheKey = NSStringFromClass(clazz);
    
    NSMutableArray * propertyNames = [__cache objectForKey:cacheKey];
    if ( nil == propertyNames )
    {
        propertyNames = [NSMutableArray array];
        
        while (clazz != NULL) {
            unsigned int propertyCount = 0;
            objc_property_t *properties = class_copyPropertyList(clazz, &propertyCount);
            
            for (NSUInteger i = 0; i < propertyCount; i++) {
                const char *name = property_getName(properties[i]);
                if (NULL == name) continue;
                
                NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                if (NULL == propertyName) continue;
                if ([propertyNames containsObject:propertyName]) continue;
                
                [propertyNames addObject:propertyName];
            }
            
            free(properties);
            
            clazz = class_getSuperclass(clazz);
            if (clazz == [NSObject class]) break;
        }
        
        [__cache setObject:propertyNames forKey:cacheKey];
    }
    
    return propertyNames;
}

+ (NSDictionary *)getInstanceProperties:(id)obj
{
    if (!obj) return nil;
    
    NSArray *properties = [self allInstanceProperties:[obj class]];
    if (nil == properties || 0 == properties.count) {
        return nil;
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *property in properties) {
        if (![obj respondsToSelector:NSSelectorFromString(property)])
            continue;
        
        id value = [obj valueForKey:property];
        if (value == nil) {
            value = [NSNull null];
        }
        [result setObject:value forKey:property];
    }
    return result;
}

@end
