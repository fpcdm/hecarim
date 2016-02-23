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

#undef	handleSignal
#define handleSignal( __signal ) \
- (void)handleSignal:(FWSignal *)__signal

#undef	handleSignal2
#define handleSignal2( __filter, __signal ) \
- (void)handleSignal_##__filter:(FWSignal *)__signal

#undef	handleSignal3
#define handleSignal3( __class, __name, __signal ) \
- (void)handleSignal_##__class##_##__name:(FWSignal *)__signal

#pragma mark -
@interface FWSignal : NSObject

+ (FWSignal *)signal;

@prop_assign(id, source)

@prop_assign(id, target)

@prop_strong(NSString *, name)

@prop_strong(id, object)

- (void)send;

- (BOOL)isName:(NSString *)name;

- (BOOL)isType:(NSString *)type;

@end

#pragma mark -
@interface NSObject (FWSignal)

@static_string(SIGNAL)

@static_string(SIGNAL_TYPE)

- (void)handleSignal:(FWSignal *)signal;

@end
