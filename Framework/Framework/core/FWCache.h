//
//  FWCache.h
//  Framework
//
//  Created by 吴勇 on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FWCacheProtocol <NSObject>

- (id)get:(NSString *)key;

- (BOOL)has:(NSString *)key;

- (void)set:(NSString *)key object:(id)object;

- (void)remove:(NSString *)key;

- (void)clear;

@end

@interface FWCache : NSObject<FWCacheProtocol>

@singleton(FWCache)

@end
