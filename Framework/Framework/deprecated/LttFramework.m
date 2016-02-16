//
//  LttFramework.m
//  Framework
//
//  Created by wuyong on 16/2/16.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "LttFramework.h"

/**************************/
@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHex:color];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    return [self colorWithHex:color alpha:alpha];
}

@end

/**************************/
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
