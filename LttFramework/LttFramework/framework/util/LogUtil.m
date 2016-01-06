//
//  LogUtil.m
//  LttMember
//
//  Created by wuyong on 16/1/6.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "LogUtil.h"

#ifdef LTT_DEBUG
#if TARGET_IPHONE_SIMULATOR
//模拟器DDLog配置
static BOOL isDDLogInited = false;
#endif
#endif

@implementation LogUtil

+ (void)_log:(LogType)type message:(NSString *)message
{
//开发环境
#ifdef LTT_DEBUG
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
        case LogTypeDebug:
            DDLogDebug(@"%@", message);
            break;
        case LogTypeInfo:
            DDLogInfo(@"%@", message);
            break;
        case LogTypeWarn:
            DDLogWarn(@"%@", message);
            break;
        case LogTypeError:
            DDLogError(@"%@", message);
            break;
        default:
            DDLogVerbose(@"%@", message);
            break;
    }
    
//真机
#else
    
    NSLog(message);
    
#endif
//正式环境
#else
    
    //什么也不做
    
#endif
}

+ (void)log:(LogType)type format:(NSString *)format, ...
{
#ifdef LTT_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:type message:message];
        va_end(args);
    }
#endif
}

+ (void)log:(NSString *)format, ...
{
#ifdef LTT_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:LogTypeLog message:message];
        va_end(args);
    }
#endif
}

+ (void)debug:(NSString *)format, ...
{
#ifdef LTT_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:LogTypeDebug message:message];
        va_end(args);
    }
#endif
}

+ (void)info:(NSString *)format, ...
{
#ifdef LTT_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:LogTypeInfo message:message];
        va_end(args);
    }
#endif
}

+ (void)warn:(NSString *)format, ...
{
#ifdef LTT_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:LogTypeWarn message:message];
        va_end(args);
    }
#endif
}

+ (void)error:(NSString *)format, ...
{
#ifdef LTT_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:LogTypeError message:message];
        va_end(args);
    }
#endif
}

@end
