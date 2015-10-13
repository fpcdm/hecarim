//
//  HomeView.m
//  LttMember
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeView.h"
#import "CategoryEntity.h"

@interface HomeView ()

@end

@implementation HomeView
{
    UILabel *addressLabel;
}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    [self topView];
    [self middleView];
    [self bottomView];
    
    return self;
}

- (void) topView
{
    //当前位置
    UIButton *locationButton = [[UIButton alloc] init];
    locationButton.backgroundColor = [UIColor colorWithHexString:@"EFEFEF"];
    locationButton.layer.cornerRadius = 3.0f;
    [locationButton addTarget:self action:@selector(actionGps) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:locationButton];
    
    UIView *superview = self;
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(2.5);
        make.left.equalTo(superview.mas_left).offset(2.5);
        make.right.equalTo(superview.mas_right).offset(-2.5);
        make.height.equalTo(@20);
    }];
    
    UIImageView *pointView = [[UIImageView alloc] init];
    pointView.image = [UIImage imageNamed:@"homePoint"];
    [locationButton addSubview:pointView];
    
    superview = locationButton;
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left).offset(5);
        make.centerY.equalTo(superview.mas_centerY);
        make.height.equalTo(@16);
        make.width.equalTo(@16);
    }];
    
    addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"正在定位";
    addressLabel.font = FONT_SMALL;
    addressLabel.textColor = COLOR_MAIN_DARK;
    [locationButton addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(pointView.mas_right).offset(5);
        make.height.equalTo(@20);
    }];
}

- (void) middleView
{
    
}

- (void) bottomView
{
    
}

#pragma mark - RenderData
- (void) renderData
{
    //显示位置
    NSString *address = [self getData:@"address"];
    NSString *gps = [self getData:@"gps"];
    if (address) {
        NSNumber *count = [self getData:@"count"];
        if (count && ![@-1 isEqualToNumber:count]) {
            address = [NSString stringWithFormat:@"%@(有%@位信使为您服务)", address, count];
        }
        addressLabel.text = address;
    } else if (gps) {
        addressLabel.text = gps;
    }
}

- (void) actionCase: (UIButton *)sender
{
    
}

- (void)actionGps
{
    [self.delegate actionGps];
}

@end
