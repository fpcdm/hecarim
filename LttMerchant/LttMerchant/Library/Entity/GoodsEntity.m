//
//  GoodsModel.m
//  LttCustomer
//
//  Created by wuyong on 15/5/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsEntity.h"

@implementation GoodsEntity

@synthesize id;

@synthesize name;

@synthesize number;

@synthesize price;

@synthesize specName;

@synthesize categoryId;

@synthesize brandId;

@synthesize modelId;

@synthesize priceId;

@synthesize priceList;

@synthesize specList;

- (NSNumber *) total
{
    NSNumber *total = [NSNumber numberWithDouble:([self.price doubleValue] * [self.number doubleValue])];
    return total;
}

@end
