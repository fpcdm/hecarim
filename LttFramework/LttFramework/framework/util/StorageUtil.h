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

- (void) setUser: (UserEntity *) user;

- (UserEntity *) getUser;

@end
