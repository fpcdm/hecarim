//
//  NotificationUtil.m
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "NotificationUtil.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation NotificationUtil

// 注册通知
+ (void) registerLocalNotification:(NSString *)userInfoKey alertBody:(NSString *)alertBody time:(NSInteger)time
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //设置通知时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:time];
    notification.fireDate = fireDate;
    
    //时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    //重复间隔
    notification.repeatInterval = 0;
    
    //通知内容
    notification.alertBody = alertBody;
    notification.applicationIconBadgeNumber += 1;
    
    //声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    //通知参数
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:alertBody forKey:userInfoKey];
    notification.userInfo = userInfo;
    
    //兼容iOS8，需要添加此注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    //执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 本地通知回调函数，应用程序在前台时调用
+ (void) receiveLocalNotification: (UILocalNotification *) notification
{
    //取消本地通知
    [self cancelLocalNotifications];
}

// 取消所有本地通知
+ (void) cancelLocalNotifications
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

// 收到远程消息
+ (void) receiveRemoteNotification:(NSDictionary *)userInfo
{
    // 整理并保存数据
    userInfo = [[StorageUtil sharedStorage] prepareDictionary:userInfo];
    [[StorageUtil sharedStorage] setRemoteNotification:userInfo];
    
    // 检测声音文件
    NSString *soundName = nil;
    if (userInfo) {
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        if (aps) soundName = [aps objectForKey:@"sound"];
    }
    
    // 文件是否存在
    NSString *soundFile = nil;
    if (soundName && ![@"default" isEqualToString:soundName]) {
        soundFile = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];
        if (soundFile && ![[NSFileManager defaultManager] fileExistsAtPath:soundFile]) {
            soundFile = nil;
        }
    }
    
    // 播放内置声音
    if (soundFile) {
        NSURL *soundUrl = [NSURL fileURLWithPath:soundFile];
        SystemSoundID soundId = 0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &soundId);
        AudioServicesPlaySystemSound(soundId);
    // 播放系统声音
    } else {
        AudioServicesPlaySystemSound(1007);
    }
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

// 取消所有远程消息
+ (void) cancelRemoteNotifications
{
    // 清除数据
    [[StorageUtil sharedStorage] setRemoteNotification:nil];
    
    // 清空计数
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


@end
