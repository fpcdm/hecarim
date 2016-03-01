//
//  FWNotification.m
//  Framework
//
//  Created by wuyong on 16/2/23.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWNotification.h"
#import "FWRuntime.h"

#pragma mark -
@implementation NSObject (FWNotificationResponder)

- (void)handleNotification:(NSNotification *)notification
{
    
}

- (void)onNotification:(NSString *)name block:(FWNotificationBlock)block
{
    if (block) {
        [self.blockHandler setBlock:name block:block];
        [self observeNotification:name];
    } else {
        [self.blockHandler removeBlock:name];
        [self unobserveNotification:name];
    }
}

- (void)routeNotification:(NSNotification *)notification
{
    //1. FWNotificationBlock
    if ([self.blockHandler trigger:notification.name withObject:notification]) {
        return;
    }
    
    NSArray *array = [notification.name componentsSeparatedByString:@"."];
    if (array && array.count > 1) {
        //NSString *prefix = (NSString *)[array objectAtIndex:0];
        NSString *clazz = (NSString *)[array objectAtIndex:1];
        NSString *filter = array.count > 2 ? (NSString *)[array objectAtIndex:2] : nil;
        
        NSString *selectorName;
        SEL selector;
        
        if (filter && filter.length > 0) {
            selectorName = [NSString stringWithFormat:@"handleNotification____%@____%@:", clazz, filter];
            selector = NSSelectorFromString(selectorName);
            
            //2. handleNotification_Class_name
            if ([self respondsToSelector:selector]) {
                IGNORED_SELECTOR
                [self performSelector:selector withObject:notification];
                IGNORED_END
                return;
            }
        }
        
        selectorName = [NSString stringWithFormat:@"handleNotification____%@:", clazz];
        selector = NSSelectorFromString(selectorName);
        
        //3. handleNotification_Class
        if ([self respondsToSelector:selector]) {
            IGNORED_SELECTOR
            [self performSelector:selector withObject:notification];
            IGNORED_END
            return;
        }
    }
    
    //4. handleNotification
    [self handleNotification:notification];
}

- (void)observeAllNotifications
{
    NSArray *methods = [FWRuntime methodsOfClass:[self class] withPrefix:@"handleNotification____"];
    if (nil == methods || 0 == methods.count) return;
    
    for (NSString *method in methods) {
        NSString *name = [method stringByReplacingOccurrencesOfString:@"handleNotification____" withString:@"notification."];
        //是否包含分隔符号
        NSRange range = [name rangeOfString:@"____"];
        if (range.location != NSNotFound) {
            //替换为格式：notification.Class.name
            name = [name stringByReplacingCharactersInRange:range withString:@"."];
            name = [name stringByReplacingOccurrencesOfString:@":" withString:@""];
        } else {
            //替换为默认格式：notification.Class.
            name = [name stringByReplacingOccurrencesOfString:@":" withString:@"."];
        }
        if (nil == name) continue;
        
        [self observeNotification:name];
    }
}

- (void)observeNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(routeNotification:)
                                                 name:name
                                               object:nil];
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

#pragma mark -
@implementation NSObject (FWNotificationSender)

//notification.Class.name
@def_static_string(NOTIFICATION, [[self class] NOTIFICATION_TYPE])

//notification.Class.
@def_static_string(NOTIFICATION_TYPE, [[[NSString stringWithUTF8String:"notification."] stringByAppendingString:NSStringFromClass([self class])] stringByAppendingString:[NSString stringWithUTF8String:"."]])

+ (BOOL)postNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    return YES;
}

- (BOOL)postNotification:(NSString *)name
{
    return [[self class] postNotification:name];
}

+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    return YES;
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    return [[self class] postNotification:name withObject:object];
}

@end

#pragma mark -
@implementation NSNotification (FWNotification)

- (BOOL)isName:(NSString *)name
{
    return [self.name isEqualToString:name];
}

- (BOOL)isType:(NSString *)type
{
    return [self.name hasPrefix:type];
}

@end

//UnitTest
#if FRAMEWORK_TEST

@interface FWTestCase_core_FWNotification_Test : NSObject

@notification(CHANGED)

@end

@implementation FWTestCase_core_FWNotification_Test

@def_notification(CHANGED)

@end

TEST_CASE(core, FWNotification)
{
    NSInteger value;
    FWTestCase_core_FWNotification_Test *obj;
}

SETUP()
{
    value = 0;
    obj = [[FWTestCase_core_FWNotification_Test alloc] init];
    
    [self observeAllNotifications];
}

TEST(notification)
{
    EXPECTED(0 == value);
    
    TIMES(10)
    {
        [obj postNotification:obj.CHANGED];
    }
    EXPECTED(10 == value)
    
    TIMES(10)
    {
        [FWTestCase_core_FWNotification_Test postNotification:[FWTestCase_core_FWNotification_Test CHANGED]];
    }
    EXPECTED(20 == value)
}

handleNotification3(FWTestCase_core_FWNotification_Test, CHANGED, notification)
{
    EXPECTED([notification.name isEqualToString:[FWTestCase_core_FWNotification_Test CHANGED]])
    
    value += 1;
}

TEST(onNotification)
{
    [self onNotification:obj.CHANGED block:^(NSNotification *notification) {
        EXPECTED([notification.name isEqualToString:obj.CHANGED])
        value += 2;
    }];
    
    TIMES(5)
    {
        [obj postNotification:obj.CHANGED];
    }
    EXPECTED(10 == value)
}

TEARDOWN()
{
    obj = nil;
    [self unobserveAllNotifications];
}

TEST_CASE_END
#endif
