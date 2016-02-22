//
//  FWHelperDevice.h
//  Framework
//
//  Created by 吴勇 on 16/2/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWHelperDevice : NSObject

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

@end
