//
//  OrderModel.m
//  LttCustomer
//
//  Created by wuyong on 15/5/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "OrderEntity.h"

@implementation OrderEntity

@synthesize no;

@synthesize amount;

@synthesize buyerMobile;

@synthesize buyerName;

@synthesize createTime;

@synthesize sellerMobile;

@synthesize sellerName;

@synthesize updateTime;

@synthesize status;

@synthesize qrcode;

@synthesize goods;

@synthesize services;

@synthesize commentLevel;

- (UIImage *) avatarImage
{
    UIImage *avatar = [UIImage imageNamed:@"nopic"];
    return avatar;
}

@end
