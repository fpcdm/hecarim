//
//  ProfileNicknameView.m
//  LttMember
//
//  Created by wuyong on 15/6/18.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SuggestionView.h"

@implementation SuggestionView
{
    UITextView *textView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //输入框
    textView = [[UITextView alloc] init];
    textView.font = FONT_MAIN;
    textView.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    textView.layer.cornerRadius = 3.0;
    textView.placeholder = @"请输入意见反馈";
    [self addSubview:textView];
    
    UIView *superview = self;
    int padding = 10;
    [textView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@150);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"发表"];
    [button addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(textView.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithFloat:HEIGHT_MIDDLE_BUTTON]);
    }];
    
    return self;
}

#pragma mark - RenderData

#pragma mark - Action
- (void)actionSave
{
    [textView resignFirstResponder];
    
    [self.delegate actionSave:textView.text];
}

@end
