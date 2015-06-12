//
//  BaseViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"
#import "LoginViewController.h"
#import "StorageUtil.h"

@interface AppViewController ()

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //是否有返回按钮(子页面生效)
    if (hasBackButton) {
        UIBarButtonItem *backButtonItem = [AppUIUtil makeBarButtonItem:@""];
        self.navigationItem.backBarButtonItem = backButtonItem;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏TabBar
    self.tabBarController.tabBar.hidden = showTabBar ? NO : YES;
    
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

- (BOOL) needLogin {
    return NO;
}

- (BOOL) isLogin {
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    if (user) {
        return YES;
    } else {
        return NO;
    }
}

- (void)pushAppViewController:(AppViewController *)viewController animated:(BOOL)animated {
    BOOL needLogin = [viewController needLogin];
    //不需要登陆或已经登陆
    if (!needLogin || [self isLogin]) {
        [self.navigationController pushViewController:viewController animated:animated];
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:animated];
    }
}

@end
