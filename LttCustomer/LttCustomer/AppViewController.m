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
#import "LttNavigationController.h"
#import "LttAppDelegate.h"
#import "AppLoadingView.h"

@interface AppViewController ()

@end

@implementation AppViewController

- (void)loadView
{
    //显示加载视图
    if (showLoadingView) {
        AppLoadingView *loadingView = [[AppLoadingView alloc] init];
        self.view = loadingView;
    //默认视图
    } else {
        [super loadView];
    }
}

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
    
    //@todo: 右侧首页菜单
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //是否有左侧菜单
    if (isMenuEnabled) {
        //启用手势
        [(LttNavigationController *) self.navigationController menuEnable:YES];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:(LttNavigationController *)self.navigationController
                                                                                action:@selector(showMenu)];
    } else {
        //禁用手势
        [(LttNavigationController *) self.navigationController menuEnable:NO];
    }
    
    //状态栏颜色
    if (isIndexNavBar) {
        //红色背景
        //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        //白色背景
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    //导航栏高亮，返回时保留
    if (isIndexNavBar) {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.barTintColor = [UIColor colorWithHexString:COLOR_INDEX_TITLE_BG];
        navigationBar.tintColor = [UIColor colorWithHexString:COLOR_INDEX_TITLE];
        navigationBar.titleTextAttributes = @{
                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:SIZE_TITLE_TEXT],
                                              NSForegroundColorAttributeName: [UIColor colorWithHexString:COLOR_INDEX_TITLE]
                                              };
    } else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.barTintColor = [UIColor colorWithHexString:COLOR_MAIN_TITLE_BG];
        navigationBar.tintColor = [UIColor colorWithHexString:COLOR_MAIN_TITLE];
        navigationBar.titleTextAttributes = @{
                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:SIZE_TITLE_TEXT],
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

- (void) pushViewController:(AppViewController *)viewController animated: (BOOL)animated
{
    //需要登陆
    if ([viewController isKindOfClass:[AppUserViewController class]] &&
        ![viewController isMemberOfClass:[LoginViewController class]] &&
        ![self isLogin]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    } else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void) refreshMenu
{
    LttAppDelegate *appDelegate = (LttAppDelegate *) [UIApplication sharedApplication].delegate;
    
    REFrostedViewController *frostedViewController = (REFrostedViewController *) appDelegate.window.rootViewController;
    MenuViewController *menuViewController = (MenuViewController *) frostedViewController.menuViewController;
    [menuViewController refresh];
}

@end
