//
//  AppActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppActivity.h"
#import "LttNavigationController.h"
#import "LttAppDelegate.h"
#import "AppExtension.h"
#import "REFrostedViewController.h"
#import "MenuViewController.h"
#import "NotificationUtil.h"
#import "CaseListActivity.h"
#import "CaseDetailActivity.h"
#import "AppView.h"

@interface AppActivity ()

@end

@implementation AppActivity

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
    
    //加载模板
    NSString *viewPath = [NSString stringWithFormat:@"/www/html/%@", [self templateName]];
    [self loadTemplate:viewPath];
}

- (void) reloadTemplate
{
    //取消旧模板
    [self unloadTemplate];
    
    //加载新模板
    NSString *viewPath = [NSString stringWithFormat:@"/www/html/%@", [self templateName]];
    [self loadTemplate:viewPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    [self unloadTemplate];
}

- (NSString *)templateName
{
    return nil;
}

- (void)viewDidLayoutSubviews
{
    //自动重新布局父视图，解决最后的单元格显示不完全问题
    [self relayout];
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
            navigationBar.barTintColor = COLOR_MAIN_BLUE;
        }
        navigationBar.tintColor = COLOR_MAIN_WHITE;
        navigationBar.titleTextAttributes = @{
                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                              NSForegroundColorAttributeName: COLOR_MAIN_WHITE
                                              };
    } else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        if ([navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            navigationBar.barTintColor = COLOR_MAIN_WHITE;
        }
        navigationBar.tintColor = COLOR_MAIN_BLACK;
        navigationBar.titleTextAttributes = @{
                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                              NSForegroundColorAttributeName: COLOR_MAIN_BLACK
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

- (void) pushViewController:(UIViewController *)viewController animated: (BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) toggleViewController: (UIViewController *)viewController animated: (BOOL)animated
{
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
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
        if ([@"CASE_CREATED" isEqualToString:type]) {
            CaseListActivity *viewController = [[CaseListActivity alloc] init];
            [self toggleViewController:viewController animated:YES];
        //已支付，已完成
        } else if ([@"CASE_PAYED" isEqualToString:type] || [@"CASE_SUCCESS" isEqualToString:type]) {
            //跳转详情页面
            if (data) {
                NSNumber *caseId = [NSNumber numberWithInteger:[data integerValue]];
                
                CaseDetailActivity *viewController = [[CaseDetailActivity alloc] init];
                viewController.caseId = caseId;
                [self toggleViewController:viewController animated:YES];
            }
        }
        
        //隐藏弹出框
        [self hideDialog];
    }];
}

@end
