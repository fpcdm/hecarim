//
//  NSObject+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Framework)

//Notification
@static_string(NOTIFICATION)

@static_string(NOTIFICATION_TYPE)

- (void)handleNotification:(NSNotification *)notification;

- (void)observeNotification:(NSString *)name;

- (void)observeAllNotifications;

- (void)unobserveNotification:(NSString *)name;

- (void)unobserveAllNotifications;

- (BOOL)postNotification:(NSString *)name;

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

+ (BOOL)postNotification:(NSString *)name;

+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

//Runtime
+ (NSArray *)allInstanceMethods;

+ (NSArray *)allInstanceMethods:(NSString *)prefix;

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

@interface NSNotification (Framework)

- (BOOL)isKind:(NSString *)name;

- (BOOL)isType:(NSString *)type;

@end
