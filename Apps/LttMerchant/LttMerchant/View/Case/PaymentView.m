//
//  PaymentView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/25.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "PaymentView.h"
#import "ResultEntity.h"

@implementation PaymentView
{
    UIButton *weixinButton;
    UIButton *alipayButton;
    UIButton *moneyButton;
    UIButton *qrcodeChooseButton;
    UIButton *moneyConfirmButton;
    UIButton *moneyChooseButton;
    
    UIView *separatorView;
    UIView *superView;
    int padding;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    separatorView = nil;
    superView = self;
    padding= 10;
    
    //二维码视图
    self.qrcodeView = [[UIView alloc] init];
    self.qrcodeView.backgroundColor = COLOR_MAIN_WHITE;
    self.qrcodeView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    self.qrcodeView.layer.borderWidth = 0.5f;
    self.qrcodeView.hidden = YES;
    [self addSubview:self.qrcodeView];
    
    [self.qrcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@170);
    }];
    
    //二维码重新选择按钮
    qrcodeChooseButton = [AppUIUtil makeButton:@"选择其它支付方式"];
    qrcodeChooseButton.backgroundColor = COLOR_MAIN_WHITE;
    qrcodeChooseButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    qrcodeChooseButton.layer.borderWidth = 0.5f;
    qrcodeChooseButton.hidden = YES;
    [qrcodeChooseButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [qrcodeChooseButton addTarget:self action:@selector(actionChooseMethod) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:qrcodeChooseButton];
    
    [qrcodeChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrcodeView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@40);
    }];
    
    //确认现金支付按钮
    moneyConfirmButton = [AppUIUtil makeButton:@"确认用户已付款完成支付"];
    moneyConfirmButton.hidden = YES;
    [moneyConfirmButton addTarget:self action:@selector(actionConfirmPayed) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moneyConfirmButton];
    
    [moneyConfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@40);
    }];
    
    //现金支付重新选择按钮
    moneyChooseButton = [AppUIUtil makeButton:@"选择其它支付方式"];
    moneyChooseButton.backgroundColor = COLOR_MAIN_WHITE;
    moneyChooseButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    moneyChooseButton.layer.borderWidth = 0.5f;
    moneyChooseButton.hidden = YES;
    [moneyChooseButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [moneyChooseButton addTarget:self action:@selector(actionChooseMethod) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moneyChooseButton];
    
    [moneyChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyConfirmButton.mas_bottom).offset(20);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@40);
    }];
    
    return self;
}

- (void)display
{
    NSArray *payments = [self fetch:@"payments"];
    for (ResultEntity *payment in payments) {
        //判断支付方式
        if ([PAY_WAY_WEIXIN isEqualToString:payment.data]) {
            //微信扫码支付
            weixinButton = [self makeButton:@{
                                              @"icon": @"methodWeixinQrcode",
                                              @"text": @"微信扫码"
                                              }];
            [weixinButton addTarget:self action:@selector(actionWeixinQrcode) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:weixinButton];
            
            [self buttonPosition:weixinButton];
            
            separatorView = weixinButton;
        } else if ([PAY_WAY_ALIPAY isEqualToString:payment.data]) {
            //支付宝扫码支付
            alipayButton = [self makeButton:@{
                                              @"icon": @"methodAlipayQrcode",
                                              @"text": @"支付宝扫码"
                                              }];
            [alipayButton addTarget:self action:@selector(actionAlipayQrcode) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:alipayButton];
            [self buttonPosition:alipayButton];
            
            separatorView = alipayButton;
        } else if ([PAY_WAY_CASH isEqualToString:payment.data]) {
            //现金支付
            moneyButton = [self makeButton:@{
                                             @"icon": @"methodMoney",
                                             @"text": @"现金支付"
                                             }];
            [moneyButton addTarget:self action:@selector(actionUseMoney) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:moneyButton];
            [self buttonPosition:moneyButton];
        }
    }
}

//微信支付
- (void)actionWeixinQrcode
{
    if (weixinButton) weixinButton.hidden = YES;
    if (alipayButton) alipayButton.hidden = YES;
    if (moneyButton) moneyButton.hidden = YES;
    
    self.qrcodeView.hidden = NO;
    qrcodeChooseButton.hidden = NO;
    moneyConfirmButton.hidden = YES;
    moneyChooseButton.hidden = YES;

    [self.delegate actionWeixinQrcode];
}

//支付宝支付
- (void)actionAlipayQrcode
{
    if (weixinButton) weixinButton.hidden = YES;
    if (alipayButton) alipayButton.hidden = YES;
    if (moneyButton) moneyButton.hidden = YES;
    
    self.qrcodeView.hidden = NO;
    qrcodeChooseButton.hidden = NO;
    moneyConfirmButton.hidden = YES;
    moneyChooseButton.hidden = YES;
    [self.delegate actionAlipayQrcode];
}

//现在支付
- (void)actionUseMoney
{
    if (weixinButton) weixinButton.hidden = YES;
    if (alipayButton) alipayButton.hidden = YES;
    if (moneyButton) moneyButton.hidden = YES;
    
    self.qrcodeView.hidden = YES;
    qrcodeChooseButton.hidden = YES;
    moneyConfirmButton.hidden = NO;
    moneyChooseButton.hidden = NO;
    [self.delegate actionUseMoney];
}

//确认是否是现金支付
- (void)actionConfirmPayed
{
    [self.delegate actionConfirmPayed];
}

//重新选择支付方式
- (void)actionChooseMethod
{
    if (weixinButton) weixinButton.hidden = NO;
    if (alipayButton) alipayButton.hidden = NO;
    if (moneyButton) moneyButton.hidden = NO;
    
    self.qrcodeView.hidden = YES;
    qrcodeChooseButton.hidden = YES;
    moneyConfirmButton.hidden = YES;
    moneyChooseButton.hidden = YES;
    [self.delegate actionChooseMethod];
}


- (void)buttonPosition:(UIButton *)button
{
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        if (separatorView)
            make.top.equalTo(separatorView.mas_bottom).offset(padding);
        else
            make.top.equalTo(superView.mas_top).offset(padding);
        
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@60);
    }];
}

- (UIButton *)makeButton:(NSDictionary *)param
{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = COLOR_MAIN_WHITE;
    button.layer.borderColor = CGCOLOR_MAIN_BORDER;
    button.layer.borderWidth = 0.5f;
    
    //图标
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:[param objectForKey:@"icon"]];
    [button addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_top).offset(10);
        make.left.equalTo(button.mas_left).offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    //文字
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = [param objectForKey:@"text"];
    textLabel.font = FONT_MAIN_BOLD;
    textLabel.textColor = COLOR_MAIN_BLACK;
    [button addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button.mas_centerY);
        make.left.equalTo(imageView.mas_right).offset(10);
        make.height.equalTo(@20);
    }];
    
    //箭头
    UIImageView *chooseView = [[UIImageView alloc] init];
    chooseView.image = [UIImage imageNamed:@"chooseMethod"];
    [button addSubview:chooseView];
    
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button.mas_centerY);
        make.right.equalTo(button.mas_right).offset(-10);
        make.width.equalTo(@10);
        make.height.equalTo(@20);
    }];
    
    return button;
}

@end
