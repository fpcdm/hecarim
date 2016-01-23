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

- (void)setPluginProvider:(NSString *)name provider:(id<FWPluginProvider>)provider
{
    if (provider) {
        [providerPool setObject:provider forKey:name];
    } else {
        [providerPool removeObjectForKey:name];
    }
}

- (id<FWPlugin>)getPlugin:(NSString *)name
{
    id<FWPluginProvider> provider = [providerPool objectForKey:name];
    if (!provider) {
        return nil;
    }
    
    return [provider providePlugin:name];
}

@end
