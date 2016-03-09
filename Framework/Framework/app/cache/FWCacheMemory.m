//
//  FWCacheMemory.m
//  Framework
//
//  Created by 吴勇 on 16/3/9.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWCacheMemory.h"

@implementation FWCacheMemory
{
    NSMutableDictionary *cache;
}

@def_singleton(FWCacheMemory)

- (instancetype)init
{
    self = [super init];
    if (self) {
        cache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)get:(NSString *)key
{
    id object = [cache objectForKey:key];
    return object;
}

- (BOOL)has:(NSString *)key
{
    id object = [cache objectForKey:key];
    return object != nil;
}

- (void)set:(NSString *)key object:(id)object
{
    if (object) {
        [cache setObject:object forKey:key];
    } else {
        [cache removeObjectForKey:key];
    }
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
