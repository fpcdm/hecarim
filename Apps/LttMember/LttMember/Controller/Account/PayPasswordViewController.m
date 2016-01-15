//
//  SetPayPasswordViewController.m
//  LttMember
//
//  Created by 杨海锋 on 15/12/9.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "PayPasswordViewController.h"
#import "SetPayPasswordCodeView.h"
#import "ValidateUtil.h"
#import "HelperHandler.h"
#import "TimerUtil.h"
#import "SetPayPasswordView.h"
#import "MyWalletViewController.h"
#import "UpdatePayPasswordView.h"
#import "UpdatePayPasswordSuccessView.h"
#import "UserHandler.h"
#import "UIView+Loading.h"

@interface PayPasswordViewController ()<SetPayPasswordCodeViewDelegate,SetPayPasswordViewDelegate,UpdatePayPasswordViewDelegate,UpdatePayPasswordSuccessViewDelegate>

@end

@implementation PayPasswordViewController
{
    NSString *vCode;
    NSString *mobile;
    UserEntity *user;
    SetPayPasswordCodeView *codeView;
    TimerUtil *timerUtil;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = COLOR_MAIN_BG;
    [self.view showLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UserHandler *userhandler = [[UserHandler alloc] init];
    [userhandler issetPayPassword:nil success:^(NSArray *result) {
        ResultEntity *resultE = [result firstObject];
        if ([@1 isEqualToNumber:resultE.data]) {
            self.view = [self updatePasswordView];
        } else {
            self.view = [self codeView];
            
            //检查是否可以发送校验码
            [self checkButton];
        }
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

//校验码视图
- (SetPayPasswordCodeView *) codeView
{
    self.navigationItem.title = @"设置支付密码";
    codeView = [[SetPayPasswordCodeView alloc] init];
    codeView.delegate = self;
    
    //加载数据
    user = [[StorageUtil sharedStorage] getUser];
    mobile = user.mobile;
    [codeView setData:@"user" value:user];
    [codeView renderData];
    return codeView;
}

//设置支付密码视图
- (SetPayPasswordView *) setPasswordView
{
    SetPayPasswordView *setPasswordView = [[SetPayPasswordView alloc] init];
    setPasswordView.delegate = self;
    self.navigationItem.title = @"设置支付密码";
    return setPasswordView;
}

//修改支付密码视图
- (UpdatePayPasswordView *) updatePasswordView
{
    UpdatePayPasswordView *updateView = [[UpdatePayPasswordView alloc] init];
    updateView.delegate = self;
    self.navigationItem.title = @"修改支付密码";
    return updateView;
}

//修改支付成功视图
- (UpdatePayPasswordSuccessView *) successView
{
    UpdatePayPasswordSuccessView *currentView = [[UpdatePayPasswordSuccessView alloc] init];
    currentView.delegate = self;
    self.navigationItem.title = @"修改支付密码";
    return currentView;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //自动关闭定时器
    [self clearTimer];
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
    UIButton *button = codeView.sendBtn;
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
                [button setTitle:[NSString stringWithFormat:@"(%d)秒后重发", smsLeft] forState:UIControlStateNormal];
                button.backgroundColor = COLOR_MAIN_BG;
            }
        } queue:dispatch_get_main_queue()];
        
        return NO;
    }
    //发送短信
    [button setTitle:@"发送短信" forState:UIControlStateNormal];
    button.backgroundColor = COLOR_MAIN_WHITE;
    return YES;
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

- (void)actionSendSms
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

- (void)actionVerifyCode:(NSString *)verifyCode
{
    if (![ValidateUtil isRequired:verifyCode]) {
        [self showError:[LocaleUtil error:@"MobileCode.Required"]];
        return;
    }
    
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
    //调用验证接口
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler verifyMobileCode:mobile code:verifyCode success:^(NSArray *result) {
        [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
            ResultEntity *resultEntity = [result firstObject];
            vCode = resultEntity.data;
            NSLog(@"安全码是：%@",vCode);
            //加载到设置支付密码视图
            [self pushView:[self setPasswordView] animated:YES completion:nil];
        }];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)actionSetPayPassword:(NSString *)password rePassword:(NSString *)rePassword
{
    if (![ValidateUtil isRequired:password]) {
        [self showError:[LocaleUtil error:@"PayPassword.Required"]];
        return;
    }
    if (![ValidateUtil isPositiveNumber:password]) {
        [self showError:[LocaleUtil error:@"PayPassword.Format"]];
        return;
    }
    if (![ValidateUtil isLength:password length:6]) {
        [self showError:[LocaleUtil error:@"PayPassword.Length"]];
        return;
    }
    if (![ValidateUtil isRequired:rePassword]) {
        [self showError:[LocaleUtil error:@"RePayPassword.Required"]];
        return;
    }
    if (![password isEqualToString:rePassword]) {
        [self showError:[LocaleUtil error:@"Password.Equal"]];
        return;
    }
    
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
    //调用接口
    UserHandler *userhandler = [[UserHandler alloc] init];
    [userhandler setPayPassword:password success:^(NSArray *result) {
        [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
            //来自充值页面
            if (self.callbackBlock) {
                self.callbackBlock(@1);
            //来自账户页面
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)actionNext:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    if (![ValidateUtil isRequired:oldPassword]) {
        [self showError:[LocaleUtil error:@"OldPayPassword.Required"]];
        return;
    }
    if (![ValidateUtil isRequired:newPassword]) {
        [self showError:[LocaleUtil error:@"PayPassword.Required"]];
        return;
    }
    if (![ValidateUtil isLength:newPassword length:6]) {
        [self showError:[LocaleUtil error:@"PayPassword.Length"]];
        return;
    }
    if (![ValidateUtil isPositiveNumber:newPassword]) {
        [self showError:[LocaleUtil error:@"PayPassword.Format"]];
        return;
    }
    if ([oldPassword isEqualToString:newPassword]) {
        [self showError:[LocaleUtil error:@"OldAndNewPassword.Equal"]];
        return;
    }
    
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler updatePayPassword:oldPassword newPassword:newPassword success:^(NSArray *result) {
        [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
            [self pushView:[self successView] animated:YES completion:nil];
        }];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)actionGoSafe
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
