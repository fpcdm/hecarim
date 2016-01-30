//
//  StorageUtil.m
//  LttFramework
//
//  Created by wuyong on 15/6/3.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "StorageUtil.h"
#import "FWStorage.h"

static StorageUtil *sharedStorage = nil;

@implementation StorageUtil

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

- (NSUserDefaults *) storage
{
    return [FWStorage sharedInstance].storage;
}

//整理字典数据，去掉NSNull和nil，使其可以保存至NSUserDefaults
- (NSDictionary *) prepareDictionary: (NSDictionary *) dictionary
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

- (void) setUser: (UserEntity *) user
{
    if (user) {
        //解决NSUserDefaults不能存储nsnull和nil的问题
        NSDictionary *userDict = [user toDictionary];
        userDict = [self prepareDictionary:userDict];
        
        [self.storage setObject:userDict forKey:@"user"];
        [self.storage synchronize];
        
        NSLog(@"set user: %@", userDict);
    } else {
        [self.storage removeObjectForKey:@"user"];
        [self.storage synchronize];
        
        NSLog(@"delete user: %@", user);
    }
}

- (UserEntity *) getUser
{
    NSDictionary *userDict = (NSDictionary *) [self.storage objectForKey:@"user"];
    if (!userDict) {
        return nil;
    }
    
    UserEntity *user = [[UserEntity alloc] init];
    [user fromDictionary:userDict];
    
    NSLog(@"get user: %@", [user toDictionary]);
    return user;
}

- (void) setRemoteNotification:(NSDictionary *)notification
{
    if (notification) {
        [self.storage setObject:notification forKey:@"remote_notification"];
        [self.storage synchronize];
        
        NSLog(@"set remote notification: %@", notification);
    } else {
        [self.storage removeObjectForKey:@"remote_notification"];
        [self.storage synchronize];
        
        NSLog(@"delete remote notification");
    }
}

- (NSDictionary *) getRemoteNotification
{
    NSDictionary *notification = (NSDictionary *) [self.storage objectForKey:@"remote_notification"];
    if (!notification) {
        return nil;
    }
    
    NSLog(@"get remote notification: %@", notification);
    return notification;
}

- (void) setDeviceId:(NSString *)deviceId
{
    if (deviceId) {
        [self.storage setObject:deviceId forKey:@"device_id"];
        [self.storage synchronize];
        
        NSLog(@"set device_id: %@", deviceId);
    } else {
        [self.storage removeObjectForKey:@"device_id"];
        [self.storage synchronize];
        
        NSLog(@"delete device_id");
    }
}

- (NSString *) getDeviceId
{
    NSString *deviceId = (NSString *) [self.storage objectForKey:@"device_id"];
    if (!deviceId) {
        return nil;
    }
    
    NSLog(@"get device_id: %@", deviceId);
    return deviceId;
}

- (void)setData:(NSString *)key object:(id)object
{
    [[FWStorage sharedInstance] set:key object:object];
}

- (id)getData:(NSString *)key
{
    return [[FWStorage sharedInstance] get:key];
}

@end
