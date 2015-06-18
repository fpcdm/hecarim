//
//  ProfileNicknameView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/18.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ProfileNicknameView.h"

@implementation ProfileNicknameView
{
    UITextField *textField;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //修正闪烁
    self.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    
    //输入框
    textField = [[UITextField alloc] init];
    textField.placeholder = @"昵称";
    textField.layer.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG].CGColor;
    textField.layer.cornerRadius = 3.0;
    [self addSubview:textField];
    
    UIView *superview = self;
    int padding = 10;
    [textField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@40);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"保存"];
    [button addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(textField.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
    }];
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    NSString *nickname = [self getData:@"nickname"];
    if (nickname) {
        textField.text = nickname;
    }
}

#pragma mark - Action
- (void)actionSave
{
    [self.delegate actionSave:textField.text];
}

@end
