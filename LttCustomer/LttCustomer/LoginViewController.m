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
#import "AppStorageUtil.h"

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
    [super viewDidLoad];
    
    self.title = @"登陆";
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    [[StorageUtil sharedStorage] setUser:user];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
