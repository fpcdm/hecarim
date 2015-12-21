//
//  PaymentEntity.h
//  LttMember
//
//  Created by wuyong on 15/12/21.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface PaymentEntity : BaseEntity

@property (nonatomic, retain) NSNumber *amount;

@property (nonatomic, retain) NSString *body;

@property (nonatomic, retain) NSString *ip;

@property (nonatomic, retain) NSNumber *merchantId;

@property (nonatomic, retain) NSString *orderNo;

@property (nonatomic, retain) NSString *subject;

@property (nonatomic, retain) NSNumber *type;

@end
