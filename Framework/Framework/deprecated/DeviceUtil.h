//
//  DeviceUtil.h
//  Framework
//
//  Created by wuyong on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUtil : NSObject

//播放声音
+ (BOOL)playMusic:(NSString *)file;

//打开功能
+ (BOOL)openUrl:(NSString *)url;

//发送邮件
+ (BOOL)sendEmail:(NSString *)email;

//发短信
+ (BOOL)sendSms:(NSString *)phone;

//打开浏览器
+ (BOOL)openSafari:(NSString *)url;

//打电话
+ (BOOL)makePhoneCall:(NSString *)phone;

//获取电话姓名
+ (NSString *)getPhoneName:(NSString *)phone;

@end
