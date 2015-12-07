//
//  AccountViewController.m
//  LttMember
//
//  Created by wuyong on 15/6/9.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountView.h"
#import "SettingViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "SafetyViewController.h"
#import "AddressViewController.h"
#import "SuggestionViewController.h"
#import "RecommendShareViewController.h"
#import "HomeViewController.h"
#import "UserHandler.h"
#import "UIViewController+BackButtonHandler.h"

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
    isMenuEnabled = NO;
    hideBackButton = NO;
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"账户";
    
    UIBarButtonItem *rightButtonItem = [AppUIUtil makeBarButtonItem:@"设置" highlighted:isIndexNavBar];
    rightButtonItem.target = self;
    rightButtonItem.action = @selector(actionSetting);
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark - Home
- (BOOL)navigationShouldPopOnBackButton
{
    HomeViewController *viewController = [[HomeViewController alloc] init];
    [self toggleViewController:viewController animated:YES];
    
    return NO;
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
    
    //头像回调
    viewController.callbackBlock = ^(id object){
        //加载数据
        UserEntity *user = [[StorageUtil sharedStorage] getUser];
        [accountView setData:@"user" value:user];
        [accountView renderData];
    };
    
    [self pushViewController:viewController animated:YES];
}

- (void)actionLogout
{
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    
    //退出接口
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler logoutWithUser:user success:^(NSArray *result){
        [[StorageUtil sharedStorage] setUser:nil];
        [[StorageUtil sharedStorage] setRemoteNotification:nil];
        
        //刷新菜单
        [self refreshMenu];
        
        LoginViewController *viewController = [[LoginViewController alloc] init];
        [self pushViewController:viewController animated:YES];
    } failure:^(ErrorEntity *error){
        //接口失败也同样退出
        [[StorageUtil sharedStorage] setUser:nil];
        [[StorageUtil sharedStorage] setRemoteNotification:nil];
        
        //刷新菜单
        [self refreshMenu];
        
        LoginViewController *viewController = [[LoginViewController alloc] init];
        [self pushViewController:viewController animated:YES];
    }];
}

- (void)actionSafety
{
    SafetyViewController *viewController = [[SafetyViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionAddress
{
    AddressViewController *viewController = [[AddressViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionSuggestion
{
    SuggestionViewController *viewController = [[SuggestionViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionRecommendShare
{
    RecommendShareViewController *viewController = [[RecommendShareViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

@end
