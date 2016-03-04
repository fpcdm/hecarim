//
//  FWLog.m
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWLog.h"

#ifdef APP_DEBUG

//导入Runtime
#import "FWRuntime.h"

//DDLog调试级别，需要安装XcodeColors，需在导入DDLog前设置
#define LOG_LEVEL_DEF DDLogLevelAll

//导入DDLog
#import "CocoaLumberjack.h"

//模拟器DDLog配置
static BOOL isDDLogInited = false;

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
    //开启DDLog
    if (!isDDLogInited) {
        isDDLogInited = YES;
        
        //添加ASL终端日志和TTYXcode日志
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        //模拟器开启并自定义颜色
        #if TARGET_IPHONE_SIMULATOR
        setenv("XcodeColors", "YES", 1);
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithHex:@"#20B2AA"] backgroundColor:nil forFlag:DDLogFlagInfo];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithHex:@"#9370D8"] backgroundColor:nil forFlag:DDLogFlagDebug];
        [[DDTTYLogger sharedInstance] setForegroundColor:nil backgroundColor:nil forFlag:DDLogFlagVerbose];
        #endif
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
        default:
            DDLogVerbose(@"%@", message);
            break;
    }
    
//正式环境
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
        default:
            NSLog(@"%@", message);
            break;
    }
    
#endif
}

+ (void)log:(NSString *)format, ...
{
#ifdef APP_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [self _log:FRAMEWORK_LOG_TYPE message:message];
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

+ (void)dump:(NSString *)format, ...
{
#ifdef APP_DEBUG
    va_list args;
    if (format) {
        va_start(args, format);
        //format%@
        NSArray *formatArray = [format componentsSeparatedByString:@"%@"];
        NSUInteger count = formatArray.count > 1 ? formatArray.count - 1 : 0;
        NSString *message = nil;
        if (count < 1) {
            message = [[NSString alloc] initWithFormat:format arguments:args];
        } else {
            id arg;
            NSUInteger i = 0;
            NSString *argClass = nil;
            message = [formatArray objectAtIndex:i];
            while (i < count) {
                arg = va_arg(args, id);
                
                argClass = [[arg class] description];
                //NSClass,_NSInlineClass,__NSClass,...
                if ([argClass hasPrefix:@"NS"] || [argClass hasPrefix:@"_NS"] || [argClass hasPrefix:@"__NS"] ||
                    //UIView,...
                    [argClass hasPrefix:@"UI"]) {
                    message = [message stringByAppendingFormat:@"<%@>%@", argClass, arg];
                } else {
                    message = [message stringByAppendingFormat:@"<%@>%@", argClass, [FWRuntime propertiesOfObject:arg]];
                }
                message = [message stringByAppendingString:[formatArray objectAtIndex:i+1]];
                i++;
            }
        }
        [self _log:FWLogTypeDebug message:message];
        va_end(args);
    }
#endif
}

@end
