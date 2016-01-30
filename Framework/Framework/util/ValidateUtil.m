//
//  ValidateUtil.m
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "ValidateUtil.h"
#import "NSString+Framework.h"

@implementation ValidateUtil

+ (BOOL) isRequired: (NSString *) value
{
    return value != nil && [[value trim] length] > 0;
}

+ (BOOL) isLength: (NSString *) value length: (NSInteger) length;
{
    NSInteger len = (value == nil) ? 0 : [value length];
    return len == length;
}

+ (BOOL) isMobile: (NSString *) value
{
    NSPredicate *regexMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1\\d{10}$"];
    if ([regexMobile evaluateWithObject:value] == YES) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) isLengthBetween: (NSString *) value from: (NSInteger) from to: (NSInteger) to;
{
    NSInteger len = (value == nil) ? 0 : [value length];
    return len >= from && len <= to;
}

+ (BOOL) isPositiveInteger:(NSString *)value
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[1-9]\\d*$"];
    if ([regex evaluateWithObject:value] == YES) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL) isPositiveNumber:(NSString *)value
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[\\d\\.]+$"];
    if ([regex evaluateWithObject:value] == YES) {
        float number = [value floatValue];
        return number > 0 ? YES : NO;
    } else {
        return NO;
    }
}

@end
