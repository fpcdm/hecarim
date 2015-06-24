//
//  OrderSuccessView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseSuccessView.h"
#import "AXRatingView.h"
#import "OrderEntity.h"

@implementation CaseSuccessView
{
    UIImageView *imageView;
    AXRatingView *ratingView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"感谢您的评价";
    titleLabel.textColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_HIGHLIGHTED];
    titleLabel.font = [UIFont boldSystemFontOfSize:26];
    [self addSubview:titleLabel];
    
    UIView *superview = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(40);
        make.centerX.equalTo(superview.mas_centerX);
        
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"我们将努力把服务做得更好";
    detailLabel.textColor = [UIColor colorWithHexString:COLOR_GRAY_TEXT];
    detailLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    [self addSubview:detailLabel];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(superview.mas_centerX);
        
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"返回首页" font:[UIFont boldSystemFontOfSize:SIZE_BUTTON_TEXT]];
    [button addTarget:self action:@selector(actionHome) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_bottom).offset(-5);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    //服务人员
    UIView *customerView = [UIView new];
    customerView.layer.cornerRadius = 3.0f;
    customerView.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG];
    [self addSubview:customerView];
    
    [customerView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(detailLabel.mas_bottom).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@180);
    }];
    superview = customerView;
    
    //头像
    imageView = [UIImageView new];
    [customerView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(15);
        make.centerX.equalTo(superview.mas_centerX);
        
        make.width.equalTo(@90);
        make.height.equalTo(@90);
    }];
    
    //间隔
    UIView *sepratorView = [[UIView alloc] init];
    sepratorView.backgroundColor = [UIColor colorWithHexString:@"979797"];
    [customerView addSubview:sepratorView];
    
    [sepratorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(imageView.mas_bottom).offset(15);
        make.left.equalTo(superview.mas_left).offset(2);
        make.right.equalTo(superview.mas_right).offset(-2);
        
        make.height.equalTo(@1);
    }];
    
    //评级
    ratingView = [[AXRatingView alloc] init];
    ratingView.highlightColor = [UIColor colorWithHexString:COLOR_HIGHLIGHTED_BG];
    ratingView.disabled = YES;
    [ratingView setStepInterval:0.0];
    [customerView addSubview:ratingView];
    
    [ratingView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(sepratorView.mas_bottom).offset(10);
        make.centerX.equalTo(superview.mas_centerX);
        
        make.width.equalTo(@135);
    }];
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    OrderEntity *order = [self getData:@"order"];
    
    imageView.image = [order avatarImage];
    ratingView.value = [order.commentLevel floatValue];
}

#pragma mark - Action
- (void)actionHome
{
    [self.delegate actionHome];
}

@end
