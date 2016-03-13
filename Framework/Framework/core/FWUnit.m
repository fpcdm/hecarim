//
//  FWTest.m
//  Framework
//
//  Created by wuyong on 16/2/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWUnit.h"
#import "FWRuntime.h"

#pragma mark -

@implementation FWTestException

@def_prop_strong(NSString *, expr);
@def_prop_strong(NSString *, file);
@def_prop_assign(NSInteger, line);

+ (FWTestException *)exceptionWithExpr:(const char *)expr file:(const char *)file line:(int)line
{
    FWTestException *exception = [[FWTestException alloc] initWithName:FRAMEWORK_EXCEPTION_NAME reason:@"Assertion failed" userInfo:nil];
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
        @throw [NSException exceptionWithName:FRAMEWORK_EXCEPTION_NAME reason:@"Assertion failed" userInfo:nil];
    }
}

- (void)tearDown
{
    
}

@end

#pragma mark -

@implementation FWUnit
{
    NSMutableArray *_testCases;
}

@def_singleton(FWUnit)

- (id)init
{
    self = [super init];
    if (self) {
        _testCases = [[NSMutableArray alloc] init];

#if FRAMEWORK_TEST
        //自动添加所有测试用例
        NSArray *testClasses = [FWRuntime subclassesOfClass:[FWTestCase class]];
        [_testCases addObjectsFromArray:testClasses];
#endif
    }
    return self;
}

- (void)addTestCase:(Class)testCase
{
#if FRAMEWORK_TEST
    //必须是FWTestCase子类
    if (![testCase isSubclassOfClass:[FWTestCase class]]) return;
    
    //添加测试用例
    NSString *className = NSStringFromClass(testCase);
    if (![_testCases containsObject:className]) {
        [_testCases addObject:className];
    }
#endif
}

- (void)run
{
#if FRAMEWORK_TEST
    //测试日志信息
    NSMutableString *testLog = [[NSMutableString alloc] init];
    
    //获取测试列表
    NSUInteger failedCount = 0;
    NSUInteger succeedCount = 0;
    CFTimeInterval beginTime = CACurrentMediaTime();
    for (NSString *className in _testCases) {
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
            succeedCount += 1;
            
            [testLog appendFormat:@"[  OK  ] : %@ ( %.003fs )\n", formatClass, time];
        } else {
            //测试失败
            failedCount += 1;
            [testLog appendFormat:@"[ FAIL ] : %@ ( %.003fs )\n", formatClass, time];
            [testLog appendFormat:@"    %@\n", formatError];
        }
    }
    
    CFTimeInterval endTime = CACurrentMediaTime();
    CFTimeInterval totalTime = endTime - beginTime;
    
    //统计信息
    NSUInteger totalCount = succeedCount + failedCount;
    float passRate = totalCount > 0 ? (succeedCount * 1.0f) / (totalCount * 1.0f) * 100.0f : 100.0f;
    
    //显示日志
    NSString *log = [NSString stringWithFormat:@"\n\n\
========== UNITTEST  ==========\n%@\
  TOTAL  : [ %@ ] ( %lu/%lu ) ( %.0f%@ ) ( %.003fs )\n\
========== UNITTEST  ==========\n",
                     testLog,
                     failedCount < 1 ? @"OK" : @"FAIL",
                     (unsigned long)succeedCount,
                     (unsigned long)totalCount,
                     passRate,
                     @"%%",
                     totalTime
                     ];
    [FWLog debug:log];
#endif
}

@end
