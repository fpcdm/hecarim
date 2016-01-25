//
//  FWPluginCacheDefault.h
//  Framework
//
//  Created by wuyong on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWProtocolPluginCache.h"

@interface FWPluginCacheDefault : NSObject<FWProtocolPluginCache>

@singleton(FWPluginCacheDefault)

@end
