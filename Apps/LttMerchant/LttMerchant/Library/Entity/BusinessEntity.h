//
//  BusinessEntity.h
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface BusinessEntity : BaseEntity

@property (retain, nonatomic) NSNumber *id;

@property (retain, nonatomic) NSNumber *caseId;

@property (retain, nonatomic) NSNumber *newsId;

@property (retain, nonatomic) NSNumber *merchantId;

@property (retain, nonatomic) NSString *merchantName;

@property (retain, nonatomic) NSString *newsContent;

@property (retain, nonatomic) NSArray *newsImgs;

@property (retain, nonatomic) NSString *createTime;

@end
