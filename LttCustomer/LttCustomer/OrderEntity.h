//
//  OrderModel.h
//  LttCustomer
//
//  Created by wuyong on 15/5/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"
#import "GoodsEntity.h"
#import "ServiceEntity.h"

@interface OrderEntity : BaseEntity

@property (nonatomic, retain) NSString *no;

@property (nonatomic, retain) NSNumber *amount;

@property (nonatomic, retain) NSString *buyerMobile;

@property (nonatomic, retain) NSString *buyerName;

@property (nonatomic, retain) NSString *createTime;

@property (nonatomic, retain) NSString *sellerMobile;

@property (nonatomic, retain) NSString *sellerName;

@property (nonatomic, retain) NSString *updateTime;

@property (nonatomic, retain) NSString *status;

@property (nonatomic, retain) NSString *qrcode;

@property (nonatomic, retain) NSArray *goods;

@property (nonatomic, retain) NSArray *services;

@property (nonatomic, retain) NSNumber *commentLevel;

- (UIImage *) avatarImage;

@end
