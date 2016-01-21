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

+ (id<FWPlugin>)sharedInstance;

@end

//插件分组
@interface FWPluginGroup : NSObject

+ (FWPluginGroup *)groupWithName:(NSString *)name defaultClass:(Class)defaultClass;

@prop_readonly(NSString *, name)

@prop_readonly(Class, defaultClass)

@end

//插件管理池
@interface FWPluginManager : NSObject

@singleton(FWPluginManager)

//设置插件分组的实现类
- (void)setPluginClass:(FWPluginGroup *)group pluginClass:(Class)pluginClass;

//获取插件分组的实现类
- (Class)getPluginClass:(FWPluginGroup *)group;

//获取插件分组的对象
- (id<FWPlugin>)getPlugin:(FWPluginGroup *)group;

@end
