//
//  FWPluginNetworkProvider.m
//  Framework
//
//  Created by 吴勇 on 16/1/24.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginNetworkProvider.h"
#import "FWPluginNetworkRestKit.h"

@implementation FWPluginNetworkProvider

- (id<FWPlugin>)providePlugin:(NSString *)name
{
    FWPluginNetworkRestKit *plugin = [FWPluginNetworkRestKit sharedInstance];
    return plugin;
}

@end
