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

@synthesize no;

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

- (NSString *)statusName
{
    NSDictionary *names = @{
                            CASE_STATUS_NEW:@"新建",
                            CASE_STATUS_LOCKED:@"已抢单",
                            CASE_STATUS_CONFIRMED:@"已确认",
                            CASE_STATUS_TOPAY:@"待付款",
                            CASE_STATUS_PAYED:@"已付款",
                            CASE_STATUS_SUCCESS:@"已完成",
                            CASE_STATUS_MEMBER_CANCEL:@"已取消",
                            CASE_STATUS_MERCHANT_CANCEL:@"商家已取消"
                            };
    
    NSString *name = [names objectForKey:self.status];
    return name ? name : @"状态错误";
}

- (UIColor *)statusColor
{
    return [UIColor darkGrayColor];
}

- (BOOL) isFail
{
    return [CASE_STATUS_MEMBER_CANCEL isEqualToString:self.status] || [CASE_STATUS_MERCHANT_CANCEL isEqualToString:self.status];
}

- (BOOL) hasOrder
{
    return [CASE_STATUS_TOPAY isEqualToString:self.status] || [CASE_STATUS_PAYED isEqualToString:self.status] || [CASE_STATUS_SUCCESS isEqualToString:self.status];
}

- (BOOL) needRefresh
{
    return [CASE_STATUS_NEW isEqualToString:self.status] || [CASE_STATUS_LOCKED isEqualToString:self.status] || [CASE_STATUS_CONFIRMED isEqualToString:self.status];
}

@end
