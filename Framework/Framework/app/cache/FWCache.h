//
//  FWCache.h
//  Framework
//
//  Created by 吴勇 on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//缓存协议
@protocol FWProtocolCache <NSObject>

@required
- (id)get:(NSString *)key;
- (BOOL)has:(NSString *)key;
- (void)set:(NSString *)key object:(id)object;
- (void)remove:(NSString *)key;
- (void)clear;

@end

//框架默认缓存
@interface FWCache : NSObject<FWProtocolCache>

@singleton(FWCache)

//设置缓存，支持有效期
- (void)set:(NSString *)key object:(id)object expire:(NSTimeInterval)expire;

@end
