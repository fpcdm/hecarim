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

- (NSString *)lcfirst
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].lowercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

- (NSString *)ucfirst
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].uppercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

- (NSString *)underlineString
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        NSString *cStringLower = [cString lowercaseString];
        if ([cString isEqualToString:cStringLower]) {
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:cStringLower];
        }
    }
    return string;
}

- (NSString *)camelString
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    NSArray *cmps = [self componentsSeparatedByString:@"_"];
    for (NSUInteger i = 0; i<cmps.count; i++) {
        NSString *cmp = cmps[i];
        if (i && cmp.length) {
            [string appendString:[NSString stringWithFormat:@"%c", [cmp characterAtIndex:0]].uppercaseString];
            if (cmp.length >= 2) [string appendString:[cmp substringFromIndex:1]];
        } else {
            [string appendString:cmp];
        }
    }
    return string;
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

- (CGSize) boundingSize:(CGSize)size withFont:(UIFont *)font
{
    //参数默认值
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(SCREEN_WIDTH, MAXFLOAT);
    }
    if (font == nil) {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    return rect.size;
}

@end

//UnitTest
#if FRAMEWORK_TEST
TEST_CASE(extension, NSString_Framework)

TEST(trim)
{
    EXPECTED([@"trim" isEqualToString:[@" trim " trim]])
    EXPECTED([@"trim " isEqualToString:[@" trim " ltrim]])
    EXPECTED([@" trim" isEqualToString:[@" trim " rtrim]])
}

TEST(format)
{
    EXPECTED(@"18875001455".isFormatMobile)
    EXPECTED(!@"1887500145".isFormatMobile)
    
    EXPECTED(@"023-86754321".isFormatTelephone)
    EXPECTED(@"7654321".isFormatTelephone)
    EXPECTED(!@"0238-87654321".isFormatTelephone)
    EXPECTED(!@"654321".isFormatTelephone)
    
    EXPECTED(@"-20".isFormatInteger)
    EXPECTED(@"0".isFormatInteger)
    EXPECTED(!@"20.1".isFormatInteger)
    
    EXPECTED(@"20.123".isFormatNumber)
    EXPECTED(@"0".isFormatNumber)
    EXPECTED(!@"20.X".isFormatNumber)
    
    EXPECTED(@"20.12".isFormatMoney)
    EXPECTED(@"0".isFormatMoney)
    EXPECTED(!@"-5".isFormatMoney)
    EXPECTED(!@"20.1234".isFormatMoney)
    
    EXPECTED(@"511222198701014343".isFormatIdcard)
    EXPECTED(@"51122219870101434X".isFormatIdcard)
    EXPECTED(!@"51122219871332434X".isFormatIdcard)
    EXPECTED(!@"51122219870101".isFormatIdcard)
    
    EXPECTED(@"127.0.0.1".isFormatIp)
    EXPECTED(!@"127.0.0".isFormatIp)
    
    EXPECTED(@"http://www.baidu.com".isFormatUrl)
    EXPECTED(!@"www.baidu.com".isFormatUrl)
    
    EXPECTED(@"test@test.com".isFormatEmail)
    EXPECTED(!@"test.com".isFormatEmail)
    
    EXPECTED(@"中文".isFormatChinese)
    EXPECTED(!@"中文abc".isFormatChinese)
    EXPECTED(!@"abc".isFormatChinese)
    
    EXPECTED(@"2014-01-01 12:00:00".isFormatDate)
    EXPECTED(!@"20140101".isFormatDate)
}

TEST_CASE_END
#endif
