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
    
    //全局背景色
    self.view.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    
    //导航栏颜色
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:COLOR_MAIN_TITLE_BG];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[UIFont systemFontOfSize:SIZE_TITLE_TEXT],
                                                                    NSForegroundColorAttributeName: [UIColor colorWithHexString:COLOR_MAIN_TITLE]
                                                                    };
    //隐藏TabBar
    self.tabBarController.tabBar.hidden = hideTabBar ? YES : NO;
    
    //左侧返回栏
    if (showBackBar) {
        UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonItem:@" <"];
        [barButtonItem setTarget:self];
        [barButtonItem setAction:@selector(navigationBack)];
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
}

- (void)navigationBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) checkLogin {
    //已登录
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    if (user) {
        return YES;
    }
    
    //跳转登陆
    LoginViewController *viewController = [[LoginViewController alloc] init];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
    return NO;
}

@end
