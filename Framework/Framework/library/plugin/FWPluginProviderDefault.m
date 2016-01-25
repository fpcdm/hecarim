//
//  FWPluginProviderDefault.m
//  Framework
//
//  Created by 吴勇 on 16/1/26.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginProviderDefault.h"
#import "FWPluginDialogDefault.h"

@implementation FWPluginProviderDefault

- (id)providePlugin:(NSString *)name
{
    id plugin = nil;
    //默认弹出框
    if ([FWPluginDialogName isEqualToString:name]) {
        plugin = [[FWPluginDialogDefault alloc] init];
    }
    return plugin;
}

@end
