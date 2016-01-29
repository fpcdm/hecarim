//
//  FWPluginProviderDefault.h
//  Framework
//
//  Created by 吴勇 on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWPluginProvider.h"

//默认插件提供者
@interface FWPluginProviderDefault : NSObject<FWPluginProvider>

@singleton(FWPluginProviderDefault)

//自定义插件，替换默认插件
- (void)setPlugin:(NSString *)name plugin:(id)plugin;

@end
