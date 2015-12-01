//
//  RecommendView.m
//  LttMember
//
//  Created by wuyong on 15/12/1.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "RecommendView.h"

@implementation RecommendView
{
    UIView *formView;
    UIView *detailView;
    
    UITextField *mobileField;
    UILabel *mobileLabel;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //表单视图
    formView = [[UIView alloc] init];
    formView.hidden = YES;
    [self addSubview:formView];
    
    UIView *superview = self;
    [formView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@200);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"请填写邀请您的人的手机号码";
    tipLabel.textColor = COLOR_MAIN_BLACK;
    tipLabel.font = FONT_MAIN;
    [formView addSubview:tipLabel];
    
    superview = formView;
    int padding = 10;
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.height.equalTo(@20);
    }];
    
    mobileField = [AppUIUtil makeTextField];
    mobileField.keyboardType = UIKeyboardTypePhonePad;
    mobileField.placeholder = @"请输入手机号";
    [formView addSubview:mobileField];
    
    [mobileField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(tipLabel.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@40);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"确定"];
    [button addTarget:self action:@selector(actionRecommend) forControlEvents:UIControlEventTouchUpInside];
    [formView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(mobileField.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithFloat:HEIGHT_MIDDLE_BUTTON]);
    }];
    
    UILabel *warnLabel = [[UILabel alloc] init];
    warnLabel.text = @"您只有一次填写推荐人的机会，请慎重填写";
    warnLabel.textColor = COLOR_MAIN_GRAY;
    warnLabel.font = FONT_MIDDLE;
    [formView addSubview:warnLabel];
    
    [warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(20);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.height.equalTo(@20);
    }];
    
    //详情视图
    detailView = [[UIView alloc] init];
    detailView.hidden = YES;
    [self addSubview:detailView];
    
    superview = self;
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@200);
    }];
    
    UIButton *infoButton = [[UIButton alloc] init];
    infoButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    infoButton.layer.borderWidth = 0.5f;
    infoButton.backgroundColor = COLOR_MAIN_WHITE;
    [detailView addSubview:infoButton];
    
    superview = detailView;
    [infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(20);
        make.left.equalTo(superview.mas_left).offset(-0.5);
        make.right.equalTo(superview.mas_right).offset(0.5);
        make.height.equalTo(@40);
    }];
    
    UILabel *infoTitle = [[UILabel alloc] init];
    infoTitle.text = @"我的推荐人";
    infoTitle.textColor = COLOR_MAIN_BLACK;
    infoTitle.font = FONT_MAIN;
    [infoButton addSubview:infoTitle];
    
    superview = infoButton;
    [infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(superview.mas_left).offset(15);
        make.height.equalTo(@20);
    }];
    
    mobileLabel = [[UILabel alloc] init];
    mobileLabel.text = @"";
    mobileLabel.textColor = COLOR_MAIN_BLACK;
    mobileLabel.font = FONT_MAIN;
    [infoButton addSubview:mobileLabel];
    
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.right.equalTo(superview.mas_right).offset(-15);
        make.height.equalTo(@20);
    }];
    
    return self;
}

- (void) renderData
{
    NSString *mobile = [self getData:@"mobile"];
    if (mobile && [mobile length] > 0) {
        formView.hidden = YES;
        detailView.hidden = NO;
        
        mobile = [NSString stringWithFormat:@"%@****%@", [mobile substringToIndex:3], [mobile substringFromIndex:7]];
        mobileLabel.text = mobile;
    } else {
        formView.hidden = NO;
        detailView.hidden = YES;
    }
}

#pragma mark - Action
- (void)actionRecommend
{
    [mobileField resignFirstResponder];
    
    [self.delegate actionRecommend:mobileField.text];
}

@end
