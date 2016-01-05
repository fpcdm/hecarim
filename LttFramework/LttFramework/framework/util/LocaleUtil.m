//
//  LocaleUtil.m
//  LttMember
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "LocaleUtil.h"

@implementation LocaleUtil

+ (NSString *)localize:(NSString *)key file:(NSString *)file
{
    return [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:file];
}

+ (NSString *)system:(NSString *)key
{
    return [self localize:[NSString stringWithFormat:@"SYSTEM.%@", key] file:@"FrameworkPlist"];
}

+ (NSString *)error:(NSString *)key
{
    return [self localize:[NSString stringWithFormat:@"ERROR.%@", key] file:@"InfoPlist"];
}

+ (NSString *)info:(NSString *)key
{
    return [self localize:[NSString stringWithFormat:@"INFO.%@", key] file:@"InfoPlist"];
}

+ (NSString *)text:(NSString *)key
{
    return [self localize:[NSString stringWithFormat:@"TEXT.%@", key] file:@"InfoPlist"];
}

@end
