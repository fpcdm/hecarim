//
//  SafetyPasswordViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/18.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SafetyPasswordViewController.h"
#import "SafetyPasswordView.h"

@interface SafetyPasswordViewController () <SafetyPasswordViewDelegate>

@end

@implementation SafetyPasswordViewController
{
    SafetyPasswordView *passwordView;
}

- (void)loadView
{
    passwordView = [[SafetyPasswordView alloc] init];
    passwordView.delegate = self;
    self.view = passwordView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
}

#pragma mark - Action
- (void)actionChange:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    //@todo 修改密码
    
    //切换视图
    [passwordView toggleSuccessView];
}

- (void)actionFinish
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
