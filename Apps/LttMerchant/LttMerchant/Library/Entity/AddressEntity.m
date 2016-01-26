//
//  AddressEntity.m
//  LttMember
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AddressEntity.h"

@implementation AddressEntity

@synthesize provinceId, provinceName, cityId, cityName, countyId, countyName, streetId, streetName;

- (NSString *)areaName
{
    NSString *areaName = [NSString stringWithFormat:@"%@ %@ %@", self.provinceName ? self.provinceName : @"", self.cityName ? self.cityName : @"", self.countyName ? self.countyName : @""];
    return areaName;
}

@end
