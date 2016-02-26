//
//  FWLog.m
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWLog.h"

//定义默认log级别，小于Verbose
#define FWLogTypeDefault (1 << 5)  // 0...100000

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

//全局日志级别
static FWLogLevel globalLogLevel = FRAMEWORK_LOG_LEVEL;

@implementation FWLog

+ (void)setLevel:(FWLogLevel)level
{
    globalLogLevel = level;
}

+ (void)_log:(FWLogType)type message:(NSString *)message
{
#ifdef APP_DEBUG
    //过滤级别
    if (!(globalLogLevel & type)) return;
#endif
    
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
        
        //自定义颜色，区别于NSLog
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithHex:@"#20B2AA"] backgroundColor:nil forFlag:DDLogFlagInfo];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithHex:@"#808080"] backgroundColor:nil forFlag:DDLogFlagDebug];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithHex:@"#9370D8"] backgroundColor:nil forFlag:DDLogFlagVerbose];
    }
    
    switch (type) {
        case FWLogTypeError:
            DDLogError(@"ERROR: %@", message);
            break;
        case FWLogTypeWarn:
            DDLogWarn(@"WARN: %@", message);
            break;
        case FWLogTypeInfo:
            DDLogInfo(@"INFO: %@", message);
            break;
        case FWLogTypeDebug:
            DDLogDebug(@"DEBUG: %@", message);
            break;
        case FWLogTypeVerbose:
            [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithHex:@"#9370D8"] backgroundColor:nil forFlag:DDLogFlagVerbose];
            DDLogVerbose(@"VERBOSE: %@", message);
            break;
        default:
            [[DDTTYLogger sharedInstance] setForegroundColor:nil backgroundColor:nil forFlag:DDLogFlagVerbose];
            DDLogVerbose(@"%@", message);
            break;
    }
    
    //真机
#else
    
    switch (type) {
        case FWLogTypeError:
            NSLog(@"ERROR: %@", message);
            break;
        case FWLogTypeWarn:
            NSLog(@"WARN: %@", message);
            break;
        case FWLogTypeInfo:
            NSLog(@"INFO: %@", message);
            break;
        case FWLogTypeDebug:
            NSLog(@"DEBUG: %@", message);
            break;
        case FWLogTypeVerbose:
            NSLog(@"VERBOSE: %@", message);
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
        [self _log:FWLogTypeDefault message:message];
        va_end(args);
    }
#endif
}

+ (void)verbose:(NSString *)format, ...
{
#ifdef APP_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:FWLogTypeVerbose message:message];
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

@end
