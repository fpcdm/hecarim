//
//  LoginViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/9.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "UserEntity.h"
#import "HomeViewController.h"

@interface LoginViewController () <LoginViewDelegate>

@end

@implementation LoginViewController
{
    LoginView *loginView;
}

- (void)loadView {
    loginView = [[LoginView alloc] init];
    loginView.delegate = self;
    self.view = loginView;
}

- (void)viewDidLoad {
    isMenuEnabled = YES;
    hideBackButton = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"登陆";
}

#pragma mark - Action
- (void)actionLogin
{
    //模拟登陆
    UserEntity *user = [[UserEntity alloc] init];
    user.id = @1;
    user.name = @"大勇";
    user.mobile = @"18875001455";
    user.token = @"token";
    user.type = USER_TYPE_MEMBER;
    user.nickname = @"勇哥";
    user.sex = nil;
    user.avatar = nil;
    
    [[StorageUtil sharedStorage] setUser:user];
    
    //刷新菜单
    [self refreshMenu];
    
    //是否有返回控制器
    if (self.returnController != nil) {
        [self.navigationController pushViewController:self.returnController animated:YES];
    } else {
        HomeViewController *viewController = [[HomeViewController alloc] init];
        [self pushViewController:viewController animated:YES];
    }
}

@end
