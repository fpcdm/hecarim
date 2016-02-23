//
//  FWRegistry.h
//  Framework
//
//  Created by 吴勇 on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 注册表协议
 */
@protocol FWProtocolRegistry <NSObject>

@required
- (id)get:(NSString *)key;
- (BOOL)has:(NSString *)key;
- (void)set:(NSString *)key object:(id)object;
- (void)remove:(NSString *)key;
- (void)clear;

@end

//注册表缓存：内存
@interface FWRegistry : NSObject<FWProtocolRegistry>

@singleton(FWRegistry)

@end
