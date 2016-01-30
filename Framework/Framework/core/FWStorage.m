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

- (NSUserDefaults *) storage
{
    return storage;
}

- (NSDictionary *)formatDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    if (dictionary) {
        for (id key in dictionary) {
            id value = [dictionary objectForKey:key];
            if (value != nil && value != [NSNull null]) {
                [mutableDictionary setObject:value forKey:key];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

- (id) get:(NSString *)key
{
    id object = [storage objectForKey:key];
    return object ? object : nil;
}

- (BOOL) has:(NSString *)key
{
    id object = [storage objectForKey:key];
    return object ? YES : NO;
}

- (void) set:(NSString *)key object:(id)object
{
    if (object && object != [NSNull null]) {
        [storage setObject:object forKey:key];
        [storage synchronize];
    } else {
        [storage removeObjectForKey:key];
        [storage synchronize];
    }
}

- (void) remove:(NSString *)key
{
    [self set:key object:nil];
}

- (void) clear
{
    [NSUserDefaults resetStandardUserDefaults];
}

@end
