//
//  LoginViewController.m
//  LttMember
//
//  Created by wuyong on 15/6/9.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "UserEntity.h"
#import "HomeViewController.h"
#import "ValidateUtil.h"
#import "UserHandler.h"
#import "AppExtension.h"
#import "RegisterViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "ForgetPasswordViewController.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"
#import "ThirdLoginViewController.h"
#import "WXApi.h"

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
    
    //自动隐藏微信
    BOOL weixinInstalled = [WXApi isWXAppInstalled];
    [loginView assign:@"weixin" value:weixinInstalled ? @1 : @0];
    [loginView display];
    
    //跳转注册
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(actionRegister)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //显示消息
    if (self.tokenExpired) {
        [self showError:[LocaleUtil system:@"ApiError.Nologin"]];
    }
}

//修改返回按钮事件
- (BOOL) navigationShouldPopOnBackButton
{
    HomeViewController *viewController = [[HomeViewController alloc] init];
    [self toggleViewController:viewController animated:YES];
    return YES;
}

#pragma mark - Action
- (void)actionRegister
{
    RegisterViewController *viewController = [[RegisterViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionFindPwd
{
    ForgetPasswordViewController *findPwdController = [[ForgetPasswordViewController alloc] init];
    [self pushViewController:findPwdController animated:YES];
}

- (void)actionLogin:(UserEntity *)user
{
    user.type = USER_TYPE_MEMBER;
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
            [self syncUser:user apiUser:apiUser];
            
            HomeViewController *viewController = [[HomeViewController alloc] init];
            [self toggleViewController:viewController animated:YES];
        }];
        
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void)syncUser:(UserEntity *)user apiUser:(UserEntity *)apiUser
{
    //赋值并释放资源
    user.id = apiUser.id;
    user.name = apiUser.name;
    user.token = apiUser.token;
    user.nickname = apiUser.nickname;
    user.sexAlias = apiUser.sexAlias;
    user.avatar = apiUser.avatar;
    if (apiUser.mobile && [apiUser.mobile length] > 0) {
        user.mobile = apiUser.mobile;
    }
    apiUser = nil;
    
    //清空密码
    user.password = nil;
    
    //保存数据
    [[StorageUtil sharedStorage] setUser:user];
    
    //刷新菜单
    [self refreshMenu];
}

- (void)actionLoginWechat
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [self thirdLogin:snsAccount];
        }
    });
}

- (void)actionLoginQQ
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [self thirdLogin:snsAccount];
        }
    });
}

- (void)actionLoginSina
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [self thirdLogin:snsAccount];
        }
    });
}

- (void)thirdLogin:(UMSocialAccountEntity *)snsAccount
{
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
    //记录用户信息
    UserEntity *user = [[UserEntity alloc] init];
    user.type = USER_TYPE_MEMBER;
    user.deviceType = @"ios";
    user.deviceId = [[StorageUtil sharedStorage] getDeviceId];
    
    //获取平台
    NSNumber *appType = @0;
    if (snsAccount.platformName) {
        if ([snsAccount.platformName isEqualToString:UMShareToWechatSession]) {
            appType = @(THIRD_LOGIN_TYPE_WECHAT);
        } else if ([snsAccount.platformName isEqualToString:UMShareToQQ]) {
            appType = @(THIRD_LOGIN_TYPE_QQ);
        } else if ([snsAccount.platformName isEqualToString:UMShareToSina]) {
            appType = @(THIRD_LOGIN_TYPE_SINA);
        }
    }
    
    //附加参数
    NSDictionary *param = @{
                            @"app_type": appType,
                            @"token":snsAccount.accessToken ? snsAccount.accessToken : @""
                            };
    
    //查询是否已绑定，绑定则登陆成功，未绑定则填写手机号
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler thirdLoginWithUser:user param:param success:^(NSArray *result) {
        //是否绑定成功
        UserEntity *apiUser = result && [result count] > 0 ? [result firstObject] : nil;
        if (apiUser && apiUser.id) {
            [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
                //赋值并释放资源
                [self syncUser:user apiUser:apiUser];
                
                HomeViewController *viewController = [[HomeViewController alloc] init];
                [self toggleViewController:viewController animated:YES];
            }];
        } else {
            [self hideLoading];
            
            ThirdLoginViewController *viewController = [[ThirdLoginViewController alloc] init];
            viewController.thirdUser = user;
            viewController.thirdParam = param;
            [self pushViewController:viewController animated:YES];
        }
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

@end
