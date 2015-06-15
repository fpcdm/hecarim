//
//  BaseViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"
#import "LoginViewController.h"
#import "AppExtension.h"
#import "AppUserViewController.h"

@interface AppViewController ()

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //子页面是否有导航返回按钮
    if (hasNavBack) {
        UIBarButtonItem *backButtonItem = [AppUIUtil makeBarButtonItem:@""];
        self.navigationItem.backBarButtonItem = backButtonItem;
    }
    
    //当前页面是否隐藏返回按钮
    if (hideBackButton) {
        self.navigationItem.hidesBackButton = YES;
    } else {
        self.navigationItem.hidesBackButton = NO;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏TabBar
    self.tabBarController.tabBar.hidden = [self hasTabBar] ? NO : YES;
    
    //状态栏颜色
    if (isIndexNavBar) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    //导航栏高亮，返回时保留
    if (isIndexNavBar) {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.barTintColor = [UIColor colorWithHexString:COLOR_INDEX_TITLE_BG];
        navigationBar.tintColor = [UIColor colorWithHexString:COLOR_INDEX_TITLE];
        navigationBar.titleTextAttributes = @{
                                              NSForegroundColorAttributeName: [UIColor colorWithHexString:COLOR_INDEX_TITLE]
                                              };
    } else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.barTintColor = [UIColor colorWithHexString:COLOR_MAIN_TITLE_BG];
        navigationBar.tintColor = [UIColor colorWithHexString:COLOR_MAIN_TITLE];
        navigationBar.titleTextAttributes = @{
                                              NSForegroundColorAttributeName: [UIColor colorWithHexString:COLOR_MAIN_TITLE]
                                              };
    }
}

- (BOOL) isLogin
{
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    if (user) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) hasTabBar {
    return NO;
}

- (void) pushViewController:(AppViewController *)viewController animated: (BOOL)animated
{
    //需要登陆
    if ([viewController isKindOfClass:[AppUserViewController class]] &&
        ![viewController isMemberOfClass:[LoginViewController class]] &&
        ![self isLogin]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        loginViewController.returnController = viewController;
        //是否显示TabBar
        viewController.hidesBottomBarWhenPushed = [viewController hasTabBar] ? NO : YES;
        [self.navigationController pushViewController:loginViewController animated:YES];
    } else {
        viewController.hidesBottomBarWhenPushed = [viewController hasTabBar] ? NO : YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
