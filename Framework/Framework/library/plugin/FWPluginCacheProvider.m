//
//  FWPluginCacheProvider.m
//  Framework
//
//  Created by 吴勇 on 16/1/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginCacheProvider.h"
#import "FWPluginCacheDefault.h"
#import "FWPluginManager.h"

@implementation FWPluginCacheProvider

+ (void)load
{
    if (![[FWPluginManager sharedInstance] hasPluginProvider:FWProtocolPluginCacheName]) {
        FWPluginCacheProvider *provider = [[FWPluginCacheProvider alloc] init];
        [[FWPluginManager sharedInstance] setPluginProvider:FWProtocolPluginCacheName provider:provider];
    }
}

- (id<FWProtocolPlugin>)providePlugin:(NSString *)name
{
    FWPluginCacheDefault *plugin = [FWPluginCacheDefault sharedInstance];
    return plugin;
}

@end
