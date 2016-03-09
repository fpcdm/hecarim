//
//  FWCache.m
//  Framework
//
//  Created by 吴勇 on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWCache.h"
#import "FWCacheFile.h"

@implementation FWCache
{
    id<FWProtocolCache> _backend;
}

@def_singleton(FWCache)

- (void)setBackend:(id<FWProtocolCache>)backend
{
    //仅能设置一次
    if (!_backend) {
        _backend = backend;
    }
}

- (id<FWProtocolCache>)backend
{
    //初始化默认缓存
    if (!_backend) {
        _backend = [FWCacheFile sharedInstance];
    }
    return _backend;
}

- (id)get:(NSString *)key
{
    if (![self has:key]) return nil;
    return [self.backend get:key];
}

- (BOOL)has:(NSString *)key
{
    BOOL result = [self.backend has:key];
    if (result) {
        NSDate *cacheDate = [self.backend get:[self expireKey:key]];
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
    [self.backend set:key object:object];
    
    //小于等于0为永久有效
    if (expire <= 0) {
        [self.backend remove:[self expireKey:key]];
    } else {
        [self.backend set:[self expireKey:key] object:[NSDate dateWithTimeIntervalSinceNow:expire]];
    }
}

- (void)remove:(NSString *)key
{
    [self.backend remove:key];
    
    [self.backend remove:[self expireKey:key]];
}

- (void)clear
{
    [self.backend clear];
}

- (NSString *)expireKey:(NSString *)key
{
    return [key stringByAppendingString:@".__EXPIRE__"];
}

@end
