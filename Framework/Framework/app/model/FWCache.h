//
//  FWCache.h
//  Framework
//
//  Created by 吴勇 on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWRegistry.h"

//框架缓存：文件
@interface FWCache : NSObject<FWProtocolRegistry>

@singleton(FWCache)

//设置缓存，支持有效期
- (void)set:(NSString *)key object:(id)object expire:(NSTimeInterval)expire;

@end
