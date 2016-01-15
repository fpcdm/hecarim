//
//  SafetyPasswordView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/6/18.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol SafetyPasswordViewDelegate <NSObject>

@required
- (void)actionChange:(NSString *)oldPassword newPassword:(NSString *)newPassword;
- (void)actionFinish;

@end

@interface SafetyPasswordView : AppView

@property (retain, nonatomic) id<SafetyPasswordViewDelegate> delegate;

- (void) toggleSuccessView;

@end
