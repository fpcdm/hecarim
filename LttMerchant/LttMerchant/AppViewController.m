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

#pragma mark - Public Methods
- (BOOL) checkLogin
{
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

- (void) refreshMenu
{
    REFrostedViewController *frostedViewController = (REFrostedViewController *) self.view.window.rootViewController;
    MenuViewController *menuViewController = (MenuViewController *) frostedViewController.menuViewController;
    [menuViewController refresh];
}

@end
