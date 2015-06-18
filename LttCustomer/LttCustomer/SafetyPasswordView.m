//
//  SafetyPasswordView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/18.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SafetyPasswordView.h"
#import "CTCheckbox.h"

@implementation SafetyPasswordView
{
    UITextField *originField;
    UITextField *newField;
    CTCheckbox *checkbox;
    UIButton *button;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //输入框
    originField = [AppUIUtil makeTextField];
    originField.placeholder = @"输入原密码";
    originField.secureTextEntry = YES;
    [self addSubview:originField];
    
    UIView *superview = self;
    int padding = 10;
    [originField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@40);
    }];
    
    //新密码
    newField = [AppUIUtil makeTextField];
    newField.placeholder = @"输入新密码";
    newField.secureTextEntry = YES;
    [self addSubview:newField];
    
    [newField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(originField.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@40);
    }];
    
    //复选框
    checkbox = [[CTCheckbox alloc] init];
    [checkbox addTarget:self action:@selector(checkboxDidChange:) forControlEvents:UIControlEventValueChanged];
    checkbox.textLabel.text = @"显示密码";
    [self addSubview:checkbox];
    
    [checkbox mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(newField.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@30);
        make.width.equalTo(@100);
    }];
    
    //按钮
    button = [AppUIUtil makeButton:@"下一步"];
    [button addTarget:self action:@selector(actionChange) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(checkbox.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
    }];
    
    return self;
}

#pragma mark - SuccessView
- (void) toggleSuccessView
{
    //移除原视图
    [originField removeFromSuperview];
    [newField removeFromSuperview];
    [checkbox removeFromSuperview];
    [button removeFromSuperview];
    
    //添加新视图
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.text = @"修改成功！";
    [self addSubview:infoLabel];
    
    UIView *superview = self;
    int padding = 10;
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
    }];
    
    //添加按钮
    button = [AppUIUtil makeButton:@"确认"];
    [button addTarget:self action:@selector(actionFinish) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(infoLabel.mas_bottom).offset(50);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
    }];
}

#pragma mark - Checkbox
- (void)checkboxDidChange:(CTCheckbox *)checkbox
{
    if (checkbox.checked) {
        originField.secureTextEntry = NO;
        newField.secureTextEntry = NO;
    } else {
        originField.secureTextEntry = YES;
        newField.secureTextEntry = YES;
    }
}

#pragma mark - Action
- (void)actionChange
{
    NSString *oldPassword = originField.text;
    NSString *newPassword = newField.text;
    [self.delegate actionChange:oldPassword newPassword:newPassword];
}

- (void)actionFinish
{
    [self.delegate actionFinish];
}

@end
