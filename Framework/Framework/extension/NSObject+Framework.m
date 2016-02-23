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


