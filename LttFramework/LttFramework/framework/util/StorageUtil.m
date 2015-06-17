//
//  StorageUtil.m
//  LttFramework
//
//  Created by wuyong on 15/6/3.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "StorageUtil.h"

static StorageUtil *sharedStorage = nil;

@implementation StorageUtil
{
    NSUserDefaults *storage;
}

+ (StorageUtil *) sharedStorage
{
    //多线程唯一
    @synchronized(self){
        if (!sharedStorage) {
            sharedStorage = [[self alloc] init];
        }
    }
    return sharedStorage;
}

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

//整理字典数据，去掉NSNull和nil，使其可以保存至NSUserDefaults
- (NSDictionary *) prepareDictionary: (NSDictionary *) dictionary
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    
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

- (void) setUser: (UserEntity *) user
{
    if (user) {
        //解决NSUserDefaults不能存储nsnull和nil的问题
        NSDictionary *userDict = [user toDictionary];
        userDict = [self prepareDictionary:userDict];
        
        [storage setObject:userDict forKey:@"user"];
        [storage synchronize];
        
        NSLog(@"set user: %@", userDict);
    } else {
        [storage removeObjectForKey:@"user"];
        [storage synchronize];
        
        NSLog(@"delete user: %@", user);
    }
}

- (UserEntity *) getUser
{
    NSDictionary *userDict = (NSDictionary *) [storage objectForKey:@"user"];
    if (!userDict) {
        return nil;
    }
    
    UserEntity *user = [[UserEntity alloc] init];
    [user fromDictionary:userDict];
    
    NSLog(@"get user: %@", [user toDictionary]);
    return user;
}

@end
