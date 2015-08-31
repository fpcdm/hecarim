//
//  StorageUtil.h
//  LttFramework
//
//  Created by wuyong on 15/6/3.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"

@interface StorageUtil : NSObject

+ (StorageUtil *) sharedStorage;

- (NSUserDefaults *) storage;

//整理字典数据，去掉NSNull和nil，使其可以保存至NSUserDefaults
- (NSDictionary *) prepareDictionary: (NSDictionary *) dictionary;

- (void) setUser: (UserEntity *) user;

- (UserEntity *) getUser;

- (void) setRemoteNotification: (NSDictionary *)notification;

- (NSDictionary *) getRemoteNotification;

- (void) setDeviceId: (NSString *) deviceId;

- (NSString *) getDeviceId;

- (void) setData:(NSString *)key object:(id)object;

- (id) getData:(NSString *)key;

@end
