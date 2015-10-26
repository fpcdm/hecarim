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
#import "AppUIUtil.h"
#import "PickerUtil.h"
#import "ForgetPasswordViewController.h"

@interface LoginActivity ()

@property (nonatomic, strong) UITextField *mobileField;

@property (nonatomic, strong) UITextField *passwordField;

@end

@implementation LoginActivity

- (void)viewDidLoad {
    isMenuEnabled = NO;
    hideBackButton = YES;
    [super viewDidLoad];
    
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
        [[StorageUtil sharedStorage] setData:DEBUG_LTT_REST_SERVER_KEY object:server];
    };
    [pickerUtil show];
}
#endif

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

//找回密码
-(void)actionForgetPassword{
    ForgetPasswordViewController *viewController = [[ForgetPasswordViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

@end
