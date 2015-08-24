//
//  LoginViewController.m
//  LttAutoFInance
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
#import "PickerUtil.h"

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
    
    //跳转注册
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(actionRegister)];
    
    //调试功能
#ifdef LTT_DEBUG
    if (IS_DEBUG) {
        [self debug];
    }
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //显示消息
    if (self.tokenExpired) {
        [self showError:ERROR_TOKEN_EXPIRED];
    }
}

//修改返回按钮事件
- (BOOL) navigationShouldPopOnBackButton
{
    HomeViewController *viewController = [[HomeViewController alloc] init];
    [self toggleViewController:viewController animated:YES];
    return YES;
}

#pragma mark - Debug
#ifdef LTT_DEBUG
- (void) debug
{
    UIBarButtonItem *debugButton = [AppUIUtil makeBarButtonItem:@"调试"];
    debugButton.target = self;
    debugButton.action = @selector(actionDebug:);
    self.navigationItem.leftBarButtonItem = debugButton;
}

- (void) actionDebug:(UIBarButtonItem *) debugButton
{
    //选择调试服务器
    PickerUtil *pickerUtil = [[PickerUtil alloc] initWithTitle:@"请选择调试服务器" grade:1 origin:debugButton];
    pickerUtil.firstLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){
        NSMutableArray *rows = [[NSMutableArray alloc] init];
        
        //开发
        [rows addObject:[PickerUtilRow rowWithName:@"开发" value:DEBUG_LTT_REST_SERVER_DEV]];
        //测试
        [rows addObject:[PickerUtilRow rowWithName:@"测试" value:DEBUG_LTT_REST_SERVER_TEST]];
        //正式
        [rows addObject:[PickerUtilRow rowWithName:@"正式" value:DEBUG_LTT_REST_SERVER_PROD]];
        
        completionHandler(rows);
    };
    pickerUtil.resultBlock = ^(NSArray *selectedRows){
        PickerUtilRow *row = [selectedRows objectAtIndex:0];
        NSString *server = row.value;
        
        [[RestKitUtil sharedClient] setBaseUrl:[NSURL URLWithString:server]];
    };
    [pickerUtil show];
}
#endif

#pragma mark - Action
- (void)actionRegister
{
    RegisterViewController *viewController = [[RegisterViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionLogin:(UserEntity *)user
{
    user.type = USER_TYPE_MEMBER;
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
            
            HomeViewController *viewController = [[HomeViewController alloc] init];
            [self toggleViewController:viewController animated:YES];
        }];
        
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

@end
