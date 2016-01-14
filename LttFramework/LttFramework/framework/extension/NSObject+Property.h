//
//  NSObject+Property.h
//  LttMember
//
//  Created by wuyong on 16/1/14.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

- (id)getAssociatedObjectForKey:(const char *)key;

//默认retain
- (id)setAssociatedObject:(id)obj forKey:(const char *)key;

- (id)copyAssociatedObject:(id)obj forKey:(const char *)key;

- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;

- (id)assignAssociatedObject:(id)obj forKey:(const char *)key;

- (void)removeAssociatedObjectForKey:(const char *)key;

- (void)removeAllAssociatedObjects;

@end
