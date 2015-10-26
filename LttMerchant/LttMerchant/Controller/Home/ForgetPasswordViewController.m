//
//  ForgetPasswordViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/10/19.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ForgetPasswordView.h"
#import "ForgetPasswordCodeView.h"
#import "ValidateUtil.h"
#import "HelperHandler.h"
#import "TimerUtil.h"
#import "StorageUtil.h"
#import "ResetPasswordView.h"
#import "ResetPasswordSuccess.h"
#import "UIViewController+BackButtonHandler.h"
#import "LoginActivity.h"
#import "AppExtension.h"

@interface ForgetPasswordViewController ()<ForgetPasswordViewDelegate,ForgetPasswordCodeViewDelegate,ResetPasswordSuccessDelegate,ResetPasswordViewDelegate>

@end


@implementation ForgetPasswordViewController
{
    NSString *mobile;
    NSString *mobileStatus;
    
    UIButton *sendButton;
    TimerUtil *timerUtil;
    NSString *vCode;
}

- (void)loadView
{
    self.view = [self passwordView];
    self.view.backgroundColor = COLOR_MAIN_BG;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //自动关闭定时器
    [self clearTimer];
}

- (ForgetPasswordView *)passwordView
{
    ForgetPasswordView *forgetPasswordView = [[ForgetPasswordView alloc] init];
    forgetPasswordView.delegate = self;
    
    self.navigationItem.title = @"忘记密码";
    return forgetPasswordView;
}

//手机号验证
#pragma mark - Action
//跳转到登录界面
- (void)actionLogin
{
    LoginActivity *loginView = [[LoginActivity alloc] init];
    [self pushViewController:loginView animated:YES];
}

- (void) actionCheckMobile:(NSString *)inputMobile
{
    //参数检查
    if (![ValidateUtil isRequired:inputMobile]) {
        [self showError:ERROR_MOBILE_REQUIRED];
        return;
    }
    //判断是否是手机号
    if (![ValidateUtil isMobile:inputMobile]) {
        [self showError:ERROR_MOBILE_FORMAT];
        return;
    }
    
    //请求中
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //手机号检查接口调用
    HelperHandler * helpHandler = [[HelperHandler alloc] init];
    [helpHandler checkMobile:inputMobile success:^(NSArray *result) {
        //请求成功
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            ResultEntity *checkResult = [result firstObject];
            
            //赋值给mobile
            mobile = inputMobile;
            mobileStatus = checkResult.data;
            NSLog(@"check mobile result: %@",checkResult.data);
            
            //判断手机号检查结果
            if ([@"registered" isEqualToString:mobileStatus]) {
                [self pushView:[self codeView] animated:YES completion:nil];
            } else {
                [self showError:ERROR_MOBILE_NOTFOUND];
                return;
            }
        }];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

//填写短信校验码视图
- (ForgetPasswordCodeView *)codeView
{
    ForgetPasswordCodeView *currentView = [[ForgetPasswordCodeView alloc] init];
    currentView.delegate = self;
    
    self.navigationItem.title = @"填写短信校验码";
    
    //加密手机号
    NSMutableString *strMobile = [[NSMutableString alloc] initWithString:mobile];
    [strMobile replaceCharactersInRange:NSMakeRange(3,5) withString:@"*****"];
    currentView.tipMobile.text = strMobile;
    
    sendButton = currentView.sendButton;
    [self checkSmsButton];

    return currentView;
}



//重置密码界面视图
- (ResetPasswordView *)resetPwdView
{
    ResetPasswordView *resetPasswordView = [[ResetPasswordView alloc] init];
    resetPasswordView.delegate = self;
    
    self.navigationItem.title = @"重置密码";
    self.navigationItem.leftBarButtonItem.action = @selector(actionLogin);
    return resetPasswordView;
}

//重置密码成功界面视图
- (ResetPasswordSuccess *)resetPwdSuccessView
{
    ResetPasswordSuccess *currentView = [[ResetPasswordSuccess alloc] init];
    currentView.delegate = self;
    
    self.navigationItem.title = @"重置密码成功";
    self.navigationItem.leftBarButtonItem.action = @selector(actionLogin);
    return currentView;
}

//返回忘记密码页面视图
- (void)backForgetPasswordView
{
    ForgetPasswordViewController *backView = [[ForgetPasswordViewController alloc] init];
    [self pushViewController:backView animated:YES];
}


#pragma mark - Back
- (BOOL) navigationShouldPopOnBackButton
{
    if ([self.view isMemberOfClass:[ForgetPasswordCodeView class]]) {
        ForgetPasswordView *forgetView = [self passwordView];
        [self popView:forgetView animated:YES completion:^{
            [forgetView setData:@"mobile" value:mobile];
            [forgetView renderData];
        }];
    }else{
        LoginActivity *loginView = [[LoginActivity alloc] init];
        [self pushViewController:loginView animated:YES];
    }
    return NO;
}

//计算短信发送剩余间隔
- (int)getSmsTimeRight
{
    NSDate *lastDate = [[StorageUtil sharedStorage] getSmsTime];
    if (lastDate && lastDate != nil) {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastDate];
        int timeRight = (int) (USER_SMS_INTERVAL - timeInterval);
        if (timeRight >= 1) {
            return timeRight;
        }
    }
    return -1;
    
}

