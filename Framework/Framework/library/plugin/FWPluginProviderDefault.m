//
//  FWPluginProviderDefault.m
//  Framework
//
//  Created by 吴勇 on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginProviderDefault.h"
#import "FWPluginDialogDefault.h"

@implementation FWPluginProviderDefault
{
    //对象缓存池
    NSMutableDictionary *plugins;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        plugins = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)providePlugin:(NSString *)name
{
    id plugin = nil;
    //默认弹出框
    if ([FWPluginDialogName isEqualToString:name]) {
        plugin = [plugins objectForKey:name];
        if (!plugin) {
            plugin = [[FWPluginDialogDefault alloc] init];
            [plugins setObject:plugin forKey:name];
        }
    }
    return plugin;
}

@end
