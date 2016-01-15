//
//  ThirdLoginView.h
//  LttMember
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol ThirdLoginViewDelegate <NSObject>

- (void) actionSendCode:(NSString *)mobile;
- (void) actionVerifyCode:(NSString *)mobile code:(NSString *)code;

@end

@interface ThirdLoginView : AppView

@property (retain, nonatomic) id<ThirdLoginViewDelegate> delegate;

@property (retain, nonatomic) UIButton *sendButton;

@end
