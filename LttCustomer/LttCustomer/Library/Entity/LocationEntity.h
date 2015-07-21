//
//  LocationEntity.h
//  LttCustomer
//
//  Created by wuyong on 15/6/25.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface LocationEntity : BaseEntity

@property (retain, nonatomic) NSNumber *latitude;

@property (retain, nonatomic) NSNumber *longitude;

@property (retain, nonatomic) NSString *address;

@property (retain, nonatomic) NSString *detailAddress;

@property (retain, nonatomic) NSNumber *serviceNumber;

@end
