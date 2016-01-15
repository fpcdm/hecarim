//
//  RegisterMobileView.h
//  LttMember
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol RegisterMobileViewDelegate <NSObject>

- (void) actionCheckMobile:(NSString *)mobile code:(NSString *)code;

- (void) actionSend:(NSString *)mobile;

- (void) actionProtocol;

@end

@interface RegisterMobileView : AppView

@property (retain, nonatomic) id<RegisterMobileViewDelegate> delegate;

@property (retain, nonatomic) UIButton *sendButton;

@end
