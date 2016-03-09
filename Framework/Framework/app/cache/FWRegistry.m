//
//  FWRegistry.m
//  Framework
//
//  Created by 吴勇 on 16/1/25.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWRegistry.h"

@implementation FWRegistry
{
    NSMutableDictionary *registry;
}

@def_singleton(FWRegistry)

- (instancetype)init
{
    self = [super init];
    if (self) {
        registry = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)get:(NSString *)key
{
    id object = [registry objectForKey:key];
    return object;
}

- (BOOL)has:(NSString *)key
{
    id object = [registry objectForKey:key];
    return object != nil;
}

- (void)set:(NSString *)key object:(id)object
{
    if (object) {
        [registry setObject:object forKey:key];
    } else {
        [registry removeObjectForKey:key];
    }
}

- (void)remove:(NSString *)key
{
    [registry removeObjectForKey:key];
}

- (void)clear
{
    [registry removeAllObjects];
}

@end
