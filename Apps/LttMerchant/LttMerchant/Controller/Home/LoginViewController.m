//
//  LoginViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/7/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LoginViewController.h"
#import "UserEntity.h"
#import "ValidateUtil.h"
#import "AppExtension.h"
#import "HomeViewController.h"
#import "UserHandler.h"
#import "AppUIUtil.h"
#import "ForgetPasswordViewController.h"
#import "RegisterViewController.h"
#import "LoginView.h"

@interface LoginViewController ()<LoginViewDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    isMenuEnabled = NO;
    hideBackButton = YES;
    [super viewDidLoad];
    
    LoginView *loginView = [[LoginView alloc] init];
    loginView.delegate = self;
    self.view = loginView;
    
    self.navigationItem.title = @"两条腿工作台登陆";
    
    self.view.backgroundColor = COLOR_MAIN_BG;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //显示消息
    if (self.tokenExpired) {
        [self showError:[LocaleUtil system:@"ApiError.Nologin"]];
    }
}

#pragma mark - Action
- (void)actionLogin:(UserEntity *)user
{
    //记录用户信息
    user.type = USER_TYPE_MERCHANT;
    user.deviceType = @"ios";
    user.deviceId = [[StorageUtil sharedStorage] getDeviceId];
    
    //参数检查
    if (![ValidateUtil isRequired:user.mobile]) {
        [self showError:[LocaleUtil error:@"Mobile.Required"]];
        return;
    }
    if (![ValidateUtil isMobile:user.mobile]) {
        [self showError:[LocaleUtil error:@"Mobile.Format"]];
        return;
    }
    if (![ValidateUtil isRequired:user.password]) {
        [self showError:[LocaleUtil error:@"Password.Required"]];
        return;
    }
    
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
    //登录接口调用
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler loginWithUser:user success:^(NSArray *result){
        [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
            //赋值并释放资源
            UserEntity *apiUser = [result firstObject];
            user.id = apiUser.id;
            user.name = apiUser.name;
            user.token = apiUser.token;
            user.nickname = apiUser.nickname;
            user.sexAlias = apiUser.sexAlias;
            user.avatar = apiUser.avatar;
            apiUser = nil;
            
            //清空密码
            user.password = nil;
            
            //保存数据
            [[StorageUtil sharedStorage] setUser:user];
            
            //刷新菜单
            [self refreshMenu];
            
            HomeViewController *viewController = [[HomeViewController alloc] init];
            [self toggleViewController:viewController animated:YES];
        }];
        
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

//找回密码
- (void)actionForgetPassword
{
    ForgetPasswordViewController *viewController = [[ForgetPasswordViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

//商户注册
- (void)actionRegister
{
    RegisterViewController *registerController = [[RegisterViewController alloc] init];
    [self pushViewController:registerController animated:YES];
}

@end
