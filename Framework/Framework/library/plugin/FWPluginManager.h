//
//  FWPluginManager.h
//  Framework
//
//  Created by 吴勇 on 16/1/21.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//插件管理池
@interface FWPluginManager : NSObject

@singleton(FWPluginManager)

//自定义插件，替换默认插件
- (void)setPlugin:(NSString *)name plugin:(id)plugin;

//获取插件对象
- (id)getPlugin:(NSString *)name;

@end
