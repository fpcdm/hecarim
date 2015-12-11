//
//  SetPayPasswordCodeView.h
//  LttMember
//
//  Created by 杨海锋 on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol SetPayPasswordCodeViewDelegate <NSObject>

- (void)actionSendSms;

- (void)actionVerifyCode:(NSString *)verifyCode;

@end

@interface SetPayPasswordCodeView : AppView

@property (retain , nonatomic) id<SetPayPasswordCodeViewDelegate>delegate;

@property (retain , nonatomic) UIButton *sendBtn;

@end
