//
//  FWTest.m
//  Framework
//
//  Created by wuyong on 16/2/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWTest.h"
#import "FWRuntime.h"

#pragma mark -

@implementation FWTestException

@def_prop_strong(NSString *, expr);
@def_prop_strong(NSString *, file);
@def_prop_assign(NSInteger, line);

+ (FWTestException *)exceptionWithExpr:(const char *)expr file:(const char *)file line:(int)line
{
    FWTestException *exception = [[FWTestException alloc] initWithName:@"FWUnitTest" reason:@"Assertion failed" userInfo:nil];
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

@implementation FWTest
{
    NSUInteger _failedCount;
    NSUInteger _succeedCount;
}

@def_singleton(FWTest)

- (void)run
{
#if FRAMEWORK_TEST
    //测试日志信息
    NSMutableString *testLog = [[NSMutableString alloc] init];
    
    //获取测试列表
    NSArray *classes = [FWRuntime subclassesOfClass:[FWTestCase class]];
    CFTimeInterval beginTime = CACurrentMediaTime();
    for (NSString *className in classes) {
        Class classType = NSClassFromString(className);
        if (nil == classType) continue;
        
        CFTimeInterval time1 = CACurrentMediaTime();
        BOOL testCasePassed = YES;
        
        NSString *formatClass = [className stringByReplacingOccurrencesOfString:@"FWTestCase____" withString:@""];
        formatClass = [formatClass stringByReplacingOccurrencesOfString:@"____" withString:@"."];
        NSString *formatMethod = nil;
        NSString *formatError = nil;
        
        @try {
            NSArray *selectorNames = [FWRuntime methodsOfClass:classType withPrefix:@"test"];
            if (selectorNames && selectorNames.count > 0) {
                FWTestCase *testCase = [[classType alloc] init];
                for (NSString * selectorName in selectorNames) {
                    formatMethod = [selectorName stringByReplacingOccurrencesOfString:@"test" withString:@""];
                    SEL selector = NSSelectorFromString(selectorName);
                    if (selector && [testCase respondsToSelector:selector]) {
                        //setUp
                        [testCase setUp];
                        
                        //test
                        NSMethodSignature *signature = [testCase methodSignatureForSelector:selector];
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                        [invocation setTarget:testCase];
                        [invocation setSelector:selector];
                        [invocation invoke];
                        
                        //tearDown
                        [testCase tearDown];
                    }
                }
            }
        } @catch (FWTestException *e) {
            formatError = [NSString stringWithFormat:@"- EXPECTED( %@ ); ( %@ - %@ #%lu )", e.expr, formatMethod, e.file, (long)e.line];
            
            testCasePassed = NO;
        } @catch (NSException *e) {
            formatError = [NSString stringWithFormat:@"- %@ ( %@ )", e.reason, formatMethod];
            
            testCasePassed = NO;
        } @finally {
        }
        
        CFTimeInterval time2 = CACurrentMediaTime();
        CFTimeInterval time = time2 - time1;
        
        if ( testCasePassed ) {
            //测试通过
            _succeedCount += 1;
            
            [testLog appendFormat:@"[  OK  ] : %@ ( %.003fs )\n", formatClass, time];
        } else {
            //测试失败
            _failedCount += 1;
            [testLog appendFormat:@"[ FAIL ] : %@ ( %.003fs )\n", formatClass, time];
            [testLog appendFormat:@"    %@\n", formatError];
        }
    }
    
    CFTimeInterval endTime = CACurrentMediaTime();
    CFTimeInterval totalTime = endTime - beginTime;
    
    //统计信息
    NSUInteger totalCount = _succeedCount + _failedCount;
    float passRate = totalCount > 0 ? (_succeedCount * 1.0f) / (totalCount * 1.0f) * 100.0f : 100.0f;
    
    //显示日志
    NSString *log = [NSString stringWithFormat:@"\n\n\
========== UNITTEST  ==========\n%@\
  TOTAL  : [ %@ ] ( %lu/%lu ) ( %.0f%@ ) ( %.003fs )\n\
========== UNITTEST  ==========\n",
                     testLog,
                     _failedCount < 1 ? @"OK" : @"FAIL",
                     (unsigned long)_succeedCount,
                     (unsigned long)totalCount,
                     passRate,
                     @"%%",
                     totalTime
                     ];
    [FWLog debug:log];
#endif
}

@end
