//
//  FWLog.h
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//日志类型定义
typedef NS_OPTIONS(NSUInteger, FWLogType) {
    FWLogTypeError   = (1 << 0), // 0...00001
    FWLogTypeWarn    = (1 << 1), // 0...00010
    FWLogTypeInfo    = (1 << 2), // 0...00100
    FWLogTypeDebug   = (1 << 3), // 0...01000
    FWLogTypeVerbose = (1 << 4)  // 0...10000
};

//日志级别定义
typedef NS_ENUM(NSUInteger, FWLogLevel) {
    FWLogLevelOff     = 0,
    FWLogLevelError   = (FWLogTypeError),                     // 0...00001
    FWLogLevelWarn    = (FWLogLevelError | FWLogTypeWarn),    // 0...00011
    FWLogLevelInfo    = (FWLogLevelWarn  | FWLogTypeInfo),    // 0...00111
    FWLogLevelDebug   = (FWLogLevelInfo  | FWLogTypeDebug),   // 0...01111
    FWLogLevelVerbose = (FWLogLevelDebug | FWLogTypeVerbose), // 0...11111
    FWLogLevelAll     = NSUIntegerMax                         // 1...11111
};

@interface FWLog : NSObject

/**
 *  设置日志级别
 */
+ (void)setLevel:(FWLogLevel)level;

/**
 *  默认级别
 */
+ (void)log:(NSString *)format, ...;

/**
 *  详细日志
 */
+ (void)verbose:(NSString *)format, ...;

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
 *  调试对象，仅支持部分格式，详见代码
 */
+ (void)dump:(NSString *)format, ...;

@end
