//
//  SafetyViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SafetyViewController.h"
#import "SafetyView.h"
#import "SafetyPasswordViewController.h"

@interface SafetyViewController () <SafetyViewDelegate>

@end

@implementation SafetyViewController
{
    SafetyView *safetyView;
}

- (void)loadView
{
    safetyView = [[SafetyView alloc] init];
    safetyView.delegate = self;
    self.view = safetyView;
    
    //加载数据
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    [safetyView setData:@"user" value:user];
    [safetyView renderData];
}

- (void)viewDidLoad {
    hasNavBack = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"账户与安全";
}

#pragma mark - Action
- (void)actionPassword
{
    SafetyPasswordViewController *viewController = [[SafetyPasswordViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

@end
