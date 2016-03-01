//
//  FWHandler.m
//  Framework
//
//  Created by wuyong on 16/2/23.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWHandler.h"

#pragma mark -
@implementation FWHandler
{
    NSMutableDictionary *_blocks;
}

- (id)init
{
    self = [super init];
    if (self) {
        _blocks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_blocks removeAllObjects];
    _blocks = nil;
}

- (BOOL)trigger:(NSString *)name
{
    return [self trigger:name withObject:nil];
}

- (BOOL)trigger:(NSString *)name withObject:(id)object
{
    if (!name) return NO;
    
    FWHandlerBlock block = (FWHandlerBlock)[_blocks objectForKey:name];
    if (!block) return NO;
    
    block(object);
    return YES;
}

- (void)setBlock:(NSString *)name block:(FWHandlerBlock)block
{
    if (!name) return;
    
    if (nil == block) {
        [_blocks removeObjectForKey:name];
    } else {
        [_blocks setObject:block forKey:name];
    }
}

- (void)removeBlock:(NSString *)name
{
    if (!name) return;
    
    [_blocks removeObjectForKey:name];
}

- (void)clearBlocks
{
    [_blocks removeAllObjects];
}

@end

#pragma mark -
@implementation NSObject (FWHandler)

- (FWHandler *)blockHandler
{
    FWHandler *handler = [self getAssociatedObjectForKey:"blockHandler"];
    if (nil == handler) {
        handler = [[FWHandler alloc] init];
        [self retainAssociatedObject:handler forKey:"blockHandler"];
    }
    return handler;
}

@end
