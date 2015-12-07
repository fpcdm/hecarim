//
//  ResetPasswordView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/10/21.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol ResetPasswordViewDelegate <NSObject>

- (void)actionResetPassword:(NSString *) newPassword reNewPassword:(NSString *)reNewPassword;

@end

@interface ResetPasswordView : AppView

@property (retain, nonatomic) id<ResetPasswordViewDelegate>delegate;


@end
