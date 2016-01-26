//
//  AddressEntity.h
//  LttMember
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface AddressEntity : BaseEntity

@property (retain, nonatomic) NSNumber *provinceId;

@property (retain, nonatomic) NSString *provinceName;

@property (retain, nonatomic) NSNumber *cityId;

@property (retain, nonatomic) NSString *cityName;

@property (retain, nonatomic) NSNumber *countyId;

@property (retain, nonatomic) NSString *countyName;

@property (retain, nonatomic) NSNumber *streetId;

@property (retain, nonatomic) NSString *streetName;

- (NSString *)areaName;

@end
