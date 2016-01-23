//
//  FWProtocolPluginProvider.h
//  Framework
//
//  Created by 吴勇 on 16/1/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWProtocolPlugin.h"

@protocol FWProtocolPluginProvider <NSObject>

//提供插件对象
- (id<FWProtocolPlugin>)providePlugin:(NSString *)name;

@end
