//
//  IntentionModel.h
//  LttCustomer
//
//  Created by wuyong on 15/5/6.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface IntentionEntity : BaseEntity

@property (nonatomic, retain) NSNumber *id;

@property (nonatomic, retain) NSNumber *brandId;

@property (nonatomic, retain) NSString *brandName;

@property (nonatomic, retain) NSNumber *categoryId;

@property (nonatomic, retain) NSString *location;

@property (nonatomic, retain) NSNumber *modelId;

@property (nonatomic, retain) NSString *modelName;

@property (nonatomic, retain) NSString *remark;

@property (nonatomic, retain) NSString *status;

@property (nonatomic, retain) NSString *createTime;

@property (nonatomic, retain) NSNumber *userId;

@property (nonatomic, retain) NSString *userName;

@property (nonatomic, retain) NSString *userMobile;

@property (nonatomic, retain) NSString *responseTime;

@property (nonatomic, retain) NSString *responseStatus;

@property (nonatomic, retain) NSString *orderNo;

@property (nonatomic, retain) NSNumber *employeeId;

@property (nonatomic, retain) NSString *employeeName;

@property (nonatomic, retain) NSString *employeeMobile;

@end
