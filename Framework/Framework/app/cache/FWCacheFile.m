//
//  FWCacheFile.m
//  Framework
//
//  Created by wuyong on 16/3/9.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWCacheFile.h"
#import "PINCache.h"

@implementation FWCacheFile

@def_singleton(FWCacheFile)

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
