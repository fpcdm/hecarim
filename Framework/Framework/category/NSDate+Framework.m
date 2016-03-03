//
//  NSDate+Framework.m
//  Framework
//
//  Created by wuyong on 16/2/22.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "NSDate+Framework.h"

@implementation NSDate (Framework)

+ (NSDate *)dateWithString:(NSString *)string
{
    return [self dateWithString:string format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSDate *date = [formatter dateFromString:string];
    return date;
}

+ (NSDate *)dateWithTimestamp:(NSTimeInterval)timestamp
{
    return [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];
}

+ (NSDate *)dateWithInterval:(NSTimeInterval)interval
{
    return [[NSDate alloc] initWithTimeIntervalSinceNow:interval];
}

- (NSString *)toString
{
    return [self toString:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)toString:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSString *string = [formatter stringFromDate:self];
    return string;
}

- (NSTimeInterval)toTimestamp
{
    return [self timeIntervalSince1970];
}

- (NSTimeInterval)toInterval
{
    return [self timeIntervalSinceNow];
}

@end
