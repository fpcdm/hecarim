//
//  UIColor+Hex.h
//  LttCustomer
//
//  Created by wuyong on 15/5/5.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

//兼容方法
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//十六进制
+ (UIColor *)colorWithHex:(NSString *)hex;
+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

//值
+ (UIColor *)colorWithValue:(NSString *)value;
+ (UIColor *)colorWithValue:(NSString *)value alpha:(CGFloat)alpha;

//读取
+ (NSString *)stringFromColor:(UIColor *)color;

@end
