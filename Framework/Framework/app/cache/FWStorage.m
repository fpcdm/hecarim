//
//  FWStorage.m
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWStorage.h"

@implementation FWStorage
{
    NSUserDefaults *storage;
}

@def_singleton(FWStorage)

- (id) init
{
    self = [super init];
    if (self) {
        storage = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (id)encode:(id)object
{
    //是否实现NSCoding
    if ([object conformsToProtocol:@protocol(NSCoding)]) {
        object = [NSKeyedArchiver archivedDataWithRootObject:object];
    }
    return object;
}

- (id)decode:(id)object
{
    //NSCoding解码
    if ([object isKindOfClass:[NSData class]]) {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)object];
    }
    return object;
}

- (id) get:(NSString *)key
{
    id object = [storage objectForKey:key];
    return object ? [self decode:object] : nil;
}

- (BOOL) has:(NSString *)key
{
    id object = [storage objectForKey:key];
    return object ? YES : NO;
}

- (void) set:(NSString *)key object:(id)object
{
    if (object) {
        [storage setObject:[self encode:object] forKey:key];
        [storage synchronize];
    } else {
        [self remove:key];
    }
}

- (void) remove:(NSString *)key
{
    [storage removeObjectForKey:key];
    [storage synchronize];
}

- (void) clear
{
    [NSUserDefaults resetStandardUserDefaults];
}

@end
