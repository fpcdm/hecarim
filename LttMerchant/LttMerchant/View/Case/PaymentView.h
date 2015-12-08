//
//  PaymentView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/25.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol PaymentViewDelegate <NSObject>

//微信支付
- (void)actionWeixinQrcode;

//支付宝支付
- (void)actionAlipayQrcode;

//现金支付
- (void)actionUseMoney;

//确认现金支付
- (void)actionConfirmPayed;

//重新选择支付方式
- (void)actionChooseMethod;

@end

@interface PaymentView : AppView

@property (retain , nonatomic) id<PaymentViewDelegate>delegate;

@property (retain , nonatomic) UIView *qrcodeView;

@end
