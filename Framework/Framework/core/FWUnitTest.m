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
    NSUInteger _failedCase;
    NSUInteger _succeedCase;
    NSUInteger _failedTest;
    NSUInteger _succeedTest;
}

@def_singleton(FWUnitTest)

//调试模式生效
#if FRAMEWORK_DEBUG

+ (void)load
{
    
#if FRAMEWORK_LOG
    //显示框架配置
    const char *opts[] = {"NO", "YES"};
    
    fprintf(stderr, "\n");
    fprintf(stderr,  "========== Framework ==========\n");
    fprintf(stderr,  "      Version   : %s\n", FRAMEWORK_VERSION);
    fprintf(stderr,  "      Debug     : %s\n", opts[FRAMEWORK_DEBUG]);
    fprintf(stderr,  "      Log       : %s\n", opts[FRAMEWORK_LOG]);
    fprintf(stderr,  "      Test      : %s\n", opts[FRAMEWORK_TEST]);
    fprintf(stderr,  "========== Framework ==========\n");
    fprintf(stderr,  "\n");
#endif
    
#if FRAMEWORK_TEST
    //自动执行测试
    fprintf(stderr, "\n");
    fprintf(stderr,  "========== UnitTest ==========\n");
    
    [[FWUnitTest sharedInstance] run];
    
    fprintf(stderr,  "========== UnitTest ==========\n");
    fprintf(stderr,  "\n");
#endif
    
}

#endif

- (void)run
{
    NSArray *classes = [FWRuntime subclassesOfClass:[FWTestCase class]];
    
    //开始单元测试
    fprintf(stderr,  "\n");
    fprintf(stderr,  "===== UnitTest : Start =====\n");
    
    CFTimeInterval beginTime = CACurrentMediaTime();
    for (NSString *className in classes) {
        Class classType = NSClassFromString(className);
        if (nil == classType) continue;
        
        NSString *formatClass = [className stringByReplacingOccurrencesOfString:@"FWTestCase____" withString:@""];
        formatClass = [formatClass stringByReplacingOccurrencesOfString:@"____" withString:@"."];
        
        CFTimeInterval time1 = CACurrentMediaTime();
        BOOL testCasePassed = YES;
        
        NSString *methodName = nil;
        NSString *errorMsg = nil;
        @try {
            NSArray *selectorNames = [FWRuntime methodsOfClass:classType withPrefix:@"test"];
            if (selectorNames && selectorNames.count > 0) {
                FWTestCase *testCase = [[classType alloc] init];
                for (NSString * selectorName in selectorNames) {
                    methodName = selectorName;
                    SEL selector = NSSelectorFromString(selectorName);
                    if (selector && [testCase respondsToSelector:selector]) {
                        [testCase setUp];
                        
                        //调用测试方法
                        NSMethodSignature *signature = [testCase methodSignatureForSelector:selector];
                        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                        [invocation setTarget:testCase];
                        [invocation setSelector:selector];
                        [invocation invoke];
                        
                        [testCase tearDown];
                        
                        //成功次数加1
                        _succeedTest += 1;
                    }
                }
            }
        } @catch (FWTestException *e) {
            errorMsg = [NSString stringWithFormat:@"      %@ (#%lu) : EXPECTED( %@ ); [Assertion failed]", e.file, (long)e.line, e.expr];
            
            testCasePassed = NO;
            
            //失败次数加1
            _failedTest += 1;
        } @catch (NSException *e) {
            errorMsg = [NSString stringWithFormat:@"      %@ : %@( ); [%@]", formatClass, methodName, e.reason];
            
            testCasePassed = NO;
            
            //失败次数加1
            _failedTest += 1;
        } @finally {
        }
        
        CFTimeInterval time2 = CACurrentMediaTime();
        CFTimeInterval time = time2 - time1;
        
        if ( testCasePassed ) {
            _succeedCase += 1;
            fprintf( stderr, "      %s : [ OK ]   %.003fs\n", [formatClass UTF8String], time );
        } else {
            _failedCase += 1;
            fprintf( stderr, "      %s : [FAIL]   %.003fs\n", [formatClass UTF8String], time );
            fprintf( stderr, "          %s\n", [errorMsg UTF8String] );
        }
    }
    
    CFTimeInterval endTime = CACurrentMediaTime();
    CFTimeInterval totalTime = endTime - beginTime;
    
    float passRate = (_succeedCase * 1.0f) / ((_succeedCase + _failedCase) * 1.0f) * 100.0f;
    
    fprintf( stderr, "      Result : %lu cases  [%.0f%%]   %.003fs\n", (unsigned long)[classes count], passRate, totalTime);
    
    //单元测试结束
    fprintf(stderr,  "===== UnitTest : End =====\n");
    fprintf(stderr, "\n");
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
