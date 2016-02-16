//
//  LttFramework.m
//  Framework
//
//  Created by wuyong on 16/2/16.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "LttFramework.h"

/**************************/
@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color
{
    return [self colorWithHex:color];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    return [self colorWithHex:color alpha:alpha];
}

@end

/**************************/
@implementation NSString (Trim)

+ (NSString *)trim:(NSString *)str
{
    return str ? [str trim] : str;
}

- (NSString *)trim
{
    NSString *trimStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimStr;
}

@end

/**************************/
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

@end

/*******************************/
@implementation UIViewController (Dialog)

- (void) showError: (NSString *) message
{
    [self showError:message callback:nil];
}

- (void) showWarning:(NSString *) message
{
    [self showWarning:message callback:nil];
}

- (void) showMessage:(NSString *) message
{
    [self showMessage:message callback:nil];
}

- (void) showSuccess: (NSString *) message
{
    [self showSuccess:message callback:nil];
}

- (void) showNotification:(NSString *)message callback:(void (^)())callback
{
    [self showButton:message title:@" 查 看 " callback:callback];
}

- (void) loadingSuccess: (NSString *) message
{
    [self finishLoading:message callback:nil];
}

- (void) loadingSuccess:(NSString *)message callback:(void (^)())callback
{
    [self finishLoading:message callback:callback];
}

@end

/*************************************/
@implementation UIViewController (BackButtonHandler)

- (BOOL)shouldNavigationBarPopItem
{
    BOOL shouldPop = YES;
    if([self respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [self navigationShouldPopOnBackButton];
    }
    return shouldPop;
}

@end
