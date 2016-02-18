//
//  NSObject+Framework.m
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "NSObject+Framework.h"
#import <objc/runtime.h>

@implementation NSObject (Framework)

//Notification
//notification.Class.name
@def_static_string(NOTIFICATION, [[self class] NOTIFICATION_TYPE])

//notification.Class.
@def_static_string(NOTIFICATION_TYPE, [[[NSString stringWithUTF8String:"notification."] stringByAppendingString:NSStringFromClass([self class])] stringByAppendingString:[NSString stringWithUTF8String:"."]])

- (void)handleNotification:(NSNotification *)notification
{
    
}

- (void)observeNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
    
    NSArray *array = [name componentsSeparatedByString:@"."];
    if (array && array.count > 1) {
        //NSString *prefix = (NSString *)[array objectAtIndex:0];
        NSString *clazz = (NSString *)[array objectAtIndex:1];
        NSString *name = array.count > 2 ? (NSString *)[array objectAtIndex:2] : nil;
        
        NSString *selectorName;
        SEL selector;
        
        if (name && name.length > 0) {
            selectorName = [NSString stringWithFormat:@"handleNotification_%@_%@:", clazz, name];
            selector = NSSelectorFromString(selectorName);
            
            if ([self respondsToSelector:selector]) {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:selector
                                                             name:name
                                                           object:nil];
                return;
            }
        }
        
        selectorName = [NSString stringWithFormat:@"handleNotification_%@:", clazz];
        selector = NSSelectorFromString(selectorName);
            
        if ([self respondsToSelector:selector]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:selector
                                                         name:name
                                                       object:nil];
            return;
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:name
                                               object:nil];
}

- (void)observeAllNotifications
{
    NSArray *methods = [[self class] allInstanceMethods:@"handleNotification_"];
    if (nil == methods || 0 == methods.count) return;
    
    for (NSString *selectorName in methods) {
        NSString *name = [selectorName stringByReplacingOccurrencesOfString:@"handleNotification_" withString:@"notification."];
        //是否包含下划线
        NSRange range = [name rangeOfString:@"_"];
        if (range.location != NSNotFound) {
            //替换为格式：notification.Class.name
            name = [name stringByReplacingOccurrencesOfString:@":" withString:@""];
            name = [name stringByReplacingCharactersInRange:range withString:@"."];
        } else {
            //替换为默认格式：notification.Class.
            name = [name stringByReplacingOccurrencesOfString:@":" withString:@"."];
        }
        if (nil == name) continue;
        
        [self observeNotification:name];
    }
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)postNotification:(NSString *)name
{
    return [[self class] postNotification:name];
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    return [[self class] postNotification:name withObject:object];
}

+ (BOOL)postNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    return YES;
}

+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    return YES;
}

//Runtime
+ (NSArray *)allInstanceMethods
{
    NSMutableArray *methodNames = [NSMutableArray array];
    
    Class clazz = [self class];
    while (NULL != clazz) {
        unsigned int methodCount = 0;
        Method *methods = class_copyMethodList(clazz, &methodCount);
        
        for (unsigned int i = 0; i < methodCount; ++i) {
            SEL selector = method_getName(methods[i]);
            if (selector) {
                const char *cstrName = sel_getName(selector);
                if (NULL == cstrName) continue;
                
                NSString *selectorName = [NSString stringWithUTF8String:cstrName];
                if (NULL == selectorName) continue;
                
                [methodNames addObject:selectorName];
            }
        }
        
        clazz = class_getSuperclass(clazz);
        if (clazz == [NSObject class]) break;
    }
    
    return methodNames;
}

+ (NSArray *)allInstanceMethods:(NSString *)prefix
{
    NSArray *methods = [self allInstanceMethods];
    if (nil == methods || 0 == methods.count) {
        return nil;
    }
    
    if (nil == prefix) {
        return methods;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *selectorName in methods) {
        if (NO == [selectorName hasPrefix:prefix]) continue;
        
        [result addObject:selectorName];
    }
    return result;
}

//Swizzle
+ (BOOL)swizzleMethod:(SEL)originalSelector with:(SEL)anotherSelector
{
    return [self swizzleMethod:originalSelector with:anotherSelector in:self];
}

