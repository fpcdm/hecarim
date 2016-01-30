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

//NSUserDefaults原生对象
@prop_readonly(NSUserDefaults *, storage)

//格式化字典，去掉NSNull和nil，使其可以保存至NSUserDefaults
- (NSDictionary *)formatDictionary:(NSDictionary *)dictionary;

@end
