//
//  ThirdLoginViewController.m
//  LttMember
//
//  Created by wuyong on 15/6/9.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ThirdLoginViewController.h"
#import "UserEntity.h"
#import "HomeViewController.h"
#import "UserHandler.h"
#import "AppExtension.h"
#import "ThirdLoginView.h"
#import "HelperHandler.h"

@interface ThirdLoginViewController () <ThirdLoginViewDelegate>

@end

@implementation ThirdLoginViewController
{
    ThirdLoginView *thirdView;
    
    NSString *mobile;
    UIButton *sendButton;
    TimerUtil *timerUtil;
}

@synthesize thirdUser;
@synthesize thirdParam;

- (void)loadView {
    thirdView = [[ThirdLoginView alloc] init];
    thirdView.delegate = self;
    self.view = thirdView;
}

- (void)viewDidLoad {
    hideBackButton = NO;
    [super viewDidLoad];
    
    self.navigationItem.title = @"验证手机";
    
    sendButton = thirdView.sendButton;
    [self checkButton];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //自动关闭定时器
    [self clearTimer];
}

//发送短信
- (void) sendSms: (CallbackBlock) success failure: (CallbackBlock) failure
{
    int timeLeft = [self getSmsTimeLeft];
    if (timeLeft == -1) {
        HelperHandler *helperHandler = [[HelperHandler alloc] init];
        [helperHandler sendMobileCode:mobile success:^(NSArray *result){
            NSLog(@"给手机号%@发送短信：%@", mobile, [NSDate date]);
            [[StorageUtil sharedStorage] setSmsTime:[NSDate date]];
            success(nil);
        } failure:^(ErrorEntity *error){
            failure(error);
        }];
    } else {
        ErrorEntity *error = [[ErrorEntity alloc] init];
        error.message = [NSString stringWithFormat:@"%d秒后才能再次发送", timeLeft];
        failure(error);
    }
}

//清空定时器
- (void) clearTimer
{
    if (timerUtil) {
        [timerUtil invalidate];
        timerUtil = nil;
    }
}

//计算短信发送剩余间隔
- (int) getSmsTimeLeft
{
    NSDate *lastDate = [[StorageUtil sharedStorage] getSmsTime];
    if (lastDate && lastDate != nil) {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastDate];
        int timeLeft = (int) (USER_SMS_INTERVAL - timeInterval);
        if (timeLeft >= 1) {
            return timeLeft;
        }
    }
    
    return -1;
}

//检查短信发送状态（自动发送短信）
- (BOOL) checkButton
{
    UIButton *button = sendButton;
    if (!button) return NO;
    
    //发送短信间隔
    int timeLeft = [self getSmsTimeLeft];
    if (timeLeft != -1) {
        NSLog(@"不能发送短信，还差%d秒", timeLeft);
        
        //初始化定时器
        [self clearTimer];
        timerUtil = [TimerUtil repeatTimer:1.0f block:^{
            int smsLeft = [self getSmsTimeLeft];
            if (smsLeft == -1) {
                [self clearTimer];
                
                [button setTitle:@"重新获取" forState:UIControlStateNormal];
                button.backgroundColor = COLOR_MAIN_WHITE;
            } else {
                [button setTitle:[NSString stringWithFormat:@"%d秒后重发", smsLeft] forState:UIControlStateNormal];
                button.backgroundColor = COLOR_MAIN_BG;
            }
        } queue:dispatch_get_main_queue()];
        
        return NO;
    }
    
    //发送短信
    [button setTitle:@"重新获取" forState:UIControlStateNormal];
    button.backgroundColor = COLOR_MAIN_WHITE;
    return YES;
}

#pragma mark - Action
- (void)actionSendCode:(NSString *)inputMobile
{
    //参数检查
    if (![ValidateUtil isRequired:inputMobile]) {
        [self showError:[LocaleUtil error:@"Mobile.Required"]];
        return;
    }
    if (![ValidateUtil isMobile:inputMobile]) {
        [self showError:[LocaleUtil error:@"Mobile.Format"]];
        return;
    }
    
    mobile = inputMobile;
    
    //未到发送时间
    int timeLeft = [self getSmsTimeLeft];
    if (timeLeft != -1) {
        return;
    }
    
    //发送短信验证码
    [self sendSms:^(id object){
        [self checkButton];
    } failure:^(ErrorEntity *error){
        [self checkButton];
        [self showError:error.message];
    }];
}

- (void)actionVerifyCode:(NSString *)inputMobile code:(NSString *)code
{
    //参数检查
    if (![ValidateUtil isRequired:inputMobile]) {
        [self showError:[LocaleUtil error:@"Mobile.Required"]];
        return;
    }
    if (![ValidateUtil isMobile:inputMobile]) {
        [self showError:[LocaleUtil error:@"Mobile.Format"]];
        return;
    }
    if (![ValidateUtil isRequired:code]) {
        [self showError:[LocaleUtil error:@"MobileCode.Required"]];
        return;
    }
    
    mobile = inputMobile;
    
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler verifyMobileCode:mobile code:code success:^(NSArray *result){
        //整理数据
        thirdUser.mobile = mobile;
        
        //自动注册第三方用户
        UserHandler *userHandler = [[UserHandler alloc] init];
        [userHandler thirdRegisterWithUser:thirdUser param:thirdParam success:^(NSArray *result) {
            [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
                //赋值并释放资源
                UserEntity *apiUser = [result firstObject];
                [self syncUser:thirdUser apiUser:apiUser];
                
                HomeViewController *viewController = [[HomeViewController alloc] init];
                [self toggleViewController:viewController animated:YES];
            }];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
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

@end
