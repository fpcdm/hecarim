//
//  FWCache.m
//  Framework
//
//  Created by 吴勇 on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWCache.h"
#import "FWPluginManager.h"
#import "FWPluginCache.h"

@implementation FWCache

@def_singleton(FWCache)

- (id<FWPluginCache>)plugin
{
    return [[FWPluginManager sharedInstance] getPlugin:FWPluginCacheName];
}

- (id)get:(NSString *)key
{
    if (![self has:key]) return nil;
    return [[self plugin] get:key];
}

- (BOOL)has:(NSString *)key
{
    BOOL result = [[self plugin] has:key];
    if (result) {
        NSDate *cacheDate = [[self plugin] get:[self expireKey:key]];
        if (cacheDate) {
            //检查是否过期，大于0为过期
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:cacheDate];
            if (interval > 0) {
                [self remove:key];
                result = NO;
            }
        }
    }
    return result;
}

- (void)set:(NSString *)key object:(id)object
{
    [self set:key object:object expire:0];
}

- (void)set:(NSString *)key object:(id)object expire:(NSTimeInterval)expire
{
    [[self plugin] set:key object:object];
    
    //小于等于0为永久有效
    if (expire <= 0) {
        [[self plugin] remove:[self expireKey:key]];
    } else {
        [[self plugin] set:[self expireKey:key] object:[NSDate dateWithTimeIntervalSinceNow:expire]];
    }
}

- (void)remove:(NSString *)key
{
    [[self plugin] remove:key];
    
    [[self plugin] remove:[self expireKey:key]];
}

- (void)clear
{
    [[self plugin] clear];
}

- (NSString *)expireKey:(NSString *)key
{
    return [key stringByAppendingString:@".__EXPIRE__"];
}

@end
