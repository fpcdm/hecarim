//
//  NSDate+Framework.h
//  Framework
//
//  Created by wuyong on 16/2/22.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Framework)

//从字符串初始化日期，格式：yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateWithString:(NSString *)string;

//从字符串初始化日期，自定义格式
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format;

//从时间戳初始化日期
+ (NSDate *)dateWithTimestamp:(NSTimeInterval)timestamp;

//从当前时间间隔获取日期
+ (NSDate *)dateWithInterval:(NSTimeInterval)interval;

//转化为字符串，格式：yyyy-MM-dd HH:mm:ss
- (NSString *)toString;

//转化为字符串，自定义格式
- (NSString *)toString:(NSString *)format;

//转换为时间戳
- (NSTimeInterval)toTimestamp;

//转换为当前时间间隔
- (NSTimeInterval)toInterval;

@end
