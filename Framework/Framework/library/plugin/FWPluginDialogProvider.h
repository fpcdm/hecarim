//
//  FWPluginDialogProvider.h
//  Framework
//
//  Created by 吴勇 on 16/1/23.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWPluginManager.h"

@protocol FWPluginDialog <NSObject>

@end

@interface FWPluginDialogProvider : NSObject<FWPluginProvider>

@end
