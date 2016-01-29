//
//  FWPluginManager.m
//  Framework
//
//  Created by 吴勇 on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginManager.h"
#import "FWPluginProviderDefault.h"

@implementation FWPluginManager
{
    NSMutableDictionary *providerPool;
}

@def_singleton(FWPluginManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        providerPool = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setProvider:(NSString *)name provider:(id<FWPluginProvider>)provider
{
    if (provider) {
        [providerPool setObject:provider forKey:name];
    } else {
        [providerPool removeObjectForKey:name];
    }
}

- (id)getPlugin:(NSString *)name
{
    id<FWPluginProvider> provider = [providerPool objectForKey:name];
    if (!provider) {
        //默认提供者
        provider = [FWPluginProviderDefault sharedInstance];
    }
    return [provider providePlugin:name];
}

@end
