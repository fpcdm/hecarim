//
//  SafetyPasswordViewController.m
//  LttMember
//
//  Created by wuyong on 15/6/18.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SafetyPasswordViewController.h"
#import "SafetyPasswordView.h"
#import "UserHandler.h"
#import "ValidateUtil.h"

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
    if (![ValidateUtil isRequired:oldPassword]) {
        [self showError:[LocaleUtil error:@"OldPassword.Required"]];
        return;
    }
    if (![ValidateUtil isRequired:newPassword]) {
        [self showError:[LocaleUtil error:@"NewPassword.Required"]];
        return;
    }
    
    UserEntity *userEntity = [[UserEntity alloc] init];
    userEntity.password = oldPassword;
    
    //获取当前登陆用户ID
    UserEntity *currentUser = [[StorageUtil sharedStorage] getUser];
    if (currentUser) {
        userEntity.id = currentUser.id;
    }
    
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler changePassword:userEntity password:newPassword success:^(NSArray *result){
        //切换视图
        [passwordView toggleSuccessView];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void)actionFinish
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
