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

//插件提供者协议
@protocol FWPluginProvider <NSObject>

//提供插件对象
- (id<FWPlugin>)providePlugin:(NSString *)name;

@end

//插件管理池
@interface FWPluginManager : NSObject

@singleton(FWPluginManager)

//设置插件提供者，从而实现动态替换插件
- (void)setPluginProvider:(NSString *)name provider:(id<FWPluginProvider>)provider;

//获取插件对象
- (id<FWPlugin>)getPlugin:(NSString *)name;

@end
