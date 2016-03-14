//
//  FWSignal.m
//  Framework
//
//  Created by 吴勇 on 16/2/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWSignal.h"
#import "FWRuntime.h"

#pragma mark -
@implementation NSObject (FWSignalResponder)

@def_prop_dynamic(FWSignalBlock, onSignal)
@def_prop_dynamic(NSArray *, signalResponders)

- (FWSignalBlock)onSignal
{
    @weakify(self);
    
    FWSignalBlock onBlock = ^ NSObject* (NSString *name, id block)
    {
        @strongify(self);
        
        if (block) {
            [self.blockHandler setBlock:name block:block];
        } else {
            [self.blockHandler removeBlock:name];
        }
        
        return self;
    };
    
    return [onBlock copy];
}

//对外只读
- (NSArray *)signalResponders
{
    NSMutableArray *responders = [self getAssociatedObjectForKey:"signalResponders"];
    if (nil == responders) {
        responders = [[NSMutableArray alloc] init];
        [self retainAssociatedObject:responders forKey:"signalResponders"];
    }
    return responders;
}

- (void)addSignalResponder:(NSObject *)responder
{
    NSMutableArray *responders = (NSMutableArray *)[self signalResponders];
    if (![responders containsObject:responder]) {
        [responders addObject:responder];
    }
}

- (void)removeSignalResponder:(NSObject *)responder
{
    NSMutableArray *responders = (NSMutableArray *)[self signalResponders];
    if ([responders containsObject:responder]) {
        [responders removeObject:responder];
    }
}

- (void)handleSignal:(FWSignal *)signal
{
    
}

@end

#pragma mark -
@implementation NSObject (FWSignalSender)

- (void)sendSignal:(NSString *)name
{
    [self sendSignal:name callback:nil];
}

- (void)sendSignal:(NSString *)name callback:(FWSignalCallback)callback
{
    [self sendSignal:name withObject:nil callback:callback];
}

- (void)sendSignal:(NSString *)name withObject:(id)object
{
    [self sendSignal:name withObject:object callback:nil];
}

- (void)sendSignal:(NSString *)name withObject:(id)object callback:(FWSignalCallback)callback
{
    //发送给所有响应者
    for (NSObject *signalResponder in self.signalResponders) {
        FWSignal *signal = [FWSignal signal];
        signal.name = name;
        signal.object = object;
        signal.source = self;
        signal.target = signalResponder;
        signal.callback = callback;
        
        [signal send];
    }
}

@end

