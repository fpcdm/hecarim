//
//  UIColor+Framework.h
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Framework)

//十六进制
+ (UIColor *)colorWithHex:(NSString *)hex;
+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;

//值
+ (UIColor *)colorWithValue:(NSString *)value;
+ (UIColor *)colorWithValue:(NSString *)value alpha:(CGFloat)alpha;

//读取
+ (NSString *)stringFromColor:(UIColor *)color;

@end
