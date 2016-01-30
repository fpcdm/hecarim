//
//  FWLocale.m
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWLocale.h"

@implementation FWLocale

+ (NSString *)localize:(NSString *)key file:(NSString *)file
{
    return [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:file];
}

+ (NSString *)system:(NSString *)key
{
    return [self localize:[NSString stringWithFormat:@"SYSTEM.%@", key] file:@"Framework.bundle/FrameworkPlist"];
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
