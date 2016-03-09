//
//  FWRegistry.h
//  Framework
//
//  Created by 吴勇 on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWCache.h"

//框架缓存：内存
@interface FWRegistry : NSObject<FWProtocolCache>

@singleton(FWRegistry)

@end
