//
//  FWPluginManager.m
//  Framework
//
//  Created by 吴勇 on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginManager.h"
#import <objc/runtime.h>

@implementation FWPluginManager
{
    //插件缓存池
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

- (void)setPlugin:(NSString *)name plugin:(id)plugin
{
    if (plugin) {
        [pluginPool setObject:plugin forKey:name];
    } else {
        [pluginPool removeObjectForKey:name];
    }
}

- (id)getPlugin:(NSString *)name
{
    id plugin = [pluginPool objectForKey:name];
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
            [pluginPool setObject:plugin forKey:name];
        }
    }
    return plugin;
}

@end
