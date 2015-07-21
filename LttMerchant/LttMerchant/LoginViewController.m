//
//  LoginViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/4/27.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "UserEntity.h"
#import "ValidateUtil.h"
#import "AppExtension.h"
#import "HomeActivity.h"
#import "UserHandler.h"

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
    
    self.navigationItem.title = @"两条腿工作台登陆";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //显示消息
    if (self.tokenExpired) {
        [self showError:ERROR_TOKEN_EXPIRED];
    }
}

#pragma mark - Action
- (void)actionLogin:(UserEntity *)user
{
    user.type = USER_TYPE_MERCHANT;
    user.deviceType = @"ios";
    user.deviceId = [[StorageUtil sharedStorage] getDeviceId];
    
    //参数检查
    if (![ValidateUtil isRequired:user.mobile]) {
        [self showError:ERROR_MOBILE_REQUIRED];
        return;
    }
    if (![ValidateUtil isMobile:user.mobile]) {
        [self showError:ERROR_MOBILE_FORMAT];
        return;
    }
    if (![ValidateUtil isRequired:user.password]) {
        [self showError:ERROR_PASSWORD_REQUIRED];
        return;
    }
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //登录接口调用
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler loginWithUser:user success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
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
            
            HomeActivity *viewController = [[HomeActivity alloc] init];
            [self toggleViewController:viewController animated:YES];
        }];
        
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

@end
