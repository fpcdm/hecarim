//
//  NotificationUtil.h
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NotificationUtil : NSObject

+ (void) registerLocalNotification: (NSString *) userInfoKey alertBody: (NSString *) alertBody time: (NSInteger) time;

+ (void) receiveLocalNotification: (UILocalNotification *) notification;

+ (void) cancelLocalNotifications;

+ (void) receiveRemoteNotification: (NSDictionary *)userInfo state: (UIApplicationState) state;

+ (void) cancelRemoteNotifications;

@end
