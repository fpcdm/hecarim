//
//  UIColor+Frontend.h
//  frontend-example
//
//  Created by wuyong on 15/8/24.
//  Copyright (c) 2015年 Lszzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Frontend)

+ (UIColor *)colorWithHex:(NSString *)hex;
+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithValue:(NSString *)value;
+ (UIColor *)colorWithValue:(NSString *)value alpha:(CGFloat)alpha;

+ (NSString *)stringFromColor:(UIColor *)color;

@end
