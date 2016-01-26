//
//  NSString+Framework.m
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "NSString+Framework.h"

@implementation NSString (Framework)

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
