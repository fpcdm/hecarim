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
    if (object) {
        [self.storage setObject:object forKey:key];
        [self.storage synchronize];
        
        NSLog(@"set %@: %@", key, object);
    } else {
        [self.storage removeObjectForKey:key];
        [self.storage synchronize];
        
        NSLog(@"delete %@", key);
    }
}

- (id)getData:(NSString *)key
{
    id object = [self.storage objectForKey:key];
    if (!object) {
        return nil;
    }
    
    NSLog(@"get %@: %@", key, object);
    return object;
}

- (id) get:(NSString *)key
{
    return [self getData:key];
}

- (BOOL) has:(NSString *)key
{
    id object = [self.storage objectForKey:key];
    return object ? YES : NO;
}

- (void) set:(NSString *)key object:(id)object
{
    [self setData:key object:object];
}

- (void) remove:(NSString *)key
{
    [self setData:key object:nil];
}

- (void) clear
{
    [NSUserDefaults resetStandardUserDefaults];
}

@end
