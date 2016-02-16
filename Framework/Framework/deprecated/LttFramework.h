//
//  LttFramework.h
//  Framework
//
//  Created by wuyong on 16/2/16.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Framework.h"

/***************************/
#import "FrameworkConfig.h"

/***************************/
typedef FWLocale LocaleUtil;

/***************************/
@interface UIColor (Hex)

//兼容方法
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end

/****************************/
@interface NSString (Trim)

+ (NSString *)trim:(NSString *)str;

- (NSString *)trim;

@end
