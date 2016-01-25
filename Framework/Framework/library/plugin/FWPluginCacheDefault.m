//
//  FWPluginCacheDefault.m
//  Framework
//
//  Created by wuyong on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWPluginCacheDefault.h"

@implementation FWPluginCacheDefault

@def_singleton(FWPluginCacheDefault)

- (id)get:(NSString *)key
{
    return nil;
}

- (BOOL)has:(NSString *)key
{
    return NO;
}

- (void)set:(NSString *)key object:(id)object
{
    
}

- (void)remove:(NSString *)key
{
    
}

- (void)clear
{
    
}

@end
