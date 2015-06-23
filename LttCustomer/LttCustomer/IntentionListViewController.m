//
//  IntentionListViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "IntentionListViewController.h"

@interface IntentionListViewController ()

@end

@implementation IntentionListViewController

- (void)viewDidLoad {
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"服务单";
}

@end
