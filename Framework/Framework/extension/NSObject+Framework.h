//
//  NSObject+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWNotification.h"
#import "FWSignal.h"

@interface NSObject (Framework)
//Swizzle
+ (BOOL)swizzleMethod:(SEL)originalSelector with:(SEL)anotherSelector;

+ (BOOL)swizzleMethod:(SEL)originalSelector with:(SEL)anotherSelector in:(Class)anotherClass;

+ (BOOL)swizzleClassMethod:(SEL)originalSelector with:(SEL)anotherSelector;

+ (BOOL)swizzleClassMethod:(SEL)originalSelector with:(SEL)anotherSelector in:(Class)anotherClass;

//Property
- (id)getAssociatedObjectForKey:(const char *)key;

- (id)setAssociatedObject:(id)obj forKey:(const char *)key;

- (id)copyAssociatedObject:(id)obj forKey:(const char *)key;

- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;

- (id)assignAssociatedObject:(id)obj forKey:(const char *)key;

- (void)removeAssociatedObjectForKey:(const char *)key;

- (void)removeAllAssociatedObjects;

//Empty
- (BOOL)isNotNull;

- (BOOL)isNotEmpty;

@end
