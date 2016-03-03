//
//  UIColor+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Framework)

//十六进制，默认透明度1
+ (UIColor *)colorWithHex:(NSString *)hex;
+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

//颜色值，默认透明度1
+ (UIColor *)colorWithValue:(NSString *)value;
+ (UIColor *)colorWithValue:(NSString *)value alpha:(CGFloat)alpha;

//读取颜色值，默认不含透明度
+ (NSString *)stringFromColor:(UIColor *)color;
+ (NSString *)stringFromColor:(UIColor *)color alpha:(BOOL)alpha;

@end
