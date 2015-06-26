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

@synthesize sexAlias;

@synthesize avatar;

- (NSString *)sexName
{
    if (self.sex == nil || [@0 isEqualToNumber:self.sex]) {
        return @"";
    } else if ([@1 isEqualToNumber:self.sex]) {
        return @"男";
    } else {
        return @"女";
    }
}

@end
