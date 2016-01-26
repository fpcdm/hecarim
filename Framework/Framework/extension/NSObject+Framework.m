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

@end
