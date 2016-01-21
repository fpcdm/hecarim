//
//  DeviceUtil.h
//  Framework
//
//  Created by wuyong on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUtil : NSObject

//发送邮件
+ (void)sendMail:(NSString *)mail;

//打电话
+ (void)makePhoneCall:(NSString *)tel;

//发短信
+ (void)sendSMS:(NSString *)tel;

//打开URL
+ (void)openURLWithSafari:(NSString *)url;

+ (NSString *)getNameFromAddressBookWithPhoneNum:(NSString *)tel;

@end
