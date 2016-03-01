//
//  FWSignal.m
//  Framework
//
//  Created by 吴勇 on 16/2/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWSignal.h"

#pragma mark -
@implementation NSObject (FWSignalResponder)

- (id)signalResponder
{
    id responder = [self getAssociatedObjectForKey:"signalResponder"];
    return responder;
}

- (void)setSignalResponder:(id)responder
{
    if (nil == responder) {
        [self removeAssociatedObjectForKey:"signalResponder"];
    } else {
        [self retainAssociatedObject:responder forKey:"signalResponder"];
    }
}

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

- (void)routeSignal:(FWSignal *)signal
{
    //1. FWSignalBlock
    if ([self.blockHandler trigger:signal.name withObject:signal]) {
        return;
    }
    
    NSArray *array = [signal.name componentsSeparatedByString:@"."];
    if (array && array.count > 1) {
        //NSString *prefix = (NSString *)[array objectAtIndex:0];
        NSString *clazz = (NSString *)[array objectAtIndex:1];
        NSString *filter = array.count > 2 ? (NSString *)[array objectAtIndex:2] : nil;
        
        NSString *selectorName;
        SEL selector;
        
        if (filter && filter.length > 0) {
            selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", clazz, filter];
            selector = NSSelectorFromString(selectorName);
            
            //2. handleSignal_Class_name
            if ([self respondsToSelector:selector]) {
                IGNORED_SELECTOR
                [self performSelector:selector withObject:signal];
                IGNORED_END
                return;
            }
        }
        
        selectorName = [NSString stringWithFormat:@"handleSignal____%@:", clazz];
        selector = NSSelectorFromString(selectorName);
        
        //3. handleSignal_Class
        if ([self respondsToSelector:selector]) {
            IGNORED_SELECTOR
            [self performSelector:selector withObject:signal];
            IGNORED_END
            return;
        }
    }
    
    //4. handleSignal
    [self handleSignal:signal];
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
    signal.target = self.signalResponder ? self.signalResponder : self;
    
    [signal setCallback:callback];
    [signal send];
}

@end

#pragma mark -
@implementation FWSignal
{
    FWSignalBlock _callback;
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
    
    //target调用信号
    [self.target routeSignal:self];
}

- (void)setCallback:(FWSignalBlock)callback
{
    _callback = callback;
}

- (void)success:(id)response
{
    _isError = NO;
    _error = nil;
    _response = response;
    
    if (_callback) {
        _callback(self);
    }
}

- (void)error:(NSError *)error
{
    _isError = YES;
    _error = error;
    _response = nil;
    
    if (_callback) {
        _callback(self);
    }
}

- (BOOL)isError
{
    return _isError;
}

@end

//UnitTest
#if FRAMEWORK_TEST

@interface FWTestCase_core_FWSignal_Test : NSObject

@signal(CLICK)

@end

@implementation FWTestCase_core_FWSignal_Test

@def_signal(CLICK)

@end

TEST_CASE(core, FWSignal)
{
    NSInteger value;
    FWTestCase_core_FWSignal_Test *obj;
    int callbackCount;
}

SETUP()
{
    value = 0;
    obj = [[FWTestCase_core_FWSignal_Test alloc] init];
    callbackCount = 0;
}

TEST(signal)
{
    EXPECTED(0 == value);
    EXPECTED(nil == obj.signalResponder);
    
    TIMES(10)
    {
        [obj sendSignal:obj.CLICK];
    }
    EXPECTED(0 == value)
    
    obj.signalResponder = self;
    EXPECTED(self == obj.signalResponder)
    
    TIMES(10)
    {
        [obj sendSignal:obj.CLICK];
    }
    EXPECTED(10 == value)
    
    EXPECTED(callbackCount == 0)
    TIMES(10)
    {
        [obj sendSignal:obj.CLICK callback:^(FWSignal *signal) {
            EXPECTED(nil == signal.response);
            
            callbackCount += 1;
        }];
    }
    EXPECTED(20 == value)
    EXPECTED(10 == callbackCount)
}

handleSignal3(FWTestCase_core_FWSignal_Test, CLICK, signal)
{
    EXPECTED([signal.name isEqualToString:obj.CLICK]);
    
    value += 1;
    
    [signal success:nil];
}

TEST(onSignal)
{
    obj.signalResponder = self;
    
    [self onSignal:obj.CLICK block:^(FWSignal *signal) {
        EXPECTED([signal isName:obj.CLICK])
        EXPECTED([@1 isEqualToNumber:signal.object])
        value += 2;
        
        [signal success:@"result"];
    }];
    
    TIMES(5)
    {
        [obj sendSignal:obj.CLICK withObject:@1 callback:^(FWSignal *signal) {
            EXPECTED([@"result" isEqualToString:signal.response])
            
            callbackCount += 2;
        }];
    }
    EXPECTED(10 == value)
    EXPECTED(10 == callbackCount)
}

TEARDOWN()
{
    obj = nil;
}

TEST_CASE_END
#endif
