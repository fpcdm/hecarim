//
//  FWLog.h
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWLog : NSObject

/**
 *  普通日志
 */
+ (void)log:(NSString *)format, ...;

/**
 *  调试日志
 */
+ (void)debug:(NSString *)format, ...;

/**
 *  消息日志
 */
+ (void)info:(NSString *)format, ...;

/**
 *  警告日志
 */
+ (void)warn:(NSString *)format, ...;

/**
 *  错误日志
 */
+ (void)error:(NSString *)format, ...;

/**
 *  调试对象
 */
+ (void)dump:(id)object;

@end
