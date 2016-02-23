//
//  NSString+Framework.m
//  Framework
//
//  Created by wuyong on 16/2/17.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "NSString+Framework.h"

@implementation NSString (Framework)

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)ltrim
{
    NSRange rangeOfFirstWantedCharacter = [self rangeOfCharacterFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]];
    if (rangeOfFirstWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:rangeOfFirstWantedCharacter.location];
}

- (NSString *)rtrim
{
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
                                                               options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringToIndex:rangeOfLastWantedCharacter.location + 1];
}

- (BOOL)isFormatRegex:(NSString *)regex
{
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regexPredicate evaluateWithObject:self] == YES;
}

- (BOOL)isFormatMobile
{
    return [self isFormatRegex:@"^1\\d{10}$"];
}

- (BOOL)isFormatTelephone
{
    return [self isFormatRegex:@"^(\\d{3}\\-)?\\d{8}|(\\d{4}\\-)?\\d{7}$"];
}

- (BOOL)isFormatInteger
{
    return [self isFormatRegex:@"^\\-?\\d+$"];
}

- (BOOL)isFormatNumber
{
    return [self isFormatRegex:@"^\\-?\\d+\\.?\\d*$"];
}

- (BOOL)isFormatMoney
{
    return [self isFormatRegex:@"^\\d+\\.?\\d{0,2}$"];
}

- (BOOL)isFormatIdcard
{
    return [self isFormatRegex:@"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}(\\d|x|X)$"];
}

- (BOOL)isFormatIp
{
    return [self isFormatRegex:@"^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$"];
}

- (BOOL)isFormatUrl
{
    return ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) ? YES : NO;
}

- (BOOL)isFormatEmail
{
    return [self isFormatRegex:@"^[A-Z0-9a-z._\%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"];
}

- (BOOL)isFormatChinese
{
    return [self isFormatRegex:@"^[\\x{4e00}-\\x{9fa5}]+$"];
}

- (BOOL) isFormatDate
{
    return [self isFormatRegex:@"^\\d{4}\\-\\d{2}\\-\\d{2}\\s\\d{2}\\:\\d{2}\\:\\d{2}$"];
}

@end
