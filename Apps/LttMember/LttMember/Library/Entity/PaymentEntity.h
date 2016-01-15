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

@property (nonatomic, retain) NSNumber *caseId;

@property (nonatomic, retain) NSNumber *type;

@end
