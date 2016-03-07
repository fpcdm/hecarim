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
        
        //模拟器开启并自定义颜色
        #if TARGET_IPHONE_SIMULATOR
        setenv("XcodeColors", "YES", 1);
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithHex:@"#20B2AA"] backgroundColor:nil forFlag:DDLogFlagInfo];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithHex:@"#9370D8"] backgroundColor:nil forFlag:DDLogFlagDebug];
        [[DDTTYLogger sharedInstance] setForegroundColor:nil backgroundColor:nil forFlag:DDLogFlagVerbose];
        #endif
        
        //添加ASL终端日志和TTYXcode日志
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
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
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
        
        //检查是否含有%@
        NSMutableString *result = [NSMutableString string];
        NSRange range = [format rangeOfString:@"%@"];
        NSUInteger location = 0, total = format.length;
        NSString *subFormat, *subMessage, *tmpMessage, *appendMessage;
        while (range.location != NSNotFound) {
            va_start(args, format);
            subFormat  = [format substringWithRange:NSMakeRange(0, range.location)];
            subMessage = [[NSString alloc] initWithFormat:subFormat arguments:args];
            
            //计算增加的字符串
            appendMessage = !tmpMessage ? subMessage : [subMessage substringFromIndex:tmpMessage.length];
            [result appendString:appendMessage];
            id object = va_arg(args, id);
            [result appendString:[self _dump:object]];
            va_end(args);
            
            tmpMessage = [NSString stringWithFormat:@"%@%@", subMessage, object];
            location = range.location + 2;
            range = [format rangeOfString:@"%@" options:0 range:NSMakeRange(location, total - location)];
        }
        
        //计算增加的字符串
        appendMessage = !tmpMessage ? message : [message substringFromIndex:tmpMessage.length];
        [result appendString:appendMessage];
        
        [self _log:FWLogTypeDebug message:result];
    }
#endif
}

#ifdef APP_DEBUG
+ (NSString *)_dump:(id)object
{
    NSString *objClass = [[object class] description];
    NSString *objDesc  = [NSString stringWithFormat:@"%@", object];
    
    //<Class>description
    BOOL objFormat = [objDesc hasPrefix:[NSString stringWithFormat:@"<%@:", objClass]] && [objDesc hasSuffix:@">"];
    if (!objFormat) objDesc = [NSString stringWithFormat:@"<%@>", objClass];
    
    //NSClass,_NSInlineClass,__NSClass,UIView,...
    if ([objClass hasPrefix:@"NS"] || [objClass hasPrefix:@"_NS"] || [objClass hasPrefix:@"__NS"] || [objClass hasPrefix:@"UI"]) {
        return [NSString stringWithFormat:@"%@%@", objDesc, objFormat ? @"" : object];
    } else {
        return [NSString stringWithFormat:@"%@%@", objDesc, [FWRuntime propertiesOfObject:object]];
    }
}
#endif

@end
