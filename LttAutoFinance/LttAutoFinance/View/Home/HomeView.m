//
//  HomeView.m
//  LttAutoFinance
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeView.h"

@interface HomeView ()

@end

@implementation HomeView
{
    UILabel *addressLabel;
    UILabel *infoLabel;
    
    UIView *topView;
    UIView *middleView;
    UIView *bottomView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //背景图片
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"homeBg"];
    [self addSubview:bgView];
    
    UIView *superview = self;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
    }];
    
    //顶部视图
    [self topView];
    
    //中部视图
    [self middleView];
    
    //底部视图
    [self bottomView];
    
    return self;
}

- (void) topView
{
    //顶部视图
    topView = [[UIView alloc] init];
    [self addSubview:topView];
    
    UIView *superview = self;
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
    }];
}

//中部视图
- (void)middleView
{
    middleView = [UIView new];
    [self addSubview:middleView];
    
    UIView *superview = self;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make){
    }];
}

//底部视图
- (void)bottomView
{
    bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    
    UIView *superview = self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
    }];
}

#pragma mark - RenderData
- (void) renderData
{
    NSString *address = [self getData:@"address"];
    addressLabel.text = address;
    
    NSNumber *count = [self getData:@"count"];
    if (!count || [@-1 isEqualToNumber:count]) {
        infoLabel.text = @"";
    } else {
        infoLabel.text = [NSString stringWithFormat:@"有%@个信使等待为您服务", count];
    }
}

- (void) actionCase: (UIButton *)sender
{
    NSNumber *type = [NSNumber numberWithInteger:sender.tag];
    [self.delegate actionCase:type];
}

- (void)actionGps
{
    [self.delegate actionGps];
}

@end
