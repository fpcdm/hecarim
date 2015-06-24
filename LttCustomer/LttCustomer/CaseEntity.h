//
//  IntentionModel.h
//  LttCustomer
//
//  Created by wuyong on 15/5/6.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface CaseEntity : BaseEntity

@property (nonatomic, retain) NSNumber *id;

@property (nonatomic, retain) NSString *no;

@property (nonatomic, retain) NSString *location;

@property (nonatomic, retain) NSString *remark;

@property (nonatomic, retain) NSNumber *type;

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

@property (nonatomic, retain) NSString *employeeAvatar;

@property (nonatomic, retain) NSArray *details;

- (UIImage *)avatarImage;

- (NSString *)statusName;

- (UIColor *)statusColor;

- (BOOL) isFail;

- (BOOL) hasOrder;

- (BOOL) needRefresh;

@end
