//
//  FWPluginManager.m
//  Framework
//
//  Created by 吴勇 on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginManager.h"

@implementation FWPluginManager
{
    NSMutableDictionary *pluginPool;
}

@def_singleton(FWPluginManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        pluginPool = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setPlugin:(Class<FWPluginModule>)module plugin:(id<FWPlugin>)plugin
{
    NSString *moduleName = [module moduleName];
    if (plugin) {
        [pluginPool setObject:plugin forKey:moduleName];
    } else {
        [pluginPool removeObjectForKey:moduleName];
    }
}

- (id<FWPlugin>)getPlugin:(Class<FWPluginModule>)module
{
    NSString *moduleName = [module moduleName];
    id<FWPlugin> plugin = [pluginPool objectForKey:moduleName];
    if (!plugin) {
        plugin = [module defaultPlugin];
        [pluginPool setObject:plugin forKey:moduleName];
    }
    return plugin;
}

@end
