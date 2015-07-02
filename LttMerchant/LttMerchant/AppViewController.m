//
//  BaseViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"
#import "LttNavigationController.h"
#import "LoginViewController.h"
#import "REFrostedViewController.h"
#import "MenuViewController.h"
#import "NotificationUtil.h"
#import "HomeViewController.h"
#import "ApplyDetailViewController.h"
#import "OrderDetailViewController.h"

@interface AppViewController ()

@end

@implementation AppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加背景色，解决闪烁
    self.view.backgroundColor = [UIColor whiteColor];
    
    //禁用菜单
    if (isMenuDisabled) {
        //禁用手势
        [(LttNavigationController *) self.navigationController menuEnable:NO];
        
        self.navigationItem.leftBarButtonItem = nil;
    //左侧为返回
    } else if (isMenuBack) {
        //禁用手势
        [(LttNavigationController *) self.navigationController menuEnable:NO];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    //显示菜单
    } else {
        //启用手势
        [(LttNavigationController *) self.navigationController menuEnable:YES];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:(LttNavigationController *)self.navigationController
                                                                                action:@selector(showMenu)];
    }
}

- (void) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Public Methods
- (BOOL) isLogin
{
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    if (user) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) checkLogin
{
    //已登录
    BOOL isLogin = [self isLogin];
    if (isLogin) return YES;
    
    //跳转登陆
    LoginViewController *viewController = [[LoginViewController alloc] init];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
    return NO;
}

- (void) refreshMenu
{
    REFrostedViewController *frostedViewController = (REFrostedViewController *) self.view.window.rootViewController;
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
        if (aps) {
            NSString *message = [aps objectForKey:@"alert"];
            [self showNotification:message callback:^{
                if (action) {
                    NSString *type = [action objectForKey:@"type"];
                    NSString *data = [action objectForKey:@"data"];
                    
                    //根据类型处理事件
                    if (type) {
                        [self handleRemoteNotification:type data:data];
                    }
                }
                
                //取消消息
                [NotificationUtil cancelRemoteNotifications];
                
                //隐藏弹出框
                [self hideDialog];
            }];
        }
    }
}

//根据类型处理远程通知
- (void) handleRemoteNotification:(NSString *) type data: (NSString *) data
{
    //新增需求
    if ([@"CASE_CREATED" isEqualToString:type]) {
        HomeViewController *viewController = [[HomeViewController alloc] init];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
    //已支付，已完成
    } else if ([@"CASE_PAYED" isEqualToString:type] || [@"CASE_SUCCESS" isEqualToString:type]) {
        //跳转详情页面
        if (data) {
            OrderDetailViewController *viewController = [[OrderDetailViewController alloc] init];
            viewController.orderNo = data;
            [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
        }
    }
}

@end
