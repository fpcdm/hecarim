//
//  CaseEntity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseEntity.h"

@implementation CaseEntity

@synthesize id, no, status, createTime, mapUrl, rateStar, typeId, typeName,
            buyerName, buyerMobile, buyerAddress, customerRemark,
            staffId, staffName, staffMobile, staffAvatar, staffRemark,
            userId, userName, userMobile, userAvatar,
            totalAmount, goodsAmount, servicesAmount, goods, services, goodsParam, servicesParam;

- (NSString *)statusName
{
    NSDictionary *names = @{
                            CASE_STATUS_NEW:@"派单中",
                            CASE_STATUS_LOCKED:@"已派单",
                            CASE_STATUS_CONFIRMED:@"服务中",
                            CASE_STATUS_TOPAY:@"未付款",
                            CASE_STATUS_PAYED:@"已付款",
                            CASE_STATUS_SUCCESS:@"已完成",
                            CASE_STATUS_MEMBER_CANCEL:@"已取消",
                            CASE_STATUS_MERCHANT_CANCEL:@"已取消"
                            };
    
    NSString *name = [names objectForKey:self.status];
    return name ? name : @"状态错误";
}

- (UIColor *)statusColor
{
    if ([CASE_STATUS_NEW isEqualToString:self.status]) {
        return [UIColor colorWithHexString:@"FFA54D"];
    } else if ([CASE_STATUS_LOCKED isEqualToString:self.status]) {
        return [UIColor colorWithHexString:@"FFA54D"];
    } else if ([CASE_STATUS_CONFIRMED isEqualToString:self.status]) {
        return [UIColor colorWithHexString:@"FFA54D"];
    } else if ([CASE_STATUS_TOPAY isEqualToString:self.status]) {
        return [UIColor redColor];
    } else if ([CASE_STATUS_PAYED isEqualToString:self.status]) {
        return [UIColor colorWithHexString:@"4DD14D"];
    } else if ([CASE_STATUS_SUCCESS isEqualToString:self.status]) {
        return [UIColor colorWithHexString:@"4DD14D"];
    } else {
        return [UIColor lightGrayColor];
    }
}

- (BOOL) isFail
{
    return [CASE_STATUS_MEMBER_CANCEL isEqualToString:self.status] || [CASE_STATUS_MERCHANT_CANCEL isEqualToString:self.status];
}

@end