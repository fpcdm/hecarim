//
//  LoginViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/4/27.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "UserHandler.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize mobileTextField;

@synthesize passwordTextField;

- (void)viewDidLoad {
    //禁用菜单
    isMenuDisabled = YES;
    
    [super viewDidLoad];
    
    self.title = @"登陆";
}

#pragma mark - Action
- (IBAction)loginSubmitAction:(id)sender {
    //记录用户信息
    UserEntity *user = [[UserEntity alloc] init];
    user.mobile = mobileTextField.text;
    user.password = passwordTextField.text;
    user.type = USER_TYPE_MERCHANT;
    
    //参数检查
    if (![ValidateUtil isRequired:user.mobile]) {
        [self showError:LocalString(@"ERROR_MOBILE_REQUIRED")];
        return;
    }
    if (![ValidateUtil isMobile:user.mobile]) {
        [self showError:LocalString(@"ERROR_MOBILE_FORMAT")];
        return;
    }
    if (![ValidateUtil isRequired:user.password]) {
        [self showError:LocalString(@"ERROR_PASSWORD_REQUIRED")];
        return;
    }
    
    [self showLoading:LocalString(@"TIP_LOGIN_LOADING")];
    
    //登录接口调用
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler loginWithUser:user success:^(NSArray *result){
        [self loadingSuccess:LocalString(@"TIP_LOGIN_SUCCESS")];
        
        //赋值并释放资源
        UserEntity *apiUser = [result firstObject];
        user.id = apiUser.id;
        user.name = apiUser.name;
        user.token = apiUser.token;
        apiUser = nil;
        
        //显示效果
        [self performSelector:@selector(loginSuccess:) withObject:user afterDelay:1];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        
        [self showError:error.message];
    }];
}

- (void) loginSuccess: (UserEntity *) user
{
    //清空密码
    user.password = nil;
    
    //保存数据
    [[StorageUtil sharedStorage] setUser:user];
    
    //刷新菜单
    [self refreshMenu];
    
    //跳转首页
    UIViewController *viewController = [[HomeViewController alloc] init];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
}

@end
