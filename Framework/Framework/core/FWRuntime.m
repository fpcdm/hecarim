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
    static NSMutableArray *classNames;
    
    if (!classNames) {
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
    }
    
    return classNames;
}

+ (NSArray *)subclassesOfClass:(Class)clazz
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *allClasses = [self allClasses];
    for (NSString *className in allClasses) {
        Class classType = NSClassFromString(className);
        if (classType == clazz) continue;
        if (![classType isSubclassOfClass:clazz]) continue;
        
        [result addObject:className];
    }
    return result;
}

+ (NSArray *)subclassesOfClass:(Class)clazz withPrefix:(NSString *)prefix
{
    NSArray *classNames = [self subclassesOfClass:clazz];
    if (nil == classNames || 0 == classNames.count) {
        return classNames;
    }
    
    if (nil == prefix) {
        return classNames;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *className in classNames) {
        if (![className hasPrefix:prefix]) continue;
        
        [result addObject:className];
    }
    
    return result;
}

#pragma mark -
+ (NSArray *)methodsOfClass:(Class)clazz
{
    static NSMutableDictionary *classMethodNames = nil;
    if (nil == classMethodNames) {
        classMethodNames = [[NSMutableDictionary alloc] init];
    }
    
    NSString *className = NSStringFromClass(clazz);
    NSMutableArray *methodNames = [classMethodNames objectForKey:className];
    if (nil == methodNames) {
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
        
        [classMethodNames setObject:methodNames forKey:className];
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
+ (NSDictionary *)allProperties:(Class)clazz
{
    static NSMutableDictionary *classPropertyNames = nil;
    if (nil == classPropertyNames) {
        classPropertyNames = [[NSMutableDictionary alloc] init];
    }
    
    NSString *className = NSStringFromClass(clazz);
    NSMutableDictionary *propertyNames = [classPropertyNames objectForKey:className];
    if (nil == propertyNames) {
        propertyNames = [[NSMutableDictionary alloc] init];
        
        while (clazz != NULL) {
            unsigned int propertyCount = 0;
            objc_property_t *properties = class_copyPropertyList(clazz, &propertyCount);
            
            for (NSUInteger i = 0; i < propertyCount; i++) {
                const char *name = property_getName(properties[i]);
                const char *attr = property_getAttributes(properties[i]);
                if (NULL == name) continue;
                
                NSString *propertyName = [NSString stringWithUTF8String:name];
                NSString *attrName = [NSString stringWithUTF8String:attr];
                if (NULL == propertyName) continue;
                
                [propertyNames setObject:(attrName ? attrName : @"") forKey:propertyName];
            }
            
            free(properties);
            
            clazz = class_getSuperclass(clazz);
            if (nil == clazz || clazz == [NSObject class]) break;
        }
        
        [classPropertyNames setObject:propertyNames forKey:className];
    }
    
    return propertyNames;
}

+ (BOOL)isReadonly:(const char *)attr
{
    if (strstr(attr, "_ro") || strstr(attr, ",R")) {
        return YES;
    }
    return NO;
}

+ (NSArray *)propertiesOfClass:(Class)clazz
{
    return [self propertiesOfClass:clazz mutable:NO];
}

+ (NSArray *)propertiesOfClass:(Class)clazz mutable:(BOOL)mutable
{
    NSDictionary *properties = [self allProperties:clazz];
    //所有属性
    if (!mutable) {
        NSArray *result = [properties allKeys];
        return result;
    }
    
    //非只读属性
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *property in properties) {
        NSString *attrName = [properties objectForKey:property];
        if ([self isReadonly:[attrName UTF8String]]) continue;
        
        [result addObject:property];
    }
    return result;
}

#pragma mark -
+ (NSDictionary *)propertiesOfObject:(id)obj
{
    if (!obj) return nil;
    
    NSArray *properties = [self propertiesOfClass:[obj class]];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *property in properties) {
        //检查是否可获取属性
        if (![obj respondsToSelector:NSSelectorFromString(property)]) continue;
        
        //包含Readonly属性
        id value = [obj valueForKey:property];
        if (value == nil) {
            value = [NSNull null];
        }
        [result setObject:value forKey:property];
    }
    
    return result;
}

#pragma mark -
+ (id)copyObject:(id)obj
{
    return [self copyObject:obj withZone:nil];
}

+ (id)copyObject:(id)obj withZone:(NSZone *)zone
{
    if (!obj) return nil;
    
    Class clazz = [obj class];
    id newObj = zone ? [[clazz allocWithZone:zone] init] : [[clazz alloc] init];
    if (!newObj) return nil;
    
    //忽略只读属性
    NSArray *properties = [self propertiesOfClass:clazz mutable:YES];
    for (NSString *property in properties) {
        id value = [obj valueForKey:property];
        [newObj setValue:value forKey:property];
    }
    
    return newObj;
}

#pragma mark -
+ (void)encodeObject:(id)obj withCoder:(NSCoder *)aCoder
{
    NSDictionary *properties = [self propertiesOfObject:obj];
    if (properties) {
        for (NSString *property in properties) {
            id value = [properties objectForKey:property];
            if (value != nil && value != [NSNull null]) {
                [aCoder encodeObject:value forKey:property];
            }
        }
    }
}

+ (void)decodeObject:(id)obj withCoder:(NSCoder *)aDecoder
{
    NSArray *properties = [self propertiesOfClass:[obj class]];
    for (NSString *property in properties) {
        id value = [aDecoder decodeObjectForKey:property];
        if (value != nil && value != [NSNull null]) {
            //是否可设置值
            NSString *selectorName = [NSString stringWithFormat:@"set%@%@:",[[property substringToIndex:1] uppercaseString], [property substringFromIndex:1]];
            if ([obj respondsToSelector:NSSelectorFromString(selectorName)]) {
                [obj setValue:value forKey:property];
            }
        }
    }
}

@end
