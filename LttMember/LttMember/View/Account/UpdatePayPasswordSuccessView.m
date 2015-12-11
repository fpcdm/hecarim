//
//  UpdatePayPasswordSuccessView.m
//  LttMember
//
//  Created by 杨海锋 on 15/12/9.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "UpdatePayPasswordSuccessView.h"

@implementation UpdatePayPasswordSuccessView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    int padding = 10;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"操作成功";
    tipLabel.textColor = COLOR_MAIN_BLACK;
    tipLabel.font = [UIFont systemFontOfSize:24.0];
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).offset(padding);
        make.centerX.equalTo(superView.mas_centerX);
        make.height.equalTo(@50);
    }];
    
    UIButton *button = [AppUIUtil makeButton:@"确认"];
    [button addTarget:self action:@selector(actionGoSafe) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    return self;
}

- (void)actionGoSafe
{
    [self.delegate actionGoSafe];
}

@end
