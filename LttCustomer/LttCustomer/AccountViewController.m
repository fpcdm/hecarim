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
#import "ProfileViewController.h"
#import "LoginViewController.h"

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
    
    //加载数据
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    [accountView setData:@"user" value:user];
    [accountView renderData];
}

- (void)viewDidLoad
{
    hideBackButton = YES;
    isIndexNavBar = YES;
    hasNavBack = YES;
    [super viewDidLoad];
    
    self.title = @"账户";
    
    UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonItem:@"设置" highlighted:isIndexNavBar];
    barButtonItem.target = self;
    barButtonItem.action = @selector(actionSetting);
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (BOOL) hasTabBar
{
    return YES;
}

#pragma mark - Action
- (void)actionSetting
{
    SettingViewController *viewController = [[SettingViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionContact:(NSString *)tel
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

- (void)actionProfile
{
    ProfileViewController *viewController = [[ProfileViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionLogout
{
    [[StorageUtil sharedStorage] setUser:nil];
    
    LoginViewController *viewController = [[LoginViewController alloc] init];
    viewController.returnController = [[AccountViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

@end
