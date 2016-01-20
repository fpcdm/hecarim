//
//  CacheUtil.h
//  Framework
//
//  Created by wuyong on 16/1/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheUtil : NSObject

@singleton(CacheUtil)

- (id) get:(NSString *)key;

- (BOOL) has:(NSString *)key;

- (void) set:(NSString *)key object:(id<NSCoding>)object;

- (void) remove:(NSString *)key;

- (void) clear;

@end
