//
//  IntentionModel.m
//  LttCustomer
//
//  Created by wuyong on 15/5/6.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "IntentionEntity.h"

@implementation IntentionEntity

@synthesize id;

@synthesize type;

@synthesize location;

@synthesize remark;

@synthesize status;

@synthesize createTime;

@synthesize userId;

@synthesize userName;

@synthesize userMobile;

@synthesize responseTime;

@synthesize responseStatus;

@synthesize orderNo;

@synthesize employeeId;

@synthesize employeeName;

@synthesize employeeMobile;

@synthesize employeeAvatar;

@synthesize details;

- (UIImage *) avatarImage
{
    UIImage *avatar = [UIImage imageNamed:@"support"];
    return avatar;
}

- (NSString *)statusName
{
    //todo
    return @"已完成";
}

- (UIColor *)statusColor
{
    return [UIColor colorWithHexString:COLOR_DARK_TEXT];
}

@end
