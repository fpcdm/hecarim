//  忘记密码，验证手机号
//  ForgetPasswordView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/10/19.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol ForgetPasswordViewDelegate <NSObject>

- (void) actionCheckMobile:(NSString *)mobile;

@end


@interface ForgetPasswordView : AppView

@property (retain, nonatomic) id<ForgetPasswordViewDelegate> delegate;

@end
