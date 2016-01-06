//
//  LogUtil.h
//  LttMember
//
//  Created by wuyong on 16/1/6.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FrameworkConfig.h"

//开发环境
#ifdef LTT_DEBUG

//模拟器
#if TARGET_IPHONE_SIMULATOR

//DDLog调试级别，需要安装XcodeColors
#define LOG_LEVEL_DEF DDLogLevelAll

//修改NSLog为DDLog
#define NSLog(...) DDLogVerbose(__VA_ARGS__);

//导入DDLog
#import "CocoaLumberjack.h"

//真机
#else

//使用原生NSLog

#endif

//正式环境
#else

//关闭NSLog
#define NSLog(...)

#endif

typedef enum {
    LogTypeLog = 0,
    LogTypeDebug,
    LogTypeInfo,
    LogTypeWarn,
    LogTypeError
} LogType;

@interface LogUtil : NSObject

+ (void)log:(LogType)type format:(NSString *)format, ...;

+ (void)log:(NSString *)format, ...;

+ (void)debug:(NSString *)format, ...;

+ (void)info:(NSString *)format, ...;

+ (void)warn:(NSString *)format, ...;

+ (void)error:(NSString *)format, ...;

@end
