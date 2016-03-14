//
//  FWSignal.h
//  Framework
//
//  Created by 吴勇 on 16/2/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
//@signal
#undef signal
#define signal( __name ) \
    static_property( __name )

#undef def_signal
#define def_signal( __name ) \
    def_static_property3( __name, @"signal", NSStringFromClass([self class]) )

#undef  makeSignal
#define makeSignal( ... ) \
    macro_string(macro_make(signal, __VA_ARGS__))

#undef	handleSignal
#define handleSignal( ... ) \
    - (void) macro_method(handleSignal, __VA_ARGS__):(FWSignal *)signal

typedef NSObject* (^FWSignalBlock)(NSString *name, id block);

@class FWSignal;
typedef void (^FWSignalCallback)(FWSignal *signal);

#pragma mark -
@interface NSObject (FWSignalResponder)

@prop_readonly(FWSignalBlock, onSignal)
@prop_readonly(NSArray *, signalResponders)

- (void)addSignalResponder:(NSObject *)responder;
- (void)removeSignalResponder:(NSObject *)responder;

- (void)handleSignal:(FWSignal *)signal;

@end

#pragma mark -
@interface NSObject (FWSignalSender)

//发送信号
- (void) sendSignal:(NSString *)name;
- (void) sendSignal:(NSString *)name callback:(FWSignalCallback)callback;
- (void) sendSignal:(NSString *)name withObject:(id)object;
- (void) sendSignal:(NSString *)name withObject:(id)object callback:(FWSignalCallback)callback;

@end

#pragma mark -
@interface FWSignal : NSObject<NSCopying, NSMutableCopying>

//静态方法
+ (FWSignal *)signal;
+ (FWSignal *)signal:(NSString *)name;

//信号属性
@prop_strong(NSString *, name)
@prop_strong(id, object)
@prop_assign(NSObject *, source)
@prop_assign(NSObject *, target)
@prop_copy(FWSignalCallback, callback)

//响应属性
@prop_readonly(id, response)
@prop_readonly(NSError *, error)

//判断方法
- (BOOL)isName:(NSString *)name;

//发送信号
- (void)send;

//响应方法
- (void)success:(id)response;
- (void)error:(NSError *)error;
- (BOOL)isError;

@end

#pragma mark -
@interface FWSignalBus : NSObject

@singleton(FWSignalBus)

- (void)route:(FWSignal *)signal;

@end

#pragma mark -
@interface FWSignalKvo : NSObject

@prop_unsafe(id, source)

- (void)observeProperty:(NSString *)name;
- (void)observeAllProperties;
- (void)unobserveProperty:(NSString *)name;
- (void)unobserveAllProperties;

@end

#pragma mark -
//object,property,block||property,block
typedef NSObject* (^FWSignalKvoBlock)(id object, id property, ...);

@interface NSObject (FWSignalKvoResponder)

@prop_readonly(FWSignalKvoBlock, onPropertyChanging);
@prop_readonly(FWSignalKvoBlock, onPropertyChanged);

- (FWSignalKvo *)kvoObserver;

- (void)observeProperty:(NSString *)name;
- (void)observeAllProperties;
- (void)unobserveProperty:(NSString *)name;
- (void)unobserveAllProperties;

@end

#pragma mark -
@interface NSObject (FWSignalKvoSender)

- (void)propertyChanging:(NSString *)name;
- (void)propertyChanging:(NSString *)name value:(id)value;

- (void)propertyChanged:(NSString *)name;
- (void)propertyChanged:(NSString *)name value:(id)value;

@end
