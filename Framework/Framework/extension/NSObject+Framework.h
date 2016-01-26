//
//  NSObject+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Framework)

- (id)getAssociatedObjectForKey:(const char *)key;

//默认retain
- (id)setAssociatedObject:(id)obj forKey:(const char *)key;

- (id)copyAssociatedObject:(id)obj forKey:(const char *)key;

- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;

- (id)assignAssociatedObject:(id)obj forKey:(const char *)key;

- (void)removeAssociatedObjectForKey:(const char *)key;

- (void)removeAllAssociatedObjects;

@end
