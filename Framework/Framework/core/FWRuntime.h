//
//  FWRuntime.h
//  Framework
//
//  Created by 吴勇 on 16/2/18.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWRuntime : NSObject

@static_integer( UNKNOWN )
@static_integer( OBJECT )
@static_integer( NSNUMBER )
@static_integer( NSSTRING )
@static_integer( NSARRAY )
@static_integer( NSDICTIONARY )
@static_integer( NSDATE )

+ (NSInteger)typeOf:(const char *)attr;
+ (NSInteger)typeOfAttribute:(const char *)attr;
+ (NSInteger)typeOfObject:(id)obj;

+ (NSString *)classNameOf:(const char *)attr;
+ (NSString *)classNameOfAttribute:(const char *)attr;

+ (Class)classOfAttribute:(const char *)attr;

+ (BOOL)isAtomClass:(Class)clazz;

+ (NSArray *)allInstanceMethods:(Class)clazz;
+ (NSArray *)allInstanceMethods:(Class)clazz withPrefix:(NSString *)prefix;

+ (NSArray *)allInstanceProperties:(Class)clazz;
+ (NSDictionary *)getInstanceProperties:(id)obj;

@end
