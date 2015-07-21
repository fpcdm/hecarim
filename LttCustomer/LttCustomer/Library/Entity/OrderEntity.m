//
//  OrderModel.m
//  LttCustomer
//
//  Created by wuyong on 15/5/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "OrderEntity.h"
#import "UIImageView+WebCache.h"

@implementation OrderEntity

@synthesize no;

@synthesize amount;

@synthesize buyerMobile;

@synthesize buyerName;

@synthesize createTime;

@synthesize sellerMobile;

@synthesize sellerName;

@synthesize sellerAvatar;

@synthesize updateTime;

@synthesize status;

@synthesize qrcode;

@synthesize goods;

@synthesize goodsParam;

@synthesize services;

@synthesize commentLevel;

- (void) avatarView:(UIImageView *)view
{
    if (self.sellerAvatar && [self.sellerAvatar length] > 0) {
        NSLog(@"加载头像缓存：%@", self.sellerAvatar);
        [view sd_setImageWithURL:[NSURL URLWithString:self.sellerAvatar] placeholderImage:[UIImage imageNamed:@"support"]];
    } else {
        view.image = [UIImage imageNamed:@"support"];
    }
}

@end
