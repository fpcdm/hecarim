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

#pragma mark -
@implementation NSObject (FWNotification)

//notification.Class.name
@def_static_string(NOTIFICATION, [[self class] NOTIFICATION_TYPE])

//notification.Class.
@def_static_string(NOTIFICATION_TYPE, [[[NSString stringWithUTF8String:"notification."] stringByAppendingString:NSStringFromClass([self class])] stringByAppendingString:[NSString stringWithUTF8String:"."]])

- (void)handleNotification:(NSNotification *)notification
{
    
}

- (void)observeNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
    
    NSArray *array = [name componentsSeparatedByString:@"."];
    if (array && array.count > 1) {
        //NSString *prefix = (NSString *)[array objectAtIndex:0];
        NSString *clazz = (NSString *)[array objectAtIndex:1];
        NSString *filter = array.count > 2 ? (NSString *)[array objectAtIndex:2] : nil;
        
        NSString *selectorName;
        SEL selector;
        
        if (filter && filter.length > 0) {
            selectorName = [NSString stringWithFormat:@"handleNotification_%@_%@:", clazz, filter];
            selector = NSSelectorFromString(selectorName);
            
            if ([self respondsToSelector:selector]) {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:selector
                                                             name:name
                                                           object:nil];
                return;
            }
        }
        
        selectorName = [NSString stringWithFormat:@"handleNotification_%@:", clazz];
        selector = NSSelectorFromString(selectorName);
        
        if ([self respondsToSelector:selector]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:selector
                                                         name:name
                                                       object:nil];
            return;
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:name
                                               object:nil];
}

- (void)observeAllNotifications
{
    NSArray *methods = [FWRuntime methodsOfClass:[self class] withPrefix:@"handleNotification_"];
    if (nil == methods || 0 == methods.count) return;
    
    for (NSString *selectorName in methods) {
        NSString *name = [selectorName stringByReplacingOccurrencesOfString:@"handleNotification_" withString:@"notification."];
        //是否包含下划线
        NSRange range = [name rangeOfString:@"_"];
        if (range.location != NSNotFound) {
            //替换为格式：notification.Class.name
            name = [name stringByReplacingOccurrencesOfString:@":" withString:@""];
            name = [name stringByReplacingCharactersInRange:range withString:@"."];
        } else {
            //替换为默认格式：notification.Class.
            name = [name stringByReplacingOccurrencesOfString:@":" withString:@"."];
        }
        if (nil == name) continue;
        
        [self observeNotification:name];
    }
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

- (BOOL)postNotification:(NSString *)name
{
    return [[self class] postNotification:name];
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    return [[self class] postNotification:name withObject:object];
}

+ (BOOL)postNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    return YES;
}

+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    return YES;
}

@end
