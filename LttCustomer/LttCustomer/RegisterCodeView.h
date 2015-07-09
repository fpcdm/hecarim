//
//  RegisterCodeView.h
//  LttCustomer
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol RegisterCodeViewDelegate <NSObject>

- (void) actionSend;
- (void) actionVerifyCode: (NSString *)code;

@end

@interface RegisterCodeView : AppView

@property (retain, nonatomic) id<RegisterCodeViewDelegate> delegate;

@property (retain, nonatomic) UIButton *sendButton;

@end
