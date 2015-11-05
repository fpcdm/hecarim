//
//  CaseCashierView.m
//  LttMember
//
//  Created by wuyong on 15/11/3.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CaseCashierView.h"
#import "CaseEntity.h"
#import "ResultEntity.h"

@implementation CaseCashierView
{
    UILabel *amountLabel;
    
    UIButton *weixinQrcodeButton;
    UIButton *alipayQrcodeButton;
    UIButton *moneyButton;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //支付金额
    amountLabel = [[UILabel alloc] init];
    amountLabel.textColor = COLOR_MAIN_HIGHLIGHT;
    amountLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:amountLabel];
    
    UIView *superview = self;
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(20);
        make.centerX.equalTo(superview.mas_centerX);
        make.height.equalTo(@20);
    }];
    
    return self;
}

- (void)renderData
{
    //支付金额
    CaseEntity *intention = [self getData:@"intention"];
    amountLabel.text = [NSString stringWithFormat:@"您需要支付%.2f元", [intention.totalAmount floatValue]];
    
    //请选择支付方式
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = FONT_MAIN;
    titleLabel.textColor = COLOR_MAIN_BLACK;
    titleLabel.text = @"请选择支付方式";
    [self addSubview:titleLabel];
    
    UIView *superview = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLabel.mas_bottom).offset(20);
        make.left.equalTo(superview.mas_left).offset(10);
        make.height.equalTo(@20);
    }];
    
    UIView *titleSeperator = [[UIView alloc] init];
    titleSeperator.backgroundColor = COLOR_MAIN_BLACK;
    [self addSubview:titleSeperator];
    
    [titleSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(9.5);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    UIView *separatorView = nil;
    
    //循环输出支付方式
    NSArray *payments = [self getData:@"payments"];
    for (ResultEntity* payment in payments) {
        //当前支付按钮
        UIView *paymentButton = nil;
        
        //判断支付方式
        if ([PAY_WAY_WEIXIN isEqualToString:payment.data]) {
            //微信扫码支付
            weixinQrcodeButton = [self makeButton:@{
                                                    @"icon": @"methodWeixinQrcode",
                                                    @"text": @"微信扫码支付",
                                                    @"detail": @"扫描微信二维码进行安全支付"
                                                    }];
            [weixinQrcodeButton addTarget:self action:@selector(actionWeixinQrcode) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:weixinQrcodeButton];
            
            paymentButton = weixinQrcodeButton;
        } else if ([PAY_WAY_ALIPAY isEqualToString:payment.data]) {
            //支付宝扫码支付
            alipayQrcodeButton = [self makeButton:@{
                                                    @"icon": @"methodAlipayQrcode",
                                                    @"text": @"支付宝扫码支付",
                                                    @"detail": @"扫描支付宝二维码进行安全支付"
                                                    }];
            [alipayQrcodeButton addTarget:self action:@selector(actionAlipayQrcode) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:alipayQrcodeButton];
            
            paymentButton = alipayQrcodeButton;
        } else if ([PAY_WAY_CASH isEqualToString:payment.data]) {
            //现金支付
            moneyButton = [self makeButton:@{
                                             @"icon": @"methodMoney",
                                             @"text": @"现金支付",
                                             @"detail": @"支付现金给工作人员"
                                             }];
            [moneyButton addTarget:self action:@selector(actionUseMoney) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:moneyButton];
            
            paymentButton = moneyButton;
        }
        
        //按钮输出
        if (paymentButton) {
            [paymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(separatorView ? separatorView.mas_bottom : titleSeperator.mas_bottom);
                make.left.equalTo(superview.mas_left);
                make.right.equalTo(superview.mas_right);
                make.height.equalTo(@60);
            }];
            
            separatorView = paymentButton;
        }
    }
}

- (UIButton *)makeButton:(NSDictionary *)param
{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = COLOR_MAIN_WHITE;
    
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
    textLabel.font = FONT_MAIN;
    textLabel.textColor = COLOR_MAIN_BLACK;
    [button addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_top).offset(10);
        make.left.equalTo(imageView.mas_right).offset(10);
        make.height.equalTo(@20);
    }];
    
    //详情
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = [param objectForKey:@"detail"];
    detailLabel.font = FONT_MIDDLE;
    detailLabel.textColor = COLOR_MAIN_GRAY;
    [button addSubview:detailLabel];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom);
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
    
    //边框
    UIView *borderView = [[UIView alloc] init];
    borderView.backgroundColor = COLOR_MAIN_BLACK;
    [button addSubview:borderView];
    
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button.mas_bottom);
        make.left.equalTo(button.mas_left);
        make.right.equalTo(button.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    return button;
}

#pragma mark - Action
- (void)actionWeixinQrcode
{
    [self.delegate actionWeixinQrcode];
}

- (void)actionAlipayQrcode
{
    [self.delegate actionAlipayQrcode];
}

- (void)actionUseMoney
{
    [self.delegate actionUseMoney];
}

@end
