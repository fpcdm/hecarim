//
//  LoginView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/12.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol LoginViewDelegate <NSObject>

@required
- (void)actionLogin;

@end

@interface LoginView : AppView

@property (retain, nonatomic) id<LoginViewDelegate> delegate;

@end
