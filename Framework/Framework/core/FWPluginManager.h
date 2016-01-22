//
//  FWPluginManager.h
//  Framework
//
//  Created by 吴勇 on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//插件通用协议
@protocol FWPlugin <NSObject>

@end

//插件模块协议
@protocol FWPluginModule <NSObject>

@required
//模块默认对象
+ (id<FWPlugin>)defaultPlugin;

@optional
//模块名称，默认协议实现类名
+ (NSString *)moduleName;

@end

//插件管理池
@interface FWPluginManager : NSObject

@singleton(FWPluginManager)

//设置插件模块的对象，设置为空则释放对象
- (void)setPlugin:(Class<FWPluginModule>)module plugin:(id<FWPlugin>)plugin;

//获取插件模块的对象，未设置返回defaultPlugin
- (id<FWPlugin>)getPlugin:(Class<FWPluginModule>)module;

@end
