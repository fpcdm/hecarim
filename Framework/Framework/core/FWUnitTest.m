//
//  FWUnitTest.m
//  Framework
//
//  Created by wuyong on 16/2/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWUnitTest.h"
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

@implementation FWUnitTest
{
    NSUInteger _failedCount;
    NSUInteger _succeedCount;
}

@def_singleton(FWUnitTest)

#if FRAMEWORK_DEBUG

+ (void)load
{
    
#if FRAMEWORK_LOG
    //显示框架配置
    const char *opts[] = {"NO", "YES"};
    
    fprintf(stderr, "\n");
    fprintf(stderr, "========== FRAMEWORK ==========\n");
    fprintf(stderr, " VERSION : %s\n", FRAMEWORK_VERSION);
    fprintf(stderr, "   DEBUG : %s\n", opts[FRAMEWORK_DEBUG]);
    fprintf(stderr, "    TEST : %s\n", opts[FRAMEWORK_TEST]);
    fprintf(stderr, "     LOG : %s\n", opts[FRAMEWORK_LOG]);
    fprintf(stderr, "========== FRAMEWORK ==========\n");
    fprintf(stderr, "\n");
#endif
    
#if FRAMEWORK_TEST
    //自动执行测试
    [[FWUnitTest sharedInstance] run];
#endif
    
}

#endif

- (void)run
{
#if FRAMEWORK_TEST
    //获取测试列表
    NSArray *classes = [FWRuntime subclassesOfClass:[FWTestCase class]];
    
    //单元测试开始
    fprintf(stderr, "\n");
    fprintf(stderr, "========== UNITTEST  ==========\n");
    
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
            fprintf( stderr, "[  OK  ] : %s ( %.003fs )\n", [formatClass UTF8String], time );
        } else {
            //测试失败
            _failedCount += 1;
            fprintf( stderr, "[ FAIL ] : %s ( %.003fs )\n", [formatClass UTF8String], time );
            fprintf( stderr, "    %s\n", [formatError UTF8String] );
        }
    }
    
    CFTimeInterval endTime = CACurrentMediaTime();
    CFTimeInterval totalTime = endTime - beginTime;
    
    //统计信息
    NSUInteger totalCount = _succeedCount + _failedCount;
    float passRate = (_succeedCount * 1.0f) / (totalCount * 1.0f) * 100.0f;
    fprintf( stderr, "  TOTAL  : [ %s ] ( %lu/%lu ) ( %.0f%% ) ( %.003fs )\n", _failedCount < 1 ? "OK" : "FAIL", (long)(_succeedCount), (long)(totalCount), passRate, totalTime);
    
    //单元测试结束
    fprintf(stderr, "========== UNITTEST  ==========\n");
    fprintf(stderr, "\n");
#endif
}

@end

//UnitTest
#if FRAMEWORK_TEST

TEST_CASE(core, FWUnitTestDefine)

TEST(error)
{
    EXPECTED(1)
    EXPECTED(!0)
    
    EXPECTED(0)
}

TEST_CASE_END

TEST_CASE(core, FWUnitTestObject)

TEST(error)
{
    EXPECTED(nil == NULL)
    EXPECTED(nil != [NSNull null])
    
    [self expected:NULL != nil];
}

TEST_CASE_END

#endif
