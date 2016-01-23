//
//  FWPluginNetworkProvider.h
//  Framework
//
//  Created by 吴勇 on 16/1/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWPluginManager.h"

@protocol FWPluginNetwork <FWPlugin>

@end

//默认网络插件：RestKit
@interface FWPluginNetworkProvider : NSObject<FWPluginProvider>

@end
