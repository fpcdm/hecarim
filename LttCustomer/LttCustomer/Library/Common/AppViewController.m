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
        if ([navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            navigationBar.barTintColor = [UIColor colorWithHexString:COLOR_INDEX_TITLE_BG];
        }
        navigationBar.tintColor = [UIColor colorWithHexString:COLOR_INDEX_TITLE];
        navigationBar.titleTextAttributes = @{
                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:SIZE_TITLE_TEXT],
                                              NSForegroundColorAttributeName: [UIColor colorWithHexString:COLOR_INDEX_TITLE]
                                              };
    } else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        if ([navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            navigationBar.barTintColor = [UIColor colorWithHexString:COLOR_MAIN_TITLE_BG];
        }
        navigationBar.tintColor = [UIColor colorWithHexString:COLOR_MAIN_TITLE];
        navigationBar.titleTextAttributes = @{
                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:SIZE_TITLE_TEXT],
                                              NSForegroundColorAttributeName: [UIColor colorWithHexString:COLOR_MAIN_TITLE]
                                              };
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

- (void) refreshMenu
{
    LttAppDelegate *appDelegate = (LttAppDelegate *) [UIApplication sharedApplication].delegate;
    
    REFrostedViewController *frostedViewController = (REFrostedViewController *) appDelegate.window.rootViewController;
    MenuViewController *menuViewController = (MenuViewController *) frostedViewController.menuViewController;
    [menuViewController refresh];
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
