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
#import "UserHandler.h"
#import "UIViewController+BackButtonHandler.h"
#import "UserHandler.h"
#import "HomeViewController.h"

@interface RegisterViewController () <RegisterMobileViewDelegate, RegisterExistViewDelegate, RegisterCodeViewDelegate, RegisterPasswordViewDelegate, RegisterSuccessViewDelegate>

@end

@implementation RegisterViewController
{
    NSString *mobile;
    NSString *mobileStatus;
    NSString *code;
    NSString *password;
}

- (void)loadView
{
    self.view = [self mobileInputView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
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
        [self popView:[self mobileCodeView] animated:YES completion:nil];
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

- (void) checkButton:(UIButton *)button
{
    
}

- (void) actionSend:(UIButton *)sender
{
    
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
