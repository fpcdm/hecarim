//
//  FWPluginDialogProvider.m
//  Framework
//
//  Created by wuyong on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginDialogProvider.h"
#import "FWPluginDialogDefault.h"
#import "FWPluginManager.h"

@implementation FWPluginDialogProvider

//初始化默认提供者
+ (void)load
{
    if (![[FWPluginManager sharedInstance] hasPluginProvider:FWProtocolPluginDialogName]) {
        FWPluginDialogProvider *provider = [[FWPluginDialogProvider alloc] init];
        [[FWPluginManager sharedInstance] setPluginProvider:FWProtocolPluginDialogName provider:provider];
    }
}

- (id<FWProtocolPlugin>)providePlugin:(NSString *)name
{
    FWPluginDialogDefault *plugin = [FWPluginDialogDefault sharedInstance];
    return plugin;
}

@end
