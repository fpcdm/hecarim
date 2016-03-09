//
//  FWPlugin.h
//  Framework
//
//  Created by wuyong on 16/3/9.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef  AS_PLUGIN
#define AS_PLUGIN(prot) \
    + (void)load { [[FWPluginManager sharedInstance] registerPlugin:@protocol(prot) withImpl:[self class]]; }

//插件协议
@protocol FWPlugin <NSObject>

@end

//插件管理池
@interface FWPluginManager : NSObject

@singleton(FWPluginManager)

//注册插件类
- (void)registerPlugin:(Protocol *)protocol withImpl:(Class)implClass;

//获取插件对象，延迟加载
- (id)getPlugin:(Protocol *)protocol;

//加载插件列表，由于采用延迟加载，不需要预加载，主要用于调试
- (void)loadPlugins;

@end
