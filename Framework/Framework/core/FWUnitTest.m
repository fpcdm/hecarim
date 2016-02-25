//
//  FWUnitTest.m
//  Framework
//
//  Created by wuyong on 16/2/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWUnitTest.h"
#import "FWRuntime.h"

//最大日志数量
#define FWUnitTest_MAX_LOGS 100

#pragma mark -

@implementation FWTestException

@def_prop_strong(NSString *, expr);
@def_prop_strong(NSString *, file);
@def_prop_assign(NSInteger, line);

+ (FWTestException *)exceptionWithExpr:(const char *)expr file:(const char *)file line:(int)line
{
    FWTestException *exception = [[FWTestException alloc] initWithName:@"FWUnitTest" reason:nil userInfo:nil];
    exception.expr = @(expr);
    exception.file = [@(file) lastPathComponent];
    exception.line = line;
    return exception;
}

@end

#pragma mark -

@implementation FWTestCase

- (void)setUp
{
    
}

- (void)expected:(BOOL)value
{
    if (!value) {
        @throw [NSException exceptionWithName:@"FWUnitTest" reason:@"Assertion failed" userInfo:nil];
    }
}

- (void)tearDown
{
    
}

@end

#pragma mark -

@implementation FWUnitTest
{
    NSMutableArray *_logs;
    
    NSUInteger _failedCount;
    NSUInteger _succeedCount;
}

@def_singleton(FWUnitTest)

+ (void)load
{
#if FRAMEWORK_TEST
    //显示框架配置信息
    const char *opts[] = {"OFF", "ON"};
    fprintf(stderr,  "===== Framework : [version:%s] [debug:%s] [log:%s] [test:%s] =====\n", FRAMEWORK_VERSION, opts[FRAMEWORK_DEBUG], opts[FRAMEWORK_LOG], opts[FRAMEWORK_TEST]);
    
    //测试环境自动执行
    [[FWUnitTest sharedInstance] run];
#endif
}

- (id)init
{
    self = [super init];
    if (self) {
        _logs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    _logs = nil;
}

- (void)run
{
    
    //框架信息
    
    fprintf( stderr, "=============================================================\n" );
    fprintf( stderr, "Unit testing ...\n" );
    fprintf( stderr, "-------------------------------------------------------------\n" );
    
    NSArray *classes = [FWRuntime subclassesOfClass:[FWTestCase class]];
    
    CFTimeInterval beginTime = CACurrentMediaTime();
    
    for ( NSString * className in classes )
    {
        Class classType = NSClassFromString( className );
        
        if ( nil == classType )
            continue;
        
        NSString * testCaseName;
        testCaseName = [classType description];
        testCaseName = [testCaseName stringByReplacingOccurrencesOfString:@"FWTestCase_" withString:@"  TEST_CASE( "];
        testCaseName = [testCaseName stringByAppendingString:@" )"];
        
        NSString * formattedName = [testCaseName stringByPaddingToLength:48 withString:@" " startingAtIndex:0];
        
        fprintf( stderr, "%s", [formattedName UTF8String] );
        
        CFTimeInterval time1 = CACurrentMediaTime();
        
        BOOL testCasePassed = YES;
        
        //	@autoreleasepool
        {
            @try
            {
                FWTestCase * testCase = [[classType alloc] init];
                
                NSArray *selectorNames = [FWRuntime methodsOfClass:classType withPrefix:@"test"];
                
                if ( selectorNames && [selectorNames count] )
                {
                    for ( NSString * selectorName in selectorNames )
                    {
                        SEL selector = NSSelectorFromString( selectorName );
                        if ( selector && [testCase respondsToSelector:selector] )
                        {
                            [testCase setUp];
                            
                            NSMethodSignature * signature = [testCase methodSignatureForSelector:selector];
                            NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
                            
                            [invocation setTarget:testCase];
                            [invocation setSelector:selector];
                            [invocation invoke];
                            
                            [testCase tearDown];
                        }
                    }
                }
            }
            @catch ( NSException * e )
            {
                if ( [e isKindOfClass:[FWTestException class]] )
                {
                    FWTestException * exception = (FWTestException *)e;
                    
                    [self writeLog:
                     @"                        \n"
                     "    %@ (#%lu)           \n"
                     "                        \n"
                     "    {                   \n"
                     "        EXPECTED( %@ ); \n"
                     "                  ^^^^^^          \n"
                     "                  Assertion failed\n"
                     "    }                   \n"
                     "                        \n", exception.file, exception.line, exception.expr];
                }
                else
                {
                    [self writeLog:@"\nUnknown exception '%@'", e.reason];
                    [self writeLog:@"%@", e.callStackSymbols];
                }
                
                testCasePassed = NO;
            }
            @finally
            {
            }
        };
        
        CFTimeInterval time2 = CACurrentMediaTime();
        CFTimeInterval time = time2 - time1;
        
        //		[[SamuraiLogger sharedInstance] enable];
        
        if ( testCasePassed )
        {
            _succeedCount += 1;
            
            fprintf( stderr, "[ OK ]   %.003fs\n", time );
        }
        else
        {
            _failedCount += 1;
            
            fprintf( stderr, "[FAIL]   %.003fs\n", time );
        }
        
        [self flushLog];
    }
    
    CFTimeInterval endTime = CACurrentMediaTime();
    CFTimeInterval totalTime = endTime - beginTime;
    
    float passRate = (_succeedCount * 1.0f) / ((_succeedCount + _failedCount) * 1.0f) * 100.0f;
    
    fprintf( stderr, "  -------------------------------------------------------------\n" );
    fprintf( stderr, "  Total %lu cases                               [%.0f%%]   %.003fs\n", (unsigned long)[classes count], passRate, totalTime );
    fprintf( stderr, "  =============================================================\n" );
    fprintf( stderr, "\n" );
}

- (void)writeLog:(NSString *)format, ...
{
    if ( _logs.count >= FWUnitTest_MAX_LOGS )
    {
        return;
    }
    
    if ( nil == format || NO == [format isKindOfClass:[NSString class]] )
        return;
    
    va_list args;
    va_start( args, format );
    
    @autoreleasepool
    {
        NSMutableString * content = [[NSMutableString alloc] initWithFormat:(NSString *)format arguments:args];
        [_logs addObject:content];
    };
    
    va_end( args );
}

- (void)flushLog
{
    if ( _logs.count )
    {
        for ( NSString * log in _logs )
        {
            fprintf( stderr, "       %s\n", [log UTF8String] );
        }
        
        if ( _logs.count >= FWUnitTest_MAX_LOGS )
        {
            fprintf( stderr, "       ...\n" );
        }
        
        fprintf( stderr, "\n" );
    }
    
    [_logs removeAllObjects];
}

@end
