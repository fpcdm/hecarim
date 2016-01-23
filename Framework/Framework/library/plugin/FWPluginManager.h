//
//  FWPluginManager.h
//  Framework
//
//  Created by 吴勇 on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWProtocolPluginProvider.h"

//插件管理池
@interface FWPluginManager : NSObject

@singleton(FWPluginManager)

//设置插件提供者，从而实现动态替换插件
- (void)setPluginProvider:(NSString *)name provider:(id<FWProtocolPluginProvider>)provider;

//获取插件对象
- (id<FWProtocolPlugin>)getPlugin:(NSString *)name;

@end
