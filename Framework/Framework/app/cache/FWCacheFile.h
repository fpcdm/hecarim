//
//  FWCacheFile.h
//  Framework
//
//  Created by wuyong on 16/3/9.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWCache.h"

//文件缓存
@interface FWCacheFile : NSObject<FWProtocolCache>

@singleton(FWCacheFile)

@end
