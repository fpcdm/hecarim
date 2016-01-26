//
//  FWPluginCacheDefault.m
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginCacheDefault.h"
#import "PINCache.h"

@implementation FWPluginCacheDefault

- (id)get:(NSString *)key
{
    return [[PINCache sharedCache] objectForKey:key];
}

- (BOOL)has:(NSString *)key
{
    return [self get:key] != nil;
}

- (void)set:(NSString *)key object:(id)object
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
