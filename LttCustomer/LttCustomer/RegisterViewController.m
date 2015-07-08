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

@interface RegisterViewController () <RegisterMobileViewDelegate>

@end

@implementation RegisterViewController
{
    UIView *registerView;
}

- (void)loadView
{
    RegisterMobileView *mobileView = [[RegisterMobileView alloc] init];
    mobileView.delegate = self;
    registerView = mobileView;
    self.view = mobileView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
}

#pragma mark - Action
- (void) actionCheckMobile:(NSString *)mobile
{
    //参数检查
    if (![ValidateUtil isRequired:mobile]) {
        [self showError:ERROR_MOBILE_REQUIRED];
        return;
    }
    if (![ValidateUtil isMobile:mobile]) {
        [self showError:ERROR_MOBILE_FORMAT];
        return;
    }
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //登录接口调用
    /*
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler loginWithUser:nil success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
    */
}

@end
