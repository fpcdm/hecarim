//
//  NSString+Trim.m
//  LttCustomer
//
//  Created by wuyong on 15/5/6.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "NSString+Trim.h"

@implementation NSString (Trim)

+ (NSString *)trim:(NSString *)str
{
    return str ? [str trim] : str;
}

- (NSString *)trim
{
    NSString *trimStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimStr;
}

@end
