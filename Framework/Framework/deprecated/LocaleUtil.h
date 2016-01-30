//
//  LocaleUtil.h
//  LttMember
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocaleUtil : NSObject

//读取本地化字符串
+ (NSString *)localize:(NSString *)key file:(NSString *)file;

//读取系统消息，如Loading.Start
+ (NSString *)system:(NSString *)key;

//读取错误消息，如Mobile.Required
+ (NSString *)error:(NSString *)key;

//读取提示消息，如Login.Success
+ (NSString *)info:(NSString *)key;

//读取普通文本，如Title.Home
+ (NSString *)text:(NSString *)key;

@end
