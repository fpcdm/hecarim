//
//  DynamicEntity.m
//  Framework
//
//  Created by wuyong on 16/1/15.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "DynamicEntity.h"

@implementation DynamicEntity
{
    NSMutableDictionary *_data;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSDictionary *)data
{
    return [NSDictionary dictionaryWithDictionary:_data];
}

- (void)setData:(NSDictionary *)data
{
    _data = [NSMutableDictionary dictionaryWithDictionary:data];
}

- (id)get:(NSString *)key
{
    id object = [_data objectForKey:key];
    return object;
}

- (BOOL)has:(NSString *)key
{
    id object = [_data objectForKey:key];
    return object != nil ? YES : NO;
}

- (void)set:(NSString *)key object:(id)object
{
    if (object == nil) {
        [self remove:key];
    } else {
        [_data setObject:object forKey:key];
    }
}

- (void)remove:(NSString *)key
{
    [_data removeObjectForKey:key];
}

- (void)clear
{
    _data = [[NSMutableDictionary alloc] init];
}

@end
