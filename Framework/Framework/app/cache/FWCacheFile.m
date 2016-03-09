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
{
    PINCache *cache;
}

@def_singleton(FWCacheFile)

- (id) init
{
    self = [super init];
    if (self) {
        cache = [PINCache sharedCache];
    }
    return self;
}

- (id)get:(NSString *)key
{
    return [cache objectForKey:key];
}

- (BOOL)has:(NSString *)key
{
    return [self get:key] != nil;
}

- (void)set:(NSString *)key object:(id)object
{
    [cache setObject:object forKey:key];
}

- (void)remove:(NSString *)key
{
    [cache removeObjectForKey:key];
}

- (void)clear
{
    [cache removeAllObjects];
}

@end
