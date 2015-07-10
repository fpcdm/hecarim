//
//  UserEntity.m
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity

@synthesize id;

@synthesize name;

@synthesize mobile;

@synthesize token;

@synthesize password;

@synthesize type;

@synthesize nickname;

@synthesize sex;

@synthesize avatar;

@synthesize deviceId;

@synthesize deviceType;

- (NSString *)sexAlias
{
    if (self.sex != nil) {
        if ([@1 isEqualToNumber:self.sex]) {
            return @"boy";
        } else if ([@2 isEqualToNumber:self.sex]) {
            return @"girl";
        }
    }
    return @"";
}

- (void)setSexAlias:(NSString *)sexAlias
{
    if (!sexAlias || [sexAlias length] < 1) {
        self.sex = @0;
    } else if ([@"boy" isEqualToString:sexAlias]) {
        self.sex = @1;
    } else if ([@"girl" isEqualToString:sexAlias]) {
        self.sex = @2;
    }
}

- (NSString *)sexName
{
    if (self.sex != nil) {
        if ([@1 isEqualToNumber:self.sex]) {
            return @"男";
        } else if ([@2 isEqualToNumber:self.sex]) {
            return @"女";
        }
    }
    return @"";
}

- (NSString *)displayName
{
    if (self.name && [self.name length] > 0) {
        return self.name;
    } else if (self.nickname && [self.nickname length] > 0) {
        return self.nickname;
    } else {
        return @"";
    }
}

@end
