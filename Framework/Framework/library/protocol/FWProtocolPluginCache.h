//
//  FWProtocolPluginCache.h
//  Framework
//
//  Created by 吴勇 on 16/1/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWProtocolPlugin.h"

//定义插件池默认保存名称
#define FWProtocolPluginCacheName @"FWProtocolPluginCache"

@protocol FWProtocolPluginCache <FWProtocolPlugin>

- (id)get:(NSString *)key;

- (BOOL)has:(NSString *)key;

- (void)set:(NSString *)key object:(id)object;

- (void)remove:(NSString *)key;

- (void)clear;

@end
