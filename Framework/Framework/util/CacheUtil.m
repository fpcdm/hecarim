//
//  CacheUtil.m
//  Framework
//
//  Created by wuyong on 16/1/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "CacheUtil.h"
#import "PINCache.h"

@implementation CacheUtil

@def_singleton(CacheUtil)

- (id)get:(NSString *)key
{
    return [[PINCache sharedCache] objectForKey:key];
}

- (void)set:(NSString *)key object:(id<NSCoding>)object
{
    [[PINCache sharedCache] setObject:object forKey:key];
}

- (void)remove:(NSString *)key
{
    [[PINCache sharedCache] removeObjectForKey:key];
}

- (void)clear
{
    [[PINCache sharedCache] removeAllObjects];
}

@end
