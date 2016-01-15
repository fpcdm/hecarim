//
//  ResetPasswordSuccess.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/10/21.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol ResetPasswordSuccessDelegate <NSObject>

- (void)actionLogin;

@end

@interface ResetPasswordSuccess : AppView

@property (retain, nonatomic) id<ResetPasswordSuccessDelegate>delegate;

@end
