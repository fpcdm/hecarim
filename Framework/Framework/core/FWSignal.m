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
{
    FWSignalBlock _block;
    BOOL _isError;
    id _response;
    NSError *_error;
}

+ (FWSignal *)signal
{
    return [[FWSignal alloc] init];
}

+ (FWSignal *)signal:(NSString *)name
{
    FWSignal *signal = [[FWSignal alloc] init];
    signal.name = name;
    return signal;
}

@def_prop_strong(NSString *, name)
@def_prop_strong(id, object)
@def_prop_assign(NSObject *, source)
@def_prop_assign(NSObject *, target)

@def_prop_dynamic(id, response)
@def_prop_dynamic(NSError *, error)

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (id)response
{
    return _response;
}

- (NSError *)error
{
    return _error;
}

- (BOOL)isName:(NSString *)name
{
    return [self.name isEqualToString:name];
}

- (BOOL)isType:(NSString *)type
{
    return [self.name hasPrefix:type];
}

- (void)send
{
    //检查参数
    if (!self.name || !self.source || !self.target) return;
    
    //1. FWSignalBlock
    if ([self.target.blockHandler trigger:self.name withObject:self]) {
        return;
    }
    
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
            
            //2. handleSignal_Class_name
            if ([self.target respondsToSelector:selector]) {
                IGNORED_SELECTOR
                [self.target performSelector:selector withObject:self];
                IGNORED_END
                return;
            }
        }
        
        selectorName = [NSString stringWithFormat:@"handleSignal_%@:", clazz];
        selector = NSSelectorFromString(selectorName);
        
        //3. handleSignal_Class
        if ([self.target respondsToSelector:selector]) {
            IGNORED_SELECTOR
            [self.target performSelector:selector withObject:self];
            IGNORED_END
            return;
        }
    }
    
    //4. handleSignal
    [self.target handleSignal:self];
}

- (void)setBlock:(FWSignalBlock)block
{
    _block = block;
}

- (void)success:(id)response
{
    _isError = NO;
    _error = nil;
    _response = response;
    
    if (_block) {
        _block(self);
    }
}

- (void)error:(NSError *)error
{
    _isError = YES;
    _error = error;
    _response = nil;
    
    if (_block) {
        _block(self);
    }
}

- (BOOL)isError
{
    return _isError;
}

@end

#pragma mark -
@implementation NSObject (FWSignalResponder)

- (void)handleSignal:(FWSignal *)signal
{
    
}

- (void)onSignal:(NSString *)name block:(FWSignalBlock)block
{
    if (block) {
        [self.blockHandler setBlock:name block:block];
    } else {
        [self.blockHandler removeBlock:name];
    }
}

@end

#pragma mark -
@implementation NSObject (FWSignalSender)

//signal.Class.name
@def_static_string(SIGNAL, [[self class] SIGNAL_TYPE])

//signal.Class.
@def_static_string(SIGNAL_TYPE, [[[NSString stringWithUTF8String:"signal."] stringByAppendingString:NSStringFromClass([self class])] stringByAppendingString:[NSString stringWithUTF8String:"."]])

- (void)sendSignal:(NSString *)name
{
    [self sendSignal:name callback:nil];
}

- (void)sendSignal:(NSString *)name callback:(FWSignalBlock)callback
{
    [self sendSignal:name withObject:nil callback:callback];
}

- (void)sendSignal:(NSString *)name withObject:(NSObject *)object
{
    [self sendSignal:name withObject:object callback:nil];
}

- (void)sendSignal:(NSString *)name withObject:(NSObject *)object callback:(FWSignalBlock)callback
{
    FWSignal *signal = [FWSignal signal];
    signal.name = name;
    signal.object = object;
    signal.source = self;
    signal.target = self;
    
    [signal setBlock:callback];
    
    [signal send];
}

@end
