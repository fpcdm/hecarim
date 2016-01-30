//
//  LocaleUtil.m
//  LttMember
//
//  Created by wuyong on 16/1/5.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "LocaleUtil.h"
#import "FWLocale.h"

@implementation LocaleUtil

+ (NSString *)localize:(NSString *)key file:(NSString *)file
{
    return [FWLocale localize:key file:file];
}

+ (NSString *)system:(NSString *)key
{
    return [FWLocale system:key];
}

+ (NSString *)error:(NSString *)key
{
    return [FWLocale error:key];
}

+ (NSString *)info:(NSString *)key
{
    return [FWLocale info:key];
}

+ (NSString *)text:(NSString *)key
{
    return [FWLocale text:key];
}

@end