#pragma mark -
@implementation FWSignal
{
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
@def_prop_copy(FWSignalCallback, callback)

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

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [FWRuntime copyObject:self withZone:zone];
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    return [self copyWithZone:zone];
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

- (void)send
{
    [[FWSignalBus sharedInstance] route:self];
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

#pragma mark -
@implementation FWSignalBus

@def_singleton(FWSignalBus)

- (void)route:(FWSignal *)signal
{
    if (!signal || !signal.source || !signal.target) return;
    
    //1. FWSignalBlock
    NSObject *target = signal.target;
    if ([target.blockHandler trigger:signal.name withObject:signal]) {
        return;
    }
    
    NSString *selectorName;
    SEL selector;
    
    if ([signal.name hasPrefix:@"signal."]) {
        NSArray *array   = [signal.name componentsSeparatedByString:@"."];
        NSString *clazz  = (NSString *)[array objectAtIndex:1];
        NSString *filter = array.count > 2 ? (NSString *)[array objectAtIndex:2] : nil;
        
        if (filter && filter.length > 0) {
            selectorName = [NSString stringWithFormat:@"handleSignal____%@____%@:", clazz, filter];
            selector = NSSelectorFromString(selectorName);
            
            //2. handleSignal(class, signal)
            if ([target respondsToSelector:selector]) {
                IGNORED_SELECTOR
                [target performSelector:selector withObject:signal];
                IGNORED_END
                return;
            }
            
            if ([[target.class description] isEqualToString:clazz]) {
                selectorName = [NSString stringWithFormat:@"handleSignal____%@:", filter];
                selector = NSSelectorFromString(selectorName);
                
                //3. handleSignal(signal)
                if ([target respondsToSelector:selector]) {
                    IGNORED_SELECTOR
                    [target performSelector:selector withObject:signal];
                    IGNORED_END
                    return;
                }
            }
        }
        
        selectorName = [NSString stringWithFormat:@"handleSignal____%@:", clazz];
        selector = NSSelectorFromString(selectorName);
        
        //4. handleSignal(class)
        if ([target respondsToSelector:selector]) {
            IGNORED_SELECTOR
            [target performSelector:selector withObject:signal];
            IGNORED_END
            return;
        }
    }
    
    //5. handleSignal(name)
    selectorName = [signal.name stringByReplacingOccurrencesOfString:@"signal." withString:@""];
    selectorName = [NSString stringWithFormat:@"handleSignal____%@:", selectorName];
    selector = NSSelectorFromString(selectorName);
    if ([target respondsToSelector:selector]) {
        IGNORED_SELECTOR
        [target performSelector:selector withObject:signal];
        IGNORED_END
        return;
    }
    
    //6. handleSignal()
    selectorName = @"handleSignal____:";
    selector = NSSelectorFromString(selectorName);
    if ([target respondsToSelector:selector]) {
        IGNORED_SELECTOR
        [target performSelector:selector withObject:signal];
        IGNORED_END
        return;
    }
    
    //7. handleSignal
    [target handleSignal:signal];
}

@end

#pragma mark -
@implementation FWSignalKvo
{
    NSMutableArray *_properties;
}

@def_prop_unsafe(id, source);

- (id)init
{
    self = [super init];
    if (self) {
        _properties = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self unobserveAllProperties];
    
    [_properties removeAllObjects];
    _properties = nil;
}

- (void)observeProperty:(NSString *)name
{
    if (!name || [_properties containsObject:name]) return;
    
    [self.source addObserver:self
                  forKeyPath:name
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:NULL];
    [_properties addObject:name];
}

- (void)observeAllProperties
{
    NSArray *properties = [FWRuntime propertiesOfClass:[self.source class] mutable:YES];
    for (NSString *name in properties) {
        [self observeProperty:name];
    }
}

- (void)unobserveProperty:(NSString *)name
{
    if (![_properties containsObject:name]) return;
    
    [self.source removeObserver:self forKeyPath:name];
    [_properties removeObject:name];
}

- (void)unobserveAllProperties
{
    for (NSString *name in _properties) {
        [self.source removeObserver:self forKeyPath:name];
    }
    [_properties removeAllObjects];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    id oldValue = [change objectForKey:@"old"];
    if (oldValue) {
        [object propertyChanging:keyPath value:oldValue];
    }
    
    id newValue = [change objectForKey:@"new"];
    if (newValue) {
        [object propertyChanged:keyPath value:newValue];
    }
}

@end

#pragma mark -
@implementation NSObject (FWSignalKvoResponder)

@def_prop_dynamic(FWSignalKvoBlock, onPropertyChanging);
@def_prop_dynamic(FWSignalKvoBlock, onPropertyChanged);

- (FWSignalKvo *)kvoObserver
{
    FWSignalKvo *observer = [self getAssociatedObjectForKey:"kvoObserver"];
    if (nil == observer) {
        observer = [[FWSignalKvo alloc] init];
        observer.source = self;
        
        [self retainAssociatedObject:observer forKey:"kvoObserver"];
    }
    return observer;
}

- (FWSignalKvoBlock)onPropertyChanging
{
    @weakify(self);
    
    FWSignalKvoBlock onBlock = ^ NSObject* (id object, id property, ...)
    {
        @strongify(self);
        
        //object,property,block||property,block
        if ([object isKindOfClass:[NSString class]]) {
            NSString *name = [object stringByAppendingString:@"Changing"];
            if (property) {
                [self.blockHandler setBlock:name block:property];
            } else {
                [self.blockHandler removeBlock:name];
            }
        } else {
            va_list args;
            va_start(args, property);
            id block = va_arg(args, id);
            va_end(args);
            
            [object observeProperty:property];
            [object addSignalResponder:self];
            
            NSString *name = [NSString stringWithFormat:@"signal.%@.%@Changing", [[object class] description], property];
            if (block) {
                [self.blockHandler setBlock:name block:block];
            } else {
                [self.blockHandler removeBlock:name];
            }
        }
        
        return self;
    };
    
    return [onBlock copy];
}

- (FWSignalKvoBlock)onPropertyChanged
{
    @weakify(self);
    
    FWSignalKvoBlock onBlock = ^ NSObject* (id object, id property, ...)
    {
        @strongify(self);
        
        //object,property,block||property,block
        if ([object isKindOfClass:[NSString class]]) {
            NSString *name = [object stringByAppendingString:@"Changed"];
            if (property) {
                [self.blockHandler setBlock:name block:property];
            } else {
                [self.blockHandler removeBlock:name];
            }
        } else {
            va_list args;
            va_start(args, property);
            id block = va_arg(args, id);
            va_end(args);
            
            [object observeProperty:property];
            [object addSignalResponder:self];
            
            NSString *name = [NSString stringWithFormat:@"signal.%@.%@Changed", [[object class] description], property];
            if (block) {
                [self.blockHandler setBlock:name block:block];
            } else {
                [self.blockHandler removeBlock:name];
            }
        }
        
        return self;
    };
    
    return [onBlock copy];
}

- (void)observeProperty:(NSString *)name
{
    [self.kvoObserver observeProperty:name];
}

- (void)observeAllProperties
{
    [self.kvoObserver observeAllProperties];
}

- (void)unobserveProperty:(NSString *)name
{
    FWSignalKvo *observer = [self getAssociatedObjectForKey:"kvoObserver"];
    if (observer) {
        [observer unobserveProperty:name];
    }
}

- (void)unobserveAllProperties
{
    FWSignalKvo *observer = [self getAssociatedObjectForKey:"kvoObserver"];
    if (observer) {
        [observer unobserveAllProperties];
        [self removeAssociatedObjectForKey:"kvoObserver"];
    }
}

@end

#pragma mark -
@implementation NSObject (FWSignalKvoSender)

- (void)propertyChanging:(NSString *)name
{
    [self propertyChanging:name value:nil];
}

- (void)propertyChanging:(NSString *)name value:(id)value
{
    NSString *signal = [NSString stringWithFormat:@"signal.%@.%@Changing", [[self class] description], name];
    [self sendSignal:signal withObject:[value isKindOfClass:[NSNull class]] ? nil : value];
}

- (void)propertyChanged:(NSString *)name
{
    [self propertyChanged:name value:nil];
}

- (void)propertyChanged:(NSString *)name value:(id)value
{
    NSString *signal = [NSString stringWithFormat:@"signal.%@.%@Changed", [[self class] description], name];
    [self sendSignal:signal withObject:[value isKindOfClass:[NSNull class]] ? nil : value];
}

@end

#pragma mark -
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
    EXPECTED(0 == obj.signalResponders.count);
    
    TIMES(10)
    {
        [obj sendSignal:obj.CLICK];
    }
    EXPECTED(0 == value)
    
    [obj addSignalResponder:self];
    EXPECTED([obj.signalResponders containsObject:self])
    
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

handleSignal(FWTestCase_core_FWSignal_Test, CLICK)
{
    EXPECTED([signal.name isEqualToString:obj.CLICK]);
    
    value += 1;
    
    [signal success:nil];
}

TEST(onSignal)
{
    [obj addSignalResponder:self];
    
    self.onSignal(obj.CLICK, ^(FWSignal *signal) {
        EXPECTED([signal isName:obj.CLICK])
        EXPECTED([@1 isEqualToNumber:signal.object])
        value += 2;
        
        [signal success:@"result"];
    });
    
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
