//
//  ValidateUtil.h
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+trim.h"

@interface ValidateUtil : NSObject

+ (BOOL) isRequired: (NSString *) value;
+ (BOOL) isLength: (NSString *) value length: (NSInteger) length;
+ (BOOL) isMobile: (NSString *) value;
+ (BOOL) isLengthBetween: (NSString *) value from: (NSInteger) from to: (NSInteger) to;
//是否是正整数
+ (BOOL) isPositiveInteger: (NSString *) value;
//是否是正数
+ (BOOL) isPositiveNumber: (NSString *) value;

@end
