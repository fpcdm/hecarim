//
//  LoginView.h
//  LttMember
//
//  Created by wuyong on 15/6/12.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"
#import "UserEntity.h"

@protocol LoginViewDelegate <NSObject>

@required
- (void)actionLogin:(UserEntity *)user;

- (void)actionLoginWechat;

- (void)actionLoginQQ;

- (void)actionLoginSina;

- (void)actionFindPwd;

@end

@interface LoginView : AppView

@property (retain, nonatomic) id<LoginViewDelegate> delegate;

@end