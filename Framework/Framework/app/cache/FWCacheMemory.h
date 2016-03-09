//
//  FWCacheMemory.h
//  Framework
//
//  Created by 吴勇 on 16/3/9.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWCache.h"

//内存缓存
@interface FWCacheMemory : NSObject<FWProtocolCache>

@singleton(FWCacheMemory)

@end
