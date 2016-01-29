//
//  FWPluginLoadingDefault.h
//  Framework
//
//  Created by wuyong on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWPluginLoading.h"

//加载条模式
typedef enum {
    FWPluginLoadingModeIndicator = 0,
    FWPluginLoadingModeText,
} FWPluginLoadingMode;

@interface FWPluginLoadingDefault : NSObject<FWPluginLoading>

@prop_assign(FWPluginLoadingMode, mode)

@end
