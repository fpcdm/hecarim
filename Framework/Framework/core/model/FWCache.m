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
    return [[self plugin] get:key];
}

- (BOOL)has:(NSString *)key
{
    return [[self plugin] has:key];
}

- (void)set:(NSString *)key object:(id)object
{
    [[self plugin] set:key object:object];
}

- (void)remove:(NSString *)key
{
    [[self plugin] remove:key];
}

- (void)clear
{
    [[self plugin] clear];
}

@end
