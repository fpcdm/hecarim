//
//  FWHelperDate.h
//  Framework
//
//  Created by 吴勇 on 16/2/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//todo: 优化

@interface FWHelperDate : NSObject

// 当前时间戳
+ (NSTimeInterval)formatTimeSinceNow:(NSTimeInterval)timestamp;

//根据timestamp来获取日期
+ (NSString *)formatTime:(NSTimeInterval)timestamp formatWith:(NSString *)format;

//根据date来获取日期
+ (NSString *)formatDate:(NSDate *)date formatWith:(NSString *)format;

//根据timestamp偏差来获取日期
+ (NSString *)formatDateSinceNow:(NSTimeInterval)timestamp formatWith:(NSString *)format;

//获取时间差
+ (NSString *)getTimeDiffString:(NSTimeInterval)timestamp;

//格式化时间 e.p “从 2013-8-12 至 2013-8-18 "
+ (NSString *)getWeekKeyString:(NSTimeInterval)timestamp;

+ (NSString *)getFirstDayForWeekKeyString:(NSTimeInterval)timestamp;

//格式化时间 e.p 2013-08
+ (NSString *)getMonthKeyStringByOffset:(NSInteger)month;

+ (NSInteger)getTotalDayInMonth:(NSTimeInterval)timestamp;

//获取本星期的第一天的timestamp
+ (NSTimeInterval)getFirstDayOfWeek:(NSTimeInterval)timestamp;

//获取本月第一天的timestamp
+ (NSTimeInterval)getFirstDayOfMonth:(NSTimeInterval)timestamp;

//获取上月第一天的timestamp
+ (NSTimeInterval)getFirstDayOfLastMonth:(NSTimeInterval)timestamp;

//获取本季度第一天的timestamp
+ (NSTimeInterval)getFirstDayOfQuarter:(NSTimeInterval)timestamp;

@end
