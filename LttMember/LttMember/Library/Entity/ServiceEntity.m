//
//  ServiceEntity.m
//  LttMember
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ServiceEntity.h"

@implementation ServiceEntity

@synthesize id;

@synthesize name;

@synthesize price;

@synthesize typeId;

@synthesize typeName;

- (NSNumber *) total
{
    return self.price ? self.price : @0.00;
}

@end
