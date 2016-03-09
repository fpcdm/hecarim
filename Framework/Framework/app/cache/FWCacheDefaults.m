//
//  FWCacheDefaults.m
//  Framework
//
//  Created by 吴勇 on 16/3/9.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "FWCacheDefaults.h"

@implementation FWCacheDefaults
{
    NSUserDefaults *defaults;
}

@def_singleton(FWCacheDefaults)

- (id) init
{
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
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
    id object = [defaults objectForKey:key];
    return object ? [self decode:object] : nil;
}

- (BOOL) has:(NSString *)key
{
    id object = [defaults objectForKey:key];
    return object ? YES : NO;
}

- (void) set:(NSString *)key object:(id)object
{
    if (object) {
        [defaults setObject:[self encode:object] forKey:key];
        [defaults synchronize];
    } else {
        [self remove:key];
    }
}

- (void) remove:(NSString *)key
{
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

- (void) clear
{
    [NSUserDefaults resetStandardUserDefaults];
}

@end
