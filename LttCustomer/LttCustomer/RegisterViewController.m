//
//  RegisterViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/7/6.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterMobileView.h"
#import "RegisterExistView.h"
#import "RegisterCodeView.h"
#import "RegisterPasswordView.h"
#import "RegisterSuccessView.h"
#import "ValidateUtil.h"
#import "UIViewController+BackButtonHandler.h"
#import "UserHandler.h"
#import "HelperHandler.h"
#import "HomeViewController.h"
#import "TimerUtil.h"

@interface RegisterViewController () <RegisterMobileViewDelegate, RegisterExistViewDelegate, RegisterCodeViewDelegate, RegisterPasswordViewDelegate, RegisterSuccessViewDelegate>

@end

@implementation RegisterViewController
{
    NSString *mobile;
    NSString *mobileStatus;
    NSString *code;
    NSString *password;
    
    UIButton *sendButton;
    TimerUtil *timerUtil;
}

- (void)loadView
{
    self.view = [self mobileInputView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //自动关闭定时器
    [self clearTimer];
}

#pragma mark - View
- (RegisterMobileView *) mobileInputView
{
    RegisterMobileView *currentView = [[RegisterMobileView alloc] init];
    currentView.delegate = self;
    self.navigationItem.title = @"注册";
    return currentView;
}

- (RegisterExistView *) mobileExistView
{
    RegisterExistView *currentView = [[RegisterExistView alloc] init];
    currentView.delegate = self;
    self.navigationItem.title = @"注册";
    return currentView;
}

- (RegisterCodeView *) mobileCodeView
{
    RegisterCodeView *currentView = [[RegisterCodeView alloc] init];
    currentView.delegate = self;
    self.navigationItem.title = @"注册";
    return currentView;
}

- (RegisterPasswordView *) mobilePasswordView
{
    RegisterPasswordView *currentView = [[RegisterPasswordView alloc] init];
    currentView.delegate = self;
    self.navigationItem.title = @"设置登陆密码";
    return currentView;
}

- (RegisterSuccessView *) mobileSuccessView
{
    RegisterSuccessView *currentView = [[RegisterSuccessView alloc] init];
    currentView.delegate = self;
    self.navigationItem.title = @"注册成功";
    return currentView;
}

//发送短信
- (void) sendSms: (CallbackBlock) success failure: (CallbackBlock) failure
{
    int timeLeft = [self getSmsTimeLeft];
    if (timeLeft == -1) {
        //todo: 发送短信
        NSLog(@"给手机号%@发送短信：%@", mobile, [NSDate date]);
        [[StorageUtil sharedStorage] setSmsTime:[NSDate date]];
        
        success(nil);
    } else {
        ErrorEntity *error = [[ErrorEntity alloc] init];
        error.message = @"发送短信效验码不能太频繁";
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
                button.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG];
            } else {
                [button setTitle:[NSString stringWithFormat:@"%d秒后重发", smsLeft] forState:UIControlStateNormal];
                button.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
            }
        } queue:dispatch_get_main_queue()];
            
        return NO;
    }
    
    //发送短信
    [button setTitle:@"重新获取" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG];
    return YES;
}

#pragma mark - Back
- (BOOL) navigationShouldPopOnBackButton
{
    if ([self.view isMemberOfClass:[RegisterMobileView class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.view isMemberOfClass:[RegisterExistView class]]) {
        [self popView:[self mobileInputView] animated:YES completion:nil];
    } else if ([self.view isMemberOfClass:[RegisterCodeView class]]) {
        [self popView:[self mobileInputView] animated:YES completion:nil];
    } else if ([self.view isMemberOfClass:[RegisterPasswordView class]]) {
        RegisterCodeView *codeView = [self mobileCodeView];
        [self popView:codeView animated:YES completion:^{
            [codeView setData:@"mobile" value:mobile];
            [codeView renderData];
            
            sendButton = codeView.sendButton;
            [self checkButton];
        }];
    } else if ([self.view isMemberOfClass:[RegisterSuccessView class]]) {
        [self popView:[self mobilePasswordView] animated:YES completion:nil];
    }
    return NO;
}

#pragma mark - Action
- (void) actionCheckMobile:(NSString *)inputMobile
{
    //参数检查
    if (![ValidateUtil isRequired:inputMobile]) {
        [self showError:ERROR_MOBILE_REQUIRED];
        return;
    }
    if (![ValidateUtil isMobile:inputMobile]) {
        [self showError:ERROR_MOBILE_FORMAT];
        return;
    }
    
    //登录接口调用
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler checkMobile:inputMobile success:^(NSArray *result){
        ResultEntity *checkResult = [result firstObject];
            
        mobile = inputMobile;
        mobileStatus = checkResult.data;
        NSLog(@"check mobile result: %@", checkResult.data);
        if ([@"registered" isEqualToString:mobileStatus]) {
            RegisterExistView *existView = [self mobileExistView];
            [self pushView:existView animated:YES completion:^{
                [existView setData:@"mobile" value:mobile];
                [existView renderData];
            }];
        } else {
            RegisterCodeView *codeView = [self mobileCodeView];
            [self pushView:codeView animated:YES completion:^{
                [codeView setData:@"mobile" value:mobile];
                [codeView renderData];
                
                //发送短信验证码
                sendButton = codeView.sendButton;
                [self sendSms:^(id object){
                    [self checkButton];
                } failure:^(ErrorEntity *error){
                    [self showError:error.message];
                }];
            }];
        }
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void) actionLogin
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) actionAutoLogin
{
}

- (void) actionSend
{
    //未到发送时间
    int timeLeft = [self getSmsTimeLeft];
    if (timeLeft != -1) {
        return;
    }
    
    //发送短信验证码
    [self sendSms:^(id object){
        [self checkButton];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void) actionVerifyCode:(NSString *)code
{
    [self pushView:[self mobilePasswordView] animated:YES completion:nil];
}

- (void) actionRegister:(NSString *)password
{
    [self pushView:[self mobileSuccessView] animated:YES completion:nil];
}

@end
