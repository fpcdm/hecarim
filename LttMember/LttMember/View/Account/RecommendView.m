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
    [self addSubview:formView];
    
    UIView *superview = self;
    [formView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@100);
    }];
    
    mobileField = [AppUIUtil makeTextField];
    mobileField.placeholder = @"昵称";
    [formView addSubview:mobileField];
    
    superview = formView;
    int padding = 10;
    [mobileField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@40);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"保存"];
    [button addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    [formView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(mobileField.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithFloat:HEIGHT_MIDDLE_BUTTON]);
    }];
    
    //详情视图
    detailView = [[UIView alloc] init];
    [self addSubview:detailView];
    
    superview = self;
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@100);
    }];
    
    UIButton *infoButton = [[UIButton alloc] init];
    infoButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    infoButton.layer.borderWidth = 0.5f;
    infoButton.backgroundColor = COLOR_MAIN_WHITE;
    [detailView addSubview:infoButton];
    
    superview = detailView;
    [infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(40);
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
        make.left.equalTo(superview.mas_left).offset(10);
        make.height.equalTo(@20);
    }];
    
    mobileLabel = [[UILabel alloc] init];
    mobileLabel.text = @"";
    mobileLabel.textColor = COLOR_MAIN_BLACK;
    mobileLabel.font = FONT_MAIN;
    [infoButton addSubview:mobileLabel];
    
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@20);
    }];
    
    return self;
}

@end
