//
//  AccountViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/9.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountView.h"
#import "SettingViewController.h"

@interface AccountViewController () <AccountViewDelegate>

@end

@implementation AccountViewController
{
    AccountView *accountView;
}

- (void)loadView
{
    accountView = [[AccountView alloc] init];
    accountView.delegate = self;
    self.view = accountView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"账户";
    
    UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonItem:@"设置"];
    barButtonItem.target = self;
    barButtonItem.action = @selector(pushSetting);
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)pushSetting
{
    SettingViewController *viewController = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
