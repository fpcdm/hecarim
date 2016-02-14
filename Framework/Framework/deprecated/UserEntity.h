//
//  UserEntity.h
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseEntity.h"

@interface UserEntity : BaseEntity

@property (nonatomic, retain) NSNumber *id;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *mobile;

@property (nonatomic, retain) NSString *token;

@property (nonatomic, retain) NSString *password;

@property (nonatomic, retain) NSString *type;

@property (nonatomic, retain) NSString *nickname;

@property (nonatomic, retain) NSNumber *sex;

@property (nonatomic, retain) NSString *sexAlias;

@property (nonatomic, retain) NSString *avatar;

@property (nonatomic, retain) NSString *deviceId;

@property (nonatomic, retain) NSString *deviceType;

- (NSString *) sexName;

- (NSString *) displayName;

@end
