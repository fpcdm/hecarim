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

- (void) setUser: (UserEntity *) user
{
    if (user) {
        //解决NSUserDefaults不能存储null的问题
        UserEntity *userCopy = [[UserEntity alloc] init];
        userCopy.id = user.id ? user.id : @0;
        userCopy.name = user.name ? user.name : @"";
        userCopy.mobile = user.mobile ? user.mobile : @"";
        userCopy.token = user.token ? user.token : @"";
        userCopy.password = user.password ? user.password : @"";
        userCopy.type = user.type ? user.type : @"";
        
        NSDictionary *userDict = [userCopy toDictionary];
        userCopy = nil;
        
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
    
    //还原NSUserDefaults空值为null
    if ([@0 isEqualToNumber:user.id]) user.id = nil;
    if ([@"" isEqualToString:user.name]) user.name = nil;
    if ([@"" isEqualToString:user.mobile]) user.mobile = nil;
    if ([@"" isEqualToString:user.token]) user.token = nil;
    if ([@"" isEqualToString:user.password]) user.password = nil;
    if ([@"" isEqualToString:user.type]) user.type = nil;
    
    NSLog(@"get user: %@", [user toDictionary]);
    return user;
}

@end
