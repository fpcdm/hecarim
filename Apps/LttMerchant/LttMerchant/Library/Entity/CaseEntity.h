//
//  CaseEntity.h
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

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

@property (nonatomic, retain) NSNumber *propertyId;

@property (nonatomic, retain) NSString *propertyName;

@property (nonatomic, retain) NSNumber *userId;

@property (nonatomic, retain) NSString *userName;

@property (nonatomic, retain) NSString *userMobile;

@property (nonatomic, retain) NSString *userAppellation;

@property (nonatomic, retain) NSString *userAvatar;

@property (nonatomic, retain) NSNumber *isOnlinePay;

@property (nonatomic, retain) NSString *payWay;

@property (nonatomic, retain) NSString *qrcodeUrl;

@property (nonatomic, retain) NSNumber *totalAmount;

@property (nonatomic, retain) NSNumber *goodsAmount;

@property (nonatomic, retain) NSNumber *servicesAmount;

@property (nonatomic, retain) NSArray *goods;

@property (nonatomic, retain) NSArray *services;

@property (nonatomic, retain) id goodsParam;

@property (nonatomic, retain) id servicesParam;

- (NSString *)statusName;

- (UIColor *)statusColor;

- (BOOL) isFail;

- (void) qrcodeImageView:(UIImageView *)imageView way:(NSString *)way failure:(void (^)())failure;

//格式化商品供表单提交用
- (NSDictionary *) formatFormGoods;

//格式化服务供表单提交用
- (NSDictionary *) formatFormServices;

@end