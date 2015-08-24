//
//  IntentionLockedView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseLockedView.h"
#import "CaseEntity.h"

@implementation CaseLockedView
{
    UILabel *aboutLabel;
    UIImageView *imageView;
    UILabel *nameLabel;
    UIButton *mobileButton;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"我们联系到了离你最近的客服";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = COLOR_MAIN_DARK;
    [self addSubview:titleLabel];
    
    UIView *superview = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(10);
        make.top.equalTo(superview.mas_top).offset(20);
    }];
    
    UILabel *detailText = [UILabel new];
    detailText.text = @"稍后我们一个服务人员将联系您";
    detailText.backgroundColor = [UIColor clearColor];
    detailText.font = FONT_MIDDLE_BOLD;
    detailText.textColor = COLOR_MAIN_GRAY;
    [self addSubview:detailText];
    
    [detailText mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.equalTo(titleLabel.mas_left);
    }];
    
    UILabel *detailText2 = [UILabel new];
    detailText2.text = @"他将和您讨论一下您的需求以及服务地点";
    detailText2.backgroundColor = [UIColor clearColor];
    detailText2.font = FONT_MIDDLE_BOLD;
    detailText2.textColor = COLOR_MAIN_GRAY;
    [self addSubview:detailText2];
    
    [detailText2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(detailText.mas_bottom).offset(10);
        make.left.equalTo(titleLabel.mas_left);
    }];
    
    aboutLabel = [UILabel new];
    aboutLabel.text = @"即将为您服务的客服：";
    aboutLabel.backgroundColor = [UIColor clearColor];
    aboutLabel.font = FONT_MAIN_BOLD;
    aboutLabel.textColor = COLOR_MAIN_DARK;
    [self addSubview:aboutLabel];
    
    [aboutLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(detailText2.mas_bottom).offset(40);
        make.left.equalTo(titleLabel.mas_left);
        
    }];
    
    //客服区域
    [self customerView];
    
    return self;
}

- (void) customerView
{
    UIView *customerView = [UIView new];
    customerView.layer.cornerRadius = 3.0f;
    customerView.backgroundColor = COLOR_MAIN_WHITE;
    [self addSubview:customerView];
    
    UIView *superview = self;
    [customerView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(aboutLabel.mas_bottom).offset(5);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@225);
    }];
    superview = customerView;
    
    //头像
    imageView = [UIImageView new];
    [customerView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(15);
        make.centerX.equalTo(superview.mas_centerX);
        
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    //姓名
    nameLabel = [UILabel new];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:24];
    nameLabel.textColor = COLOR_MAIN_DARK;
    [customerView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(imageView.mas_bottom).offset(25);
        make.centerX.equalTo(superview.mas_centerX);
    }];
    
    //电话
    mobileButton = [UIButton new];
    [mobileButton setTitleColor:COLOR_MAIN_GRAY forState:UIControlStateNormal];
    mobileButton.titleLabel.font = FONT_MAIN_BOLD;
    mobileButton.titleLabel.backgroundColor = [UIColor clearColor];
    [mobileButton addTarget:self action:@selector(actionMobile) forControlEvents:UIControlEventTouchUpInside];
    [customerView addSubview:mobileButton];
    
    [mobileButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(nameLabel.mas_bottom).offset(12);
        make.centerX.equalTo(superview.mas_centerX);
    }];
}

#pragma mark - RenderData
- (void)renderData
{
    CaseEntity *intention = [self getData:@"intention"];
    
    [intention avatarView:imageView];
    nameLabel.text = intention.staffName;
    [mobileButton setTitle:[NSString stringWithFormat:@"联系电话：%@", intention.staffMobile] forState:UIControlStateNormal];
}

#pragma mark - Action
- (void)actionMobile
{
    [self.delegate actionMobile];
}

@end
