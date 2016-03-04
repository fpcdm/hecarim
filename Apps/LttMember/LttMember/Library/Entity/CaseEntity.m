//
//  IntentionModel.m
//  LttMember
//
//  Created by wuyong on 15/5/6.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseEntity.h"
#import "GoodsEntity.h"
#import "ServiceEntity.h"

@implementation CaseEntity

@synthesize id, no, status, createTime, mapUrl, rateStar, typeId, typeName,
buyerName, buyerMobile, buyerAddress, customerRemark,
staffId, staffName, staffMobile, staffAvatar, staffRemark,
userId, userName, userMobile, userAvatar,
isOnlinePay, payWay, qrcodeUrl,
totalAmount, goodsAmount, servicesAmount, goods, services, goodsParam, servicesParam;

@synthesize addressId;

@synthesize propertyId;

@synthesize merchantId, source, sourceId;

- (void) avatarView: (UIImageView *)view
{
    if (self.staffAvatar && [self.staffAvatar length] > 0) {
        NSLog(@"加载头像缓存：%@", self.staffAvatar);
        [view setImageUrl:self.staffAvatar placeholder:[UIImage imageNamed:@"support"]];
    } else {
        view.image = [UIImage imageNamed:@"support"];
    }
}

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

- (NSArray *) details
{
    NSMutableArray *details = [[NSMutableArray alloc] init];
    
    //先取商品和服务信息
    if (self.goods && [self.goods count] > 0) {
        for (GoodsEntity *goodsEntity in self.goods) {
            [details addObject:goodsEntity.name];
        }
    }
    if (self.services && [self.services count] > 0) {
        for (ServiceEntity *serviceEntity in self.services) {
            [details addObject:serviceEntity.name];
        }
    }
    
    return details;
}

@end
