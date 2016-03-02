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

@def_prop_dynamic(FWNotificationBlock, onNotification)

- (FWNotificationBlock)onNotification
{
    @weakify(self);
    
    FWNotificationBlock onBlock = ^ NSObject* (NSString *name, id block)
    {
        @strongify(self);
        
        if (block) {
            [self.blockHandler setBlock:name block:block];
            [self observeNotification:name];
        } else {
            [self.blockHandler removeBlock:name];
            [self unobserveNotification:name];
        }
        
        return self;
    };
    
    return [onBlock copy];
}

- (void)handleNotification:(NSNotification *)notification
{
    
}

- (void)routeNotification:(NSNotification *)notification
{
    //1. FWNotificationBlock
    if ([self.blockHandler trigger:notification.name withObject:notification]) {
        return;
    }
    
    NSString *selectorName;
    SEL selector;
    
    NSArray *array = [notification.name componentsSeparatedByString:@"."];
    if (array && array.count > 1) {
        //NSString *prefix = (NSString *)[array objectAtIndex:0];
        NSString *clazz = (NSString *)[array objectAtIndex:1];
        NSString *filter = array.count > 2 ? (NSString *)[array objectAtIndex:2] : nil;
        
        if (filter && filter.length > 0) {
            selectorName = [NSString stringWithFormat:@"handleNotification____%@____%@:", clazz, filter];
            selector = NSSelectorFromString(selectorName);
            
            //2. handleNotification(class, notification)
            if ([self respondsToSelector:selector]) {
                IGNORED_SELECTOR
                [self performSelector:selector withObject:notification];
                IGNORED_END
                return;
            }
            
            if ([[self.class description] isEqualToString:clazz]) {
                selectorName = [NSString stringWithFormat:@"handleNotification____%@:", filter];
                selector = NSSelectorFromString(selectorName);
                
                //3. handleNotification(notification)
                if ([self respondsToSelector:selector]) {
                    IGNORED_SELECTOR
                    [self performSelector:selector withObject:notification];
                    IGNORED_END
                    return;
                }
            }
        }
        
        selectorName = [NSString stringWithFormat:@"handleNotification____%@:", clazz];
        selector = NSSelectorFromString(selectorName);
        
        //4. handleNotification(class)
        if ([self respondsToSelector:selector]) {
            IGNORED_SELECTOR
            [self performSelector:selector withObject:notification];
            IGNORED_END
            return;
        }
    }
    
    //5. handleNotification(name)
    if ([notification.name hasPrefix:@"notification."]) {
        selectorName = [notification.name stringByReplacingOccurrencesOfString:@"notification." withString:@"handleNotification____"];
    } else {
        selectorName = [NSString stringWithFormat:@"handleNotification____%@:", notification.name];
    }
    selectorName = [selectorName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    selectorName = [selectorName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    selectorName = [selectorName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    if (![selectorName hasSuffix:@":"]) {
        selectorName = [selectorName stringByAppendingString:@":"];
    }
    
    selector = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:selector]) {
        IGNORED_SELECTOR
        [self performSelector:selector withObject:notification];
        IGNORED_END
        return;
    }

    //6. handleNotification()
    selectorName = @"handleNotification____:";
    selector = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:selector]) {
        IGNORED_SELECTOR
        [self performSelector:selector withObject:notification];
        IGNORED_END
        return;
    }
    
    //7. handleNotification
    [self handleNotification:notification];
}

- (void)observeAllNotifications
{
    NSArray *methods = [FWRuntime methodsOfClass:[self class] withPrefix:@"handleNotification____"];
    if (nil == methods || 0 == methods.count) return;
    
    for (NSString *method in methods) {
        NSString *name = [method stringByReplacingOccurrencesOfString:@"handleNotification" withString:@"notification"];
        name = [name stringByReplacingOccurrencesOfString:@"____" withString:@"."];
        if ([name hasSuffix:@":"]) {
            name = [name substringToIndex:(name.length - 1)];
        }
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

handleNotification(FWTestCase_core_FWNotification_Test, CHANGED)
{
    EXPECTED([notification.name isEqualToString:[FWTestCase_core_FWNotification_Test CHANGED]])
    
    value += 1;
}

TEST(onNotification)
{
    self.onNotification(obj.CHANGED, ^(NSNotification *notification){
        EXPECTED([notification.name isEqualToString:obj.CHANGED])
        value += 2;
    });
    
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
