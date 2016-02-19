//
//  RecommendView.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/2/18.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "RecommendView.h"

@implementation RecommendView
{
    int padding;
    UIView *superView;
    UITextField *mobileField;
    UIView *inputView;
    UIView *showView;
}
- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = COLOR_MAIN_BG;
    
    superView = self;
    padding = 10;
    
    return self;
}

- (void)setRecommend
{
    inputView = [[UIView alloc] init];
    inputView.hidden = YES;
    [self addSubview:inputView];
    
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        
        make.height.equalTo(@200);
        
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"请填写要请您的人的手机号码";
    tipLabel.textColor = COLOR_MAIN_BLACK;
    tipLabel.font = FONT_MAIN;
    [inputView addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        
        make.height.equalTo(@20);
    }];
    
    //手机号输入框
    mobileField = [AppUIUtil makeTextField];
    mobileField.placeholder = @"请输入推荐人的手机号";
    mobileField.font = FONT_MAIN;
    mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileField.keyboardType = UIKeyboardTypeNumberPad;
    mobileField.layer.borderWidth = 0.5;
    mobileField.layer.borderColor = CGCOLOR_MAIN_BORDER;
    
    [inputView addSubview:mobileField];
    
    [mobileField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        
        make.height.equalTo(@40);
    }];
    
    UIButton *button = [AppUIUtil makeButton:@"确定"];
    [button addTarget:self action:@selector(actionRecommend) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mobileField.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"您只有一次填写推荐人手机号码机会，请慎重填写";
    noticeLabel.textColor = COLOR_MAIN_GRAY;
    noticeLabel.font = FONT_SMALL;
    [inputView addSubview:noticeLabel];
    
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
    }];
}

- (void)showRecommend:(NSString *)mobile
{
    showView = [[UIView alloc] init];
    showView.hidden = YES;
    [self addSubview:showView];
    
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        
        make.height.equalTo(@100);
        
    }];
    
    UIView *recommendView = [[UIView alloc] init];
    recommendView.layer.borderWidth = 0.5f;
    recommendView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    recommendView.backgroundColor = COLOR_MAIN_WHITE;
    [self addSubview:recommendView];
    
    [recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(20);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        
        make.height.equalTo(@40);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"我的推荐人";
    nameLabel.font = FONT_MAIN;
    [recommendView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(recommendView.mas_left).offset(padding);
        make.centerY.equalTo(recommendView.mas_centerY);
    }];
    
    UILabel *mobileLabel = [[UILabel alloc] init];
    mobileLabel.text = mobile;
    mobileLabel.font = FONT_MAIN;
    [recommendView addSubview:mobileLabel];
    
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(recommendView.mas_right).offset(-padding);
        make.centerY.equalTo(recommendView.mas_centerY);
    }];
}

- (void)display
{
    NSString *recommendMobile = [self fetch:@"recommendMobile"];
    if (recommendMobile != nil && recommendMobile.length > 0) {
        [self showRecommend:recommendMobile];
        inputView.hidden = YES;
        showView.hidden = NO;
    } else {
        [self setRecommend];
        inputView.hidden = NO;
        showView.hidden = YES;
    }
}

- (void)actionRecommend
{
    [self.delegate actionRecommend:mobileField.text];
}

- (void)hideKeyboard
{
    [mobileField resignFirstResponder];
}

@end
