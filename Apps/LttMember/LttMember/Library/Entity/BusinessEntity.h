//
//  BusinessEntity.h
//  LttMember
//
//  Created by wuyong on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface BusinessEntity : BaseEntity

@property (retain, nonatomic) NSNumber *id;

@property (retain, nonatomic) NSNumber *typeId;

@property (retain, nonatomic) NSString *content;

@property (retain, nonatomic) NSNumber *merchantId;

@property (retain, nonatomic) NSString *merchantName;

@property (retain, nonatomic) NSString *createTime;

@property (retain, nonatomic) NSArray *images;

@end
