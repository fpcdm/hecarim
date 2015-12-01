//
//  RegisterRecommendView.m
//  LttMember
//
//  Created by 杨海锋 on 15/12/1.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "RegisterRecommendView.h"

@implementation RegisterRecommendView
{
    UITextField *mobileInput;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    int padding = 10;
    
    //推荐人手机号视图
    UIView *mobileView = [[UIView alloc] init];
    mobileView.layer.borderWidth = 0.5f;
    mobileView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    mobileView.layer.cornerRadius = 3.0f;
    mobileView.backgroundColor = COLOR_MAIN_WHITE;
    [self addSubview:mobileView];
    
    [mobileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@50);
    }];
    
    //手机号
    UILabel *mobileLabel = [[UILabel alloc] init];
    mobileLabel.text = @"手机号";
    mobileLabel.textColor = COLOR_MAIN_BLACK;
    mobileLabel.font = FONT_MAIN;
    [mobileView addSubview:mobileLabel];
    
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileView.mas_left).offset(padding);
        make.centerY.equalTo(mobileView.mas_centerY);
        make.width.equalTo(@50);
    }];
    
    //输入框
    mobileInput = [[UITextField alloc] init];
    mobileInput.placeholder = @"推荐人手机号";
    mobileInput.textColor = COLOR_MAIN_BLACK;
    mobileInput.font = FONT_MAIN;
    mobileInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileInput.keyboardType = UIKeyboardTypeNumberPad;
    [mobileView addSubview:mobileInput];
    
    [mobileInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileLabel.mas_right).offset(padding);
        make.centerY.equalTo(mobileView.mas_centerY);
        make.right.equalTo(mobileView.mas_right);
        make.height.equalTo(@30);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"确定"];
    [button addTarget:self action:@selector(actionRecommend) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mobileView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    //提示
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"提示:";
    NSString *labelString = @"提示:\n1.一台手机只能填写一次。\n2.可跳过此步骤，以后你可以在【账户】\n-【推荐与分享】中补充填写推荐人。";
    tipLabel.textColor = COLOR_MAIN_BLACK;
    tipLabel.font = FONT_MAIN;
    tipLabel.numberOfLines = 4;
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:labelString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:2];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByTruncatingTail];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [labelString length])];
    [tipLabel setAttributedText:attributedString1];
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
    }];
    
    return self;
}



- (void)actionRecommend
{
    [self.delegate actionRecommend:mobileInput.text];
}

- (void)hideKeyboard
{
    [mobileInput resignFirstResponder];
}

@end