//发送短信
- (void)sendSms:(CallbackBlock) success failure:(CallbackBlock) failure
{
    int timeRight = [self getSmsTimeRight];
    if (timeRight == -1) {
        
        //发送中
        [self showLoading:@"发送中……"];
        
        HelperHandler *helperHandler = [[HelperHandler alloc] init];
        [helperHandler sendMobileCode:mobile success:^(NSArray *result) {
            [self loadingSuccess:@"发送成功" callback:^{
                NSLog(@"给手机号%@发送短信：%@",mobile,[NSDate date]);
                [[StorageUtil sharedStorage] setSmsTime:[NSDate date]];
                
                UIButton *button = sendButton;
                button.enabled = NO;
                [button setTitle:[NSString stringWithFormat:@"%d秒后重发",timeRight] forState:UIControlStateDisabled];
                button.backgroundColor = COLOR_MAIN_WHITE;
                button.layer.borderWidth = 0.0f;
                
                success(nil);
            }];
        } failure:^(ErrorEntity *error) {
            failure(error);
        }];
    } else {
        ErrorEntity *error = [[ErrorEntity alloc] init];
        error.message = [NSString stringWithFormat:@"%d秒后重发",timeRight];
        failure(error);
    }
}

//清空定时器
- (void)clearTimer
{
    if (timerUtil) {
        [timerUtil invalidate];
        timerUtil = nil;
    }
}

//检查发送短信按钮状态
- (BOOL)checkSmsButton
{
    UIButton *button = sendButton;
    if (!button) return NO;
    
    //发送短信间隔时间
    int timeRight = [self getSmsTimeRight];
    if (timeRight != -1) {
        NSLog(@"离下次发送短信，还有%d秒",timeRight);
        
        //初始化定时器
        [self clearTimer];
        timerUtil = [TimerUtil repeatTimer:1.0f block:^{
            int smsRight = [self getSmsTimeRight];
            if (smsRight == -1) {
                [self clearTimer];
                
                [button setTitle:@"发送短信" forState:UIControlStateNormal];
                button.enabled = YES;
                button.backgroundColor = COLOR_MAIN_BG;
                
            } else {
                [button setTitle:[NSString stringWithFormat:@"%d秒后重发",smsRight] forState:UIControlStateDisabled];
                button.backgroundColor = COLOR_MAIN_WHITE;
                button.enabled = NO;
                button.layer.borderWidth = 0.0f;
            }
        } queue:dispatch_get_main_queue()];
        return NO;
    }
    
    //发送短信
    [button setTitle:@"发送短信" forState:UIControlStateNormal];
    button.backgroundColor = COLOR_MAIN_BG;
    button.enabled = YES;
    return YES;
}


//发送短信校验码
- (void)actionSend
{
    //未到发送时间
    int timeRigth = [self getSmsTimeRight];
    if (timeRigth != -1) {
        return;
    }
    
    //发送短信校验码
    [self sendSms:^(id object) {
        [self checkSmsButton];
    } failure:^(ErrorEntity *error) {
        [self checkSmsButton];
        [self showError:error.message];
    }];
}


//校验码验证
- (void)actionVerifyCode:(NSString *)code
{
    //判断是否填写校验码
    if (![ValidateUtil isRequired:code]) {
        [self showError:ERROR_MOBILECODE_REQUIRED];
        return;
    }
    
    //请求中
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //调用忘记密码短信验证接口
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler verifyMobileCode:mobile code:code success:^(NSArray *result) {
        ResultEntity *verifyResult = [result firstObject];
        vCode = verifyResult.data;
        NSLog(@"安全码是：%@",vCode);
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            //加载到重置密码的视图
            [self pushView:[self resetPwdView] animated:YES completion:nil];
            
        }];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
    
}


- (void)actionResetPassword:(NSString *)newPassword reNewPassword:(NSString *)reNewPassword
{
    if (![ValidateUtil isRequired:newPassword]) {
        [self showError:@"请输入新密码"];
        return;
    }
    if (![ValidateUtil isRequired:reNewPassword]) {
        [self showError:@"请输入确认新密码"];
        return;
    }
    if (![ValidateUtil isLengthBetween:newPassword from:6 to:15]) {
        [self showError:@"密码长度为6-15位英文字母，数字组成"];
        return;
    }
    if (![newPassword isEqualToString:reNewPassword]) {
        [self showError:@"两次密码不相等"];
        return;
    }
    
    //请求中
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler resetPassword:mobile vCode:vCode password:newPassword success:^(NSArray *result) {
        NSLog(@"重置密码成功");
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            [self pushView:[self resetPwdSuccessView] animated:YES completion:nil];
        }];
    } failure:^(ErrorEntity *error) {
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
