//
//  FWSignal.m
//  Framework
//
//  Created by 吴勇 on 16/2/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWSignal.h"

#pragma mark -
@implementation FWSignal

@def_prop_assign(id, source)

@def_prop_assign(id, target)

@def_prop_strong(NSString *, name)

@def_prop_strong(id, object)

+ (FWSignal *)signal
{
    return [[FWSignal alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //init
    }
    return self;
}

- (void)send
{
    //检查参数
    if (!self.name || !self.source || !self.target) return;
    
    NSArray *array = [self.name componentsSeparatedByString:@"."];
    if (array && array.count > 1) {
        //NSString *prefix = (NSString *)[array objectAtIndex:0];
        NSString *clazz = (NSString *)[array objectAtIndex:1];
        NSString *filter = array.count > 2 ? (NSString *)[array objectAtIndex:2] : nil;
        
        NSString *selectorName;
        SEL selector;
        
        if (filter && filter.length > 0) {
            selectorName = [NSString stringWithFormat:@"handleSignal_%@_%@:", clazz, filter];
            selector = NSSelectorFromString(selectorName);
            
            if ([self.target respondsToSelector:selector]) {
                IGNORED_SELECTOR
                [self.target performSelector:selector withObject:self];
                IGNORED_END
                return;
            }
        }
        
        selectorName = [NSString stringWithFormat:@"handleSignal_%@:", clazz];
        selector = NSSelectorFromString(selectorName);
        
        if ([self.target respondsToSelector:selector]) {
            IGNORED_SELECTOR
            [self.target performSelector:selector withObject:self];
            IGNORED_END
            return;
        }
    }
    
    IGNORED_SELECTOR
    [self.target performSelector:@selector(handleSignal:) withObject:self];
    IGNORED_END
}

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
@implementation NSObject (FWSignal)

//signal.Class.name
@def_static_string(SIGNAL, [[self class] SIGNAL_TYPE])

//signal.Class.
@def_static_string(SIGNAL_TYPE, [[[NSString stringWithUTF8String:"signal."] stringByAppendingString:NSStringFromClass([self class])] stringByAppendingString:[NSString stringWithUTF8String:"."]])

- (void)handleSignal:(FWSignal *)signal
{
    
}

@end
