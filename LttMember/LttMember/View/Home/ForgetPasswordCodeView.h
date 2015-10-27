//  忘记密码发送验证码
//  ForgetPasswordCodeView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/10/20.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol ForgetPasswordCodeViewDelegate <NSObject>

@required
//请求事件
- (void)actionSend;

//验证验证码
- (void)actionVerifyCode:(NSString *)code;


@end

@interface ForgetPasswordCodeView : AppView

@property (retain,nonatomic) id<ForgetPasswordCodeViewDelegate> delegate;

//发送短信按钮
@property (retain, nonatomic) UIButton *sendButton;


@end
