//
//  LoginView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/2.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol LoginViewDelegate <NSObject>

- (void)actionForgetPassword;

- (void)actionLogin:(UserEntity *) user;

- (void)actionRegister;

@end

@interface LoginView : AppView

@property (retain , nonatomic) id<LoginViewDelegate>delegate;

@end
