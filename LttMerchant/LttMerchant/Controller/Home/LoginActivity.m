//
//  LoginActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LoginActivity.h"
#import "UserEntity.h"
#import "ValidateUtil.h"
#import "AppExtension.h"
#import "HomeActivity.h"
#import "UserHandler.h"

@interface LoginActivity ()

@property (nonatomic, strong) UITextField *mobileField;

@property (nonatomic, strong) UITextField *passwordField;

@end

@implementation LoginActivity

- (void)viewDidLoad {
    isMenuEnabled = NO;
    hideBackButton = YES;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //显示消息
    if (self.tokenExpired) {
        [self showError:ERROR_TOKEN_EXPIRED];
    }
}

- (NSString *) templateName {
    return @"login.html";
}

#pragma mark -
- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
}

- (void)onTemplateFailed
{
    
}

- (void)onTemplateCancelled
{
    
}

#pragma mark - Action
- (void)actionLogin:(SamuraiSignal *)signal
{
    //记录用户信息
    UserEntity *user = [[UserEntity alloc] init];
    user.mobile = self.mobileField.text;
    user.password = self.passwordField.text;
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
