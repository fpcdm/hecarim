//
//  FWPluginCache.h
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义插件池默认保存名称
#define FWPluginCacheName @"FWPluginCache"

@protocol FWPluginCache <NSObject>

- (id)get:(NSString *)key;

- (BOOL)has:(NSString *)key;

- (void)set:(NSString *)key object:(id)object;

- (void)remove:(NSString *)key;

- (void)clear;

@end
