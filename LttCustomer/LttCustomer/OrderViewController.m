//
//  OrderViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    isIndexNavBar = YES;
    hideBackButton = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"账单确认并支付";
}

@end
