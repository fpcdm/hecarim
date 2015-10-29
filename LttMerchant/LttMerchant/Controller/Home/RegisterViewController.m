//
//  RegisterViewController.m
//  LttMember
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
#import "TimerUtil.h"
#import "LoginActivity.h"
@interface RegisterViewController () <RegisterMobileViewDelegate, RegisterExistViewDelegate, RegisterCodeViewDelegate, RegisterPasswordViewDelegate, RegisterSuccessViewDelegate>

@end

@implementation RegisterViewController
{
    NSString *mobile;
    NSString *mobileStatus;
    NSString *password;
    
    UIButton *sendButton;
    TimerUtil *timerUtil;
    NSString *vCode;
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
    self.navigationItem.title = @"商户注册";
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
    self.navigationItem.title = @"设置商户信息";
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
//        RegisterCodeView *codeView = [self mobileCodeView];
//        [self popView:codeView animated:YES completion:^{
//            [codeView setData:@"mobile" value:mobile];
//            [codeView renderData];
//            
//            sendButton = codeView.sendButton;
//            [self checkButton];
//        }];
        [self popView:[self mobileInputView] animated:YES completion:nil];
    } else if ([self.view isMemberOfClass:[RegisterSuccessView class]]) {
//        [self popView:[self mobilePasswordView] animated:YES completion:nil];
        [self actionLogin];
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
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //检查手机号是否已经注册
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler checkMobile:inputMobile success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
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
                        [self checkButton];
                        [self showError:error.message];
                    }];
                }];
            }
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void) actionLogin
{
    [self.navigationController popViewControllerAnimated:YES];
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
        [self checkButton];
        [self showError:error.message];
    }];
}

- (void) actionVerifyCode:(NSString *)code
{
    if (![ValidateUtil isRequired:code]) {
        [self showError:ERROR_MOBILECODE_REQUIRED];
        return;
    }
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler verifyMobileCode:mobile code:code success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            ResultEntity *verifyResult = [result firstObject];
            vCode = verifyResult.data;
            NSLog(@"安全码是：%@",vCode);
            RegisterPasswordView *passwordView = [self mobilePasswordView];
            [self pushView:passwordView animated:YES completion:^{
                [passwordView setData:@"mobileStatus" value:mobileStatus];
                [passwordView renderData];
            }];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}


//商户注册验证
- (void)actionRegister:(UserEntity *)user
{
    NSString *merchantName = [user.name trim];
    if (![ValidateUtil isRequired:merchantName]) {
        [self showError:ERROR_MERCHANT_REQUIRED];
        return;
    }
    
    NSString *contactName = [user.nickname trim];
    if (![ValidateUtil isRequired:contactName]) {
        [self showError:ERROR_CONTACT_REQUIRED];
        return;
    }
    if ([mobileStatus isEqualToString:@"unregistered"]) {
        NSString *inputPassword = [user.password trim];
        if (![ValidateUtil isRequired:inputPassword]) {
            [self showError:ERROR_PASSWORD_REQUIRED];
            return;
        }
        
        if (![ValidateUtil isLengthBetween:inputPassword from:6 to:20]) {
            [self showError:ERROR_PASSWORD_LENGTH];
            return;
        }
    }
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    user.mobile = mobile;
    
    //注册用户
    
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler registerWithUser:user vCode:vCode success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            
            [self pushView:[self mobileSuccessView] animated:YES completion:nil];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}


//切换视图,类似push效果
- (void) pushView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion
{
    if (animated) {
        [UIView animateWithDuration:0.1f
                         animations:^{
                             self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             self.view = view;
                             self.view.backgroundColor = COLOR_MAIN_BG;
                             self.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                             [UIView animateWithDuration:0.2f
                                              animations:^{
                                                  self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  if (completion) completion();
                                              }
                              ];
                         }
         ];
    } else {
        self.view = view;
        self.view.backgroundColor = COLOR_MAIN_BG;
        if (completion) completion();
    }
}

//切换视图,类似pop效果
- (void) popView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion
{
    if (animated) {
        [UIView animateWithDuration:0.1f
                         animations:^{
                             self.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             self.view = view;
                             self.view.backgroundColor = COLOR_MAIN_BG;
                             self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                             [UIView animateWithDuration:0.2f
                                              animations:^{
                                                  self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  if (completion) completion();
                                              }
                              ];
                         }
         ];
    } else {
        self.view = view;
        self.view.backgroundColor = COLOR_MAIN_BG;
        if (completion) completion();
    }
}


@end
