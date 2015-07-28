//
//  ServiceEntity.m
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ServiceEntity.h"

@implementation ServiceEntity

@synthesize id;

@synthesize name;

@synthesize number;

@synthesize price;

@synthesize typeId;

@synthesize typeName;

- (NSNumber *) total
{
    NSNumber *total = [NSNumber numberWithDouble:([self.price doubleValue] * [self.number doubleValue])];
    return total;
}

@end
