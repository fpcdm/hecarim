//
//  GoodsListActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsListActivity.h"

@interface GoodsListActivity ()

@end

@implementation GoodsListActivity

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
}

- (NSString *)templateName
{
    return @"goodsList.html";
}

@end
