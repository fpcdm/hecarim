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
    isMenuEnabled = NO;
    hideBackButton = NO;
    [super viewDidLoad];
    
    self.navigationItem.title = @"登陆";
    
    //点击左侧返回首页
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(actionHome)];
}

#pragma mark - Action
- (void)actionHome
{
    HomeViewController *viewController = [[HomeViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

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
    
    HomeViewController *viewController = [[HomeViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

@end
