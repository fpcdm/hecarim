//
//  FWStorage.h
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWPluginCache.h"

@interface FWStorage : NSObject<FWPluginCache>

@singleton(FWStorage)

@end
