//
//  IntentionModel.h
//  LttCustomer
//
//  Created by wuyong on 15/5/6.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"
#import "GoodsEntity.h"
#import "ServiceEntity.h"

@interface CaseEntity : BaseEntity

@property (nonatomic, retain) NSNumber *id;

@property (nonatomic, retain) NSString *no;

@property (nonatomic, retain) NSString *status;

@property (nonatomic, retain) NSString *buyerName;

@property (nonatomic, retain) NSString *buyerMobile;

@property (nonatomic, retain) NSString *buyerAddress;

@property (nonatomic, retain) NSString *createTime;

@property (nonatomic, retain) NSString *customerRemark;

@property (nonatomic, retain) NSNumber *staffId;

@property (nonatomic, retain) NSString *staffName;

@property (nonatomic, retain) NSString *staffMobile;

@property (nonatomic, retain) NSString *staffAvatar;

@property (nonatomic, retain) NSString *staffRemark;

@property (nonatomic, retain) NSString *mapUrl;

@property (nonatomic, retain) NSNumber *rateStar;

@property (nonatomic, retain) NSNumber *typeId;

@property (nonatomic, retain) NSString *typeName;

@property (nonatomic, retain) NSNumber *userId;

@property (nonatomic, retain) NSString *userName;

@property (nonatomic, retain) NSString *userMobile;

@property (nonatomic, retain) NSString *userAvatar;

@property (nonatomic, retain) NSNumber *totalAmount;

@property (nonatomic, retain) NSNumber *goodsAmount;

@property (nonatomic, retain) NSNumber *servicesAmount;

@property (nonatomic, retain) NSArray *goods;

@property (nonatomic, retain) NSArray *services;

@property (nonatomic, retain) id goodsParam;

@property (nonatomic, retain) id servicesParam;

@property (nonatomic, retain) NSNumber *addressId;

- (void) avatarView: (UIImageView *)view;

- (NSString *)statusName;

- (UIColor *)statusColor;

- (BOOL) isFail;

//需求列表页的详细信息
- (NSArray *) details;

@end