+ (BOOL)swizzleMethod:(SEL)originalSelector with:(SEL)anotherSelector in:(Class)anotherClass
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method anotherMethod  = class_getInstanceMethod(anotherClass, anotherSelector);
    if(!originalMethod || !anotherMethod) {
        return NO;
    }
    IMP originalMethodImplementation = class_getMethodImplementation(self, originalSelector);
    IMP anotherMethodImplementation  = class_getMethodImplementation(anotherClass, anotherSelector);
    if(class_addMethod(self, originalSelector, originalMethodImplementation, method_getTypeEncoding(originalMethod))) {
        originalMethod = class_getInstanceMethod(self, originalSelector);
    }
    if(class_addMethod(anotherClass, anotherSelector,  anotherMethodImplementation,  method_getTypeEncoding(anotherMethod))) {
        anotherMethod = class_getInstanceMethod(anotherClass, anotherSelector);
    }
    method_exchangeImplementations(originalMethod, anotherMethod);
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originalSelector with:(SEL)anotherSelector
{
    return [self swizzleClassMethod:originalSelector with:anotherSelector in:self];
}

+ (BOOL)swizzleClassMethod:(SEL)originalSelector with:(SEL)anotherSelector in:(Class)anotherClass
{
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method anotherMethod  = class_getClassMethod(anotherClass, anotherSelector);
    if(!originalMethod || !anotherMethod) {
        return NO;
    }
    Class metaClass = objc_getMetaClass(class_getName(self));
    Class anotherMetaClass = objc_getMetaClass(class_getName(anotherClass));
    IMP originalMethodImplementation = class_getMethodImplementation(metaClass, originalSelector);
    IMP anotherMethodImplementation  = class_getMethodImplementation(anotherMetaClass, anotherSelector);
    if(class_addMethod(metaClass, originalSelector, originalMethodImplementation, method_getTypeEncoding(originalMethod))) {
        originalMethod = class_getClassMethod(self, originalSelector);
    }
    if(class_addMethod(anotherMetaClass, anotherSelector,  anotherMethodImplementation,  method_getTypeEncoding(anotherMethod))) {
        anotherMethod = class_getClassMethod(anotherClass, anotherSelector);
    }
    method_exchangeImplementations(originalMethod, anotherMethod);
    return YES;
}

//Property
- (id)getAssociatedObjectForKey:(const char *)key
{
    const char * propName = key;
    
    id currValue = objc_getAssociatedObject( self, propName );
    return currValue;
}

- (id)setAssociatedObject:(id)obj forKey:(const char *)key policy:(objc_AssociationPolicy)policy
{
    const char * propName = key;
    
    id oldValue = objc_getAssociatedObject( self, propName );
    objc_setAssociatedObject( self, propName, obj, policy );
    return oldValue;
}

- (id)setAssociatedObject:(id)obj forKey:(const char *)key
{
    return [self setAssociatedObject:obj forKey:key policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (id)copyAssociatedObject:(id)obj forKey:(const char *)key
{
    return [self setAssociatedObject:obj forKey:key policy:OBJC_ASSOCIATION_COPY];
}

- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;
{
    return [self setAssociatedObject:obj forKey:key policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (id)assignAssociatedObject:(id)obj forKey:(const char *)key
{
    return [self setAssociatedObject:obj forKey:key policy:OBJC_ASSOCIATION_ASSIGN];
}

- (void)removeAssociatedObjectForKey:(const char *)key
{
    const char * propName = key;
    
    objc_setAssociatedObject( self, propName, nil, OBJC_ASSOCIATION_ASSIGN );
}

- (void)removeAllAssociatedObjects
{
    objc_removeAssociatedObjects( self );
}

//Empty
- (BOOL)isNotNull
{
    return !(self == nil ||
            [self isKindOfClass:[NSNull class]]);
}

- (BOOL)isNotEmpty
{
    return !(self == nil ||
            [self isKindOfClass:[NSNull class]] ||
            ([self respondsToSelector:@selector(length)] && [(NSData *)self length] == 0) ||
            ([self respondsToSelector:@selector(count)] && [(NSArray *)self count] == 0));
}

@end

@implementation NSNotification (Framework)

- (BOOL)isKind:(NSString *)name
{
    return [self.name isEqualToString:name];
}

- (BOOL)isType:(NSString *)type
{
    return [self.name hasPrefix:type];
}

@end
