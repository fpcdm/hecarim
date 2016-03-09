//
//  FWPlugin.m
//  Framework
//
//  Created by wuyong on 16/3/9.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPlugin.h"
#import <objc/runtime.h>

@implementation FWPluginManager
{
    //插件已注册类
    NSMutableDictionary *pluginClasses;
    //插件对象缓存池，延迟加载
    NSMutableDictionary *pluginPool;
}

@def_singleton(FWPluginManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        pluginClasses = [[NSMutableDictionary alloc] init];
        pluginPool = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registerPlugin:(Protocol *)protocol withImpl:(Class)implClass
{
    NSParameterAssert(protocol != nil);
    NSParameterAssert(implClass != nil);
    
    //必须实现插件协议(FWPlugin、protocol)
    NSString *protocolName = NSStringFromProtocol(protocol);
    NSString *className = NSStringFromClass(implClass);
    if (![implClass conformsToProtocol:@protocol(FWPlugin)]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"plugin %@ must confirms to protocol %@", className, @"FWPlugin"]
                                     userInfo:nil];
    }
    if (![implClass conformsToProtocol:protocol]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"plugin %@ must confirms to protocol %@", className, protocolName]
                                     userInfo:nil];
    }
    
    //插件对象已被使用不能修改
    if ([pluginPool objectForKey:protocolName]) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:[NSString stringWithFormat:@"plugin %@ is already in use", protocolName]
                                     userInfo:nil];
    }
    
    [pluginClasses setObject:className forKey:protocolName];
}

- (id)getPlugin:(Protocol *)protocol
{
    NSString *protocolName = NSStringFromProtocol(protocol);
    id plugin = [pluginPool objectForKey:protocolName];
    if (!plugin) {
        //是否已注册实现
        NSString *className = [pluginClasses objectForKey:protocolName];
        if (className) {
            Class implClass = NSClassFromString(className);
            //检查pluginLoaded方法
            if (class_respondsToSelector(implClass, @selector(pluginLoaded))) {
                [implClass pluginLoaded];
            }
            //检查sharedInstance方法
            if (class_respondsToSelector(implClass, @selector(sharedInstance))) {
                plugin = [implClass sharedInstance];
            } else {
                plugin = [[implClass alloc] init];
            }
            //检查pluginInited方法
            if ([plugin respondsToSelector:@selector(pluginInited)]) {
                [plugin pluginInited];
            }
            //设置对象缓存
            [pluginPool setObject:plugin forKey:protocolName];
            
            [FWLog debug:@"plugin %@ inited with class %@", protocolName, className];
        } else {
            [FWLog warn:@"plugin %@ not registered", protocolName];
        }
    }
    return plugin;
}

- (void)loadPlugins
{
#if FRAMEWORK_DEBUG
    NSMutableString *pluginLog = [NSMutableString string];
    for (NSString *pluginName in pluginClasses) {
        NSString *pluginClass = [pluginClasses objectForKey:pluginName];
        [pluginLog appendFormat:@"%@ : %@\n", pluginName, pluginClass];
    }
    
    NSString *log = [NSString stringWithFormat:@"\n\n\
========== PLUGIN ==========\n\
%@\
========== PLUGIN ==========\n",
                     pluginLog
                     ];
    [FWLog debug:log];
#endif
}

@end
