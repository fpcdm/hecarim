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

#pragma mark -
+ (NSArray *)allClasses
{
    static dispatch_once_t once;
    static NSMutableArray *classNames;
    
    dispatch_once( &once, ^{
        classNames = [[NSMutableArray alloc] init];
        
        unsigned int classesCount = 0;
        Class *classes = objc_copyClassList(&classesCount);
        
        for (unsigned int i = 0; i < classesCount; ++i) {
            Class classType = classes[i];
            if (class_isMetaClass(classType)) continue;
            
            Class superClass = class_getSuperclass(classType);
            if (nil == superClass) continue;
            
            [classNames addObject:[NSString stringWithUTF8String:class_getName(classType)]];
        }
        
        [classNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        free(classes);
    });
    
    return classNames;
}

+ (NSArray *)subclassesOfClass:(Class)clazz
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSString *className in [self allClasses]) {
        Class classType = NSClassFromString(className);
        if (classType == clazz) continue;
        if (![classType isSubclassOfClass:clazz]) continue;
        
        [result addObject:className];
    }
    return result;
}

#pragma mark -
+ (NSArray *)methodsOfClass:(Class)clazz
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
            
            free(methods);
            
            clazz = class_getSuperclass(clazz);
            if (nil == clazz || clazz == [NSObject class]) break;
        }
        
        [__cache setObject:methodNames forKey:cacheKey];
    }
    
    return methodNames;
}

+ (NSArray *)methodsOfClass:(Class)clazz withPrefix:(NSString *)prefix
{
    NSArray *methods = [self methodsOfClass:clazz];
    if (nil == methods || 0 == methods.count) {
        return methods;
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

#pragma mark -
+ (NSArray *)propertiesOfClass:(Class)clazz
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
            if (nil == clazz || clazz == [NSObject class]) break;
        }
        
        [__cache setObject:propertyNames forKey:cacheKey];
    }
    
    return propertyNames;
}

+ (NSArray *)propertiesOfClass:(Class)clazz withPrefix:(NSString *)prefix
{
    NSArray *properties = [self propertiesOfClass:clazz];
    if (nil == properties || 0 == properties.count) {
        return properties;
    }
    
    if (nil == prefix) {
        return properties;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *property in properties) {
        if (![property hasPrefix:prefix]) continue;
        
        [result addObject:property];
    }
    
    return result;
}

#pragma mark -
+ (NSDictionary *)propertiesOfObject:(id)obj
{
    if (!obj) return nil;
    
    NSArray *properties = [self propertiesOfClass:[obj class]];
    if (nil == properties || 0 == properties.count) {
        return @{};
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *property in properties) {
        //检查属性
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
