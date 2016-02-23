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
#undef notification
#define notification( __name ) \
static_property( __name )

#undef def_notification
#define def_notification( __name ) \
def_static_property3( __name, @"notification", NSStringFromClass([self class]) )

#undef	handleNotification
#define handleNotification( __notification ) \
- (void)handleNotification:(NSNotification *)__notification

#undef	handleNotification2
#define handleNotification2( __filter, __notification ) \
- (void)handleNotification_##__filter:(NSNotification *)__notification

#undef	handleNotification3
#define handleNotification3( __class, __name, __notification ) \
- (void)handleNotification_##__class##_##__name:(NSNotification *)__notification

#pragma mark -
@interface NSNotification (FWNotification)

- (BOOL)isName:(NSString *)name;

- (BOOL)isType:(NSString *)type;

@end

#pragma mark -
@interface NSObject (FWNotification)

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

@end
