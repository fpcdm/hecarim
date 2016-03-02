//
//  FWNotification.h
//  Framework
//
//  Created by wuyong on 16/2/23.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
//@notification
#undef  notification
#define notification( __name ) \
    static_property( __name )

#undef  def_notification
#define def_notification( __name ) \
    def_static_property3( __name, @"notification", NSStringFromClass([self class]) )

#undef  makeNotification
#define makeNotification( ... ) \
    macro_string(macro_make(notification, __VA_ARGS__))

#undef	handleNotification
#define handleNotification( ... ) \
    - (void) macro_method(handleNotification, __VA_ARGS__):(NSNotification *)notification

typedef NSObject* (^FWNotificationBlock)(NSString *name, id block);

#pragma mark -
@interface NSObject (FWNotificationResponder)

@prop_readonly(FWNotificationBlock, onNotification)

- (void)handleNotification:(NSNotification *)notification;

- (void)observeNotification:(NSString *)name;
- (void)observeAllNotifications;

- (void)unobserveNotification:(NSString *)name;
- (void)unobserveAllNotifications;

@end

#pragma mark -
@interface NSObject (FWNotificationSender)

+ (BOOL)postNotification:(NSString *)name;
- (BOOL)postNotification:(NSString *)name;

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;
+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object;

@end

#pragma mark -
@interface NSNotification (FWNotification)

- (BOOL)isName:(NSString *)name;

@end
