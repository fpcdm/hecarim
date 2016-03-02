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

@class FWSignal;
typedef void (^FWSignalBlock)(FWSignal *signal);

TODO("support array responders")
TODO("FWSignalCenter route send")
TODO("nsobject signalKvo observeProperty")
TODO("FWSignal NSCopying NSCoding")

#pragma mark -
@interface NSObject (FWSignalResponder)

//设置或获取响应对象
- (id)signalResponder;
- (void)setSignalResponder:(id)responder;

- (void)handleSignal:(FWSignal *)signal;

- (void)onSignal:(NSString *)name block:(FWSignalBlock)block;

@end

#pragma mark -
@interface NSObject (FWSignalSender)

@static_string(SIGNAL)
@static_string(SIGNAL_TYPE)

//发送信号
- (void) sendSignal:(NSString *)name;
- (void) sendSignal:(NSString *)name callback:(FWSignalBlock)callback;
- (void) sendSignal:(NSString *)name withObject:(NSObject *)object;
- (void) sendSignal:(NSString *)name withObject:(NSObject *)object callback:(FWSignalBlock)callback;

@end

#pragma mark -
@interface FWSignal : NSObject

//静态方法
+ (FWSignal *)signal;
+ (FWSignal *)signal:(NSString *)name;

//信号属性
@prop_strong(NSString *, name)
@prop_strong(id, object)
@prop_assign(NSObject *, source)
@prop_assign(NSObject *, target)
@prop_copy(FWSignalBlock, callback)

//响应属性
@prop_readonly(id, response)
@prop_readonly(NSError *, error)

//判断方法
- (BOOL)isName:(NSString *)name;
- (BOOL)isType:(NSString *)type;

//发送信号
- (void)send;

//响应方法
- (void)success:(id)response;
- (void)error:(NSError *)error;
- (BOOL)isError;

@end
