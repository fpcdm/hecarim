//
//  FWCache.h
//  Framework
//
//  Created by 吴勇 on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWPluginCache.h"

//缓存适配器
@interface FWCache : NSObject<FWPluginCache>

@singleton(FWCache)

@end
