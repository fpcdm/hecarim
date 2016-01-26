//
//  FWCache.h
//  Framework
//
//  Created by 吴勇 on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWPluginCache.h"

//框架缓存：文件
@interface FWCache : NSObject<FWPluginCache>

@singleton(FWCache)

@end
