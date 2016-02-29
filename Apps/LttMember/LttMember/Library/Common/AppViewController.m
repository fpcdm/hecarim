//
//  BaseViewController.m
//  LttMember
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"
#import "LoginViewController.h"
#import "AppExtension.h"
#import "AppUserViewController.h"
#import "LttAppDelegate.h"
#import "CaseViewController.h"
#import "CaseListViewController.h"
#import "AppView.h"

@interface AppViewController ()

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //子页面导航返回按钮
    NSString *backButtonTitle = IS_IOS7_PLUS ? @"" : @"返回";
    UIBarButtonItem *backButtonItem = [AppUIUtil makeBarButtonItem:backButtonTitle];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    //当前页面是否隐藏返回按钮
    if (hideBackButton) {
        self.navigationItem.hidesBackButton = YES;
    } else {
        self.navigationItem.hidesBackButton = NO;
    }
    
    //自动隐藏tabBar
    if (showTabBar) {
        self.tabBarController.tabBar.hidden = NO;
    } else {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    //是否隐藏导航栏
    if (hideNavigationBar) {
        self.navigationController.navigationBar.hidden = YES;
    } else {
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //状态栏颜色
    if (isIndexStatusBar) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    //导航栏高亮，返回时保留
    if (isIndexNavBar) {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        if ([navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            navigationBar.barTintColor = COLOR_MAIN_WHITE;
        }
        navigationBar.tintColor = COLOR_MAIN_HIGHLIGHT;
        navigationBar.titleTextAttributes = @{
                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                              NSForegroundColorAttributeName: COLOR_MAIN_HIGHLIGHT
                                              };
    } else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        if ([navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            navigationBar.barTintColor = [UIColor colorWithHexString:@"F8F8F8"];
        }
        navigationBar.tintColor = COLOR_MAIN_BLACK;
        navigationBar.titleTextAttributes = @{
                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                              NSForegroundColorAttributeName: COLOR_MAIN_BLACK
                                              };
    }
    
    //自动隐藏tabBar
    if (showTabBar) {
        self.tabBarController.tabBar.hidden = NO;
    } else {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    //是否隐藏导航栏
    if (hideNavigationBar) {
        self.navigationController.navigationBar.hidden = YES;
    } else {
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //检查远程通知
    if (!hideRemoteNotification) {
        [self checkRemoteNotification];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //显示导航栏
    self.navigationController.navigationBar.hidden = NO;
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    
    //隐藏远程通知
    if (!hideRemoteNotification) {
        [self hideDialog];
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

- (void) toggleViewController: (AppViewController *)viewController animated: (BOOL)animated
{
    //需要登陆
    if ([viewController isKindOfClass:[AppUserViewController class]] &&
        ![viewController isMemberOfClass:[LoginViewController class]] &&
        ![self isLogin]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:loginViewController] animated:YES];
    } else {
        [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
    }
}

- (void)replaceViewController:(AppViewController *)viewController animate:(BOOL)animated
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    //替换最后一个控制器
    if ([viewControllers count] > 0) {
        [viewControllers removeLastObject];
    }
    
    //需要登陆
    if ([viewController isKindOfClass:[AppUserViewController class]] &&
        ![viewController isMemberOfClass:[LoginViewController class]] &&
        ![self isLogin]) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [viewControllers addObject:loginViewController];
    } else {
        [viewControllers addObject:viewController];
    }
    
    [self.navigationController setViewControllers:viewControllers animated:animated];
}

- (void) refreshMenu
{
    //todo
}

- (void) checkRemoteNotification
{
    //未登录不检查
    if (![self isLogin]) return;
    
    //已登录
    NSDictionary *remoteNotification = [[StorageUtil sharedStorage] getRemoteNotification];
    if (remoteNotification) {
        NSDictionary *aps = [remoteNotification objectForKey:@"aps"];
        NSDictionary *action = [remoteNotification objectForKey:@"action"];
        
        //显示消息
        if (aps && action) {
            NSString *message = [aps objectForKey:@"alert"];
            NSString *type = [action objectForKey:@"type"];
            NSString *data = [action objectForKey:@"data"];
            
            //根据类型处理远程通知
            if (message && type) {
                [self handleRemoteNotification:message type:type data:data];
            }
        }
    }
}

//处理远程通知钩子（默认顶部弹出框）
- (void) handleRemoteNotification:(NSString *)message type:(NSString *)type data:(NSString *)data
{
    [self showNotification:message callback:^{
        //取消消息
        [NotificationUtil cancelRemoteNotifications];
        //清空服务器数量
        LttAppDelegate *appDelegate = (LttAppDelegate *) [UIApplication sharedApplication].delegate;
        [appDelegate clearNotifications];
        
        //根据需求类型处理
        if ([@"CASE_LOCKED" isEqualToString:type] ||
            [@"CASE_CONFIRMED" isEqualToString:type] ||
            [@"CASE_WAIT_PAY" isEqualToString:type]) {
            //跳转详情页面
            if (data) {
                NSNumber *caseId = [NSNumber numberWithInteger:[data integerValue]];
                
                CaseViewController *viewController = [[CaseViewController alloc] init];
                viewController.caseId = caseId;
                [self toggleViewController:viewController animated:YES];
            }
        } else if ([@"CASE_MERCHANT_CANCEL" isEqualToString:type]) {
            //跳转服务单
            CaseListViewController *viewController = [[CaseListViewController alloc] init];
            [self toggleViewController:viewController animated:YES];
        }
        
        //隐藏弹出框
        [self hideDialog];
    }];
}

@end
