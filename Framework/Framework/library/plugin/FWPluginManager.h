//
//  FWPluginManager.h
//  Framework
//
//  Created by 吴勇 on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWPluginProvider.h"

//插件管理池
@interface FWPluginManager : NSObject

@singleton(FWPluginManager)

//设置插件提供者对象
- (void)setProvider:(NSString *)name provider:(id<FWPluginProvider>)provider;

//获取插件对象
- (id)getPlugin:(NSString *)name;

@end
