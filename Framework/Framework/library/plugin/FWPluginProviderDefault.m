//
//  FWPluginProviderDefault.m
//  Framework
//
//  Created by 吴勇 on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginProviderDefault.h"
#import <objc/runtime.h>

@implementation FWPluginProviderDefault
{
    //对象缓存池
    NSMutableDictionary *plugins;
}

@def_singleton(FWPluginProviderDefault)

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
    //读取缓存
    id plugin = [plugins objectForKey:name];
    if (!plugin) {
        //默认插件规则：nameDefault，优先调用sharedInstance，没有才调用alloc、init
        Class pluginClass = NSClassFromString([NSString stringWithFormat:@"%@Default", name]);
        if (pluginClass) {
            //检测sharedInstance方法
            if (class_respondsToSelector(pluginClass, @selector(sharedInstance))) {
                plugin = [pluginClass sharedInstance];
            } else {
                plugin = [[pluginClass alloc] init];
            }
            
            //设置缓存
            [plugins setObject:plugin forKey:name];
        }
    }
    return plugin;
}

- (void)setPlugin:(NSString *)name plugin:(id)plugin
{
    if (plugin) {
        [plugins setObject:plugin forKey:name];
    } else {
        [plugins removeObjectForKey:name];
    }
}

@end
