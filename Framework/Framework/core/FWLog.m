//
//  FWLog.m
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWLog.h"

//日志类型枚举
typedef enum {
    FWLogTypeLog = 0,
    FWLogTypeDebug,
    FWLogTypeInfo,
    FWLogTypeWarn,
    FWLogTypeError
} FWLogType;

#ifdef APP_DEBUG

//dump
#import "FWRuntime.h"

#endif

#ifdef APP_DEBUG
#if TARGET_IPHONE_SIMULATOR

//DDLog调试级别，需要安装XcodeColors，需在导入DDLog前设置
#define LOG_LEVEL_DEF DDLogLevelAll

//导入DDLog
#import "CocoaLumberjack.h"

//模拟器DDLog配置
static BOOL isDDLogInited = false;

#endif
#endif

@implementation FWLog

+ (void)_log:(FWLogType)type message:(NSString *)message
{
    //开发环境
#ifdef APP_DEBUG
    //模拟器
#if TARGET_IPHONE_SIMULATOR
    
    if (!isDDLogInited) {
        isDDLogInited = YES;
        
        //模拟器开启颜色
        setenv("XcodeColors", "YES", 1);
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        
        //自定义颜色
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagInfo];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor grayColor] backgroundColor:nil forFlag:DDLogFlagDebug];
    }
    
    switch (type) {
        case FWLogTypeDebug:
            DDLogDebug(@"DEBUG: %@", message);
            break;
        case FWLogTypeInfo:
            DDLogInfo(@"INFO: %@", message);
            break;
        case FWLogTypeWarn:
            DDLogWarn(@"WARN: %@", message);
            break;
        case FWLogTypeError:
            DDLogError(@"ERROR: %@", message);
            break;
        default:
            DDLogVerbose(@"%@", message);
            break;
    }
    
    //真机
#else
    
    switch (type) {
        case FWLogTypeDebug:
            NSLog(@"DEBUG: %@", message);
            break;
        case FWLogTypeInfo:
            NSLog(@"INFO: %@", message);
            break;
        case FWLogTypeWarn:
            NSLog(@"WARN: %@", message);
            break;
        case FWLogTypeError:
            NSLog(@"ERROR: %@", message);
            break;
        default:
            NSLog(@"%@", message);
            break;
    }
    
#endif
    //正式环境
#else
    
    //什么也不做
    
#endif
}

+ (void)log:(NSString *)format, ...
{
#ifdef APP_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:FWLogTypeLog message:message];
        va_end(args);
    }
#endif
}

+ (void)debug:(NSString *)format, ...
{
#ifdef APP_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:FWLogTypeDebug message:message];
        va_end(args);
    }
#endif
}

+ (void)info:(NSString *)format, ...
{
#ifdef APP_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:FWLogTypeInfo message:message];
        va_end(args);
    }
#endif
}

+ (void)warn:(NSString *)format, ...
{
#ifdef APP_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:FWLogTypeWarn message:message];
        va_end(args);
    }
#endif
}

+ (void)error:(NSString *)format, ...
{
#ifdef APP_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:FWLogTypeError message:message];
        va_end(args);
    }
#endif
}

+ (void)dump:(id)object
{
#ifdef APP_DEBUG
    NSString *clazz = [[object class] description];
    //NSClass,_NSInlineClass,__NSClass,...
    if ([clazz hasPrefix:@"NS"] || [clazz hasPrefix:@"_NS"] || [clazz hasPrefix:@"__NS"] ||
        //UIView,...
        [clazz hasPrefix:@"UI"]) {
        [self debug:@"%@: %@", clazz, object];
    } else {
        [self debug:@"%@: %@", clazz, [FWRuntime propertiesOfObject:object]];
    }
#endif
}

@end
