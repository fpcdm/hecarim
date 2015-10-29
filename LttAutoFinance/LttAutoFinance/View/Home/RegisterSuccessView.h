//
//  RegisterSuccessView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol RegisterSuccessViewDelegate <NSObject>

- (void) actionAutoLogin;

@end

@interface RegisterSuccessView : AppView

@property (retain, nonatomic) id<RegisterSuccessViewDelegate> delegate;

@end
