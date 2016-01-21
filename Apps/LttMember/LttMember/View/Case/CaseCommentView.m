//
//  OrderReceivedView.m
//  LttMember
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseCommentView.h"
#import "AXRatingView.h"
#import "CaseEntity.h"

@implementation CaseCommentView
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
    titleLabel.text = @"服务您满意吗";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR_MAIN_HIGHLIGHT;
    titleLabel.font = [UIFont boldSystemFontOfSize:26];
    [self addSubview:titleLabel];
    
    UIView *superview = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(40);
        make.centerX.equalTo(superview.mas_centerX);
        
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"为我们的服务人员做个评价吧";
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.textColor = COLOR_MAIN_GRAY;
    detailLabel.font = FONT_MIDDLE;
    [self addSubview:detailLabel];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(superview.mas_centerX);
        
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"提交评价" font:FONT_MAIN_BOLD];
    [button addTarget:self action:@selector(actionComment) forControlEvents:UIControlEventTouchUpInside];
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
    customerView.backgroundColor = COLOR_MAIN_WHITE;
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
    imageView.layer.cornerRadius = 45;
    imageView.clipsToBounds = YES;
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
    ratingView.highlightColor = COLOR_MAIN_HIGHLIGHT;
    [ratingView setStepInterval:1.0];
    [customerView addSubview:ratingView];
    
    [ratingView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(sepratorView.mas_bottom).offset(10);
        //修正居中问题
        make.centerX.equalTo(superview.mas_centerX).offset(13);
        
        make.width.equalTo(@135);
    }];
    
    return self;
}

#pragma mark - RenderData
- (void)display
{
    CaseEntity *intention = [self fetch:@"intention"];
    
    [intention avatarView:imageView];
}

#pragma mark - Action
- (void)actionComment
{
    NSLog(@"评分：%d", (int)ratingView.value);
    
    [self.delegate actionComment:(int)ratingView.value];
}

@end
