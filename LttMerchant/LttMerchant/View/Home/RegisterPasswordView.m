//
//  RegisterPasswordView.m
//  LttMember
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "RegisterPasswordView.h"

@implementation RegisterPasswordView
{
    UILabel *merchantLabel;
    UITextField *merchantField;
    UILabel *contactLabel;
    UITextField *contactField;
    UILabel *passwordLabel;
    UITextField *passwordField;
    UIView *inputView2;
    NSString *mobileStatus;
    UIView *xxView;
    UIView *inputView1;
    UIView *superview;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //输入视图
    UIView *inputView = [UIView new];
    inputView.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    inputView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    inputView.layer.cornerRadius = 3.0f;
    inputView.layer.borderWidth = 0.5f;
    [self addSubview:inputView];
    
    superview = self;
    int padding = 10;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@50);
    }];
    
    //商户名称
    merchantLabel = [UILabel new];
    merchantLabel.text = @"商户名称";
    merchantLabel.backgroundColor = [UIColor clearColor];
    merchantLabel.font = FONT_MAIN;
    [inputView addSubview:merchantLabel];
    
    [merchantLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(inputView.mas_left).offset(padding);
        make.top.equalTo(inputView.mas_top).offset(padding);
        
        make.height.equalTo(@30);
        make.width.equalTo(@67);
    }];
    
    //商户名称输入框
    merchantField = [AppUIUtil makeTextField];
    merchantField.placeholder = @"请输入商户名称";
    merchantField.font = FONT_MAIN;
    [inputView addSubview:merchantField];
    
    [merchantField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(inputView.mas_top).offset(padding);
        make.left.equalTo(merchantLabel.mas_right);
        make.right.equalTo(inputView.mas_right);
        make.height.equalTo(@30);
    }];
    
    //输入视图
    inputView1 = [UIView new];
    inputView1.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    inputView1.layer.borderColor = CGCOLOR_MAIN_BORDER;
    inputView1.layer.cornerRadius = 3.0f;
    inputView1.layer.borderWidth = 0.5f;
    [self addSubview:inputView1];
    
    [inputView1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(inputView.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@50);
    }];

    //联系人
    contactLabel = [UILabel new];
    contactLabel.text = @"联系人";
    contactLabel.backgroundColor = [UIColor clearColor];
    contactLabel.font = FONT_MAIN;
    [inputView1 addSubview:contactLabel];
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView1.mas_top).offset(padding);
        make.left.equalTo(inputView1.mas_left).offset(padding);
        make.height.equalTo(@30);
        make.width.equalTo(@67);
    }];
    
    //联系人称输入框
    contactField = [AppUIUtil makeTextField];
    contactField.placeholder = @"请输入联系人姓名";
    contactField.font = FONT_MAIN;
    [inputView1 addSubview:contactField];
    
    [contactField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(inputView1.mas_top).offset(padding);
        make.left.equalTo(contactLabel.mas_right);
        make.right.equalTo(inputView1.mas_right);
        make.height.equalTo(@30);
    }];
    
    xxView = inputView1;
    
    return self;
}

#pragma mark - Action
- (void) actionRegister
{
    UserEntity *user = [[UserEntity alloc] init];
    user.name = merchantField.text;
    user.nickname = contactField.text;
    user.password = passwordField.text;
    
    [self.delegate actionRegister:user];
}

- (void)renderData
{
    int padding = 10;
    mobileStatus = [self getData:@"mobileStatus"];
    if ([mobileStatus isEqualToString:@"unregistered"]) {
        
        //输入视图
        inputView2 = [UIView new];
        inputView2.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
        inputView2.layer.borderColor = CGCOLOR_MAIN_BORDER;
        inputView2.layer.cornerRadius = 3.0f;
        inputView2.layer.borderWidth = 0.5f;
        [self addSubview:inputView2];
        
        [inputView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(inputView1.mas_bottom).offset(padding);
            make.left.equalTo(superview.mas_left).offset(padding);
            make.right.equalTo(superview.mas_right).offset(-padding);
            
            make.height.equalTo(@50);
        }];
        
        //登陆密码
        passwordLabel = [UILabel new];
        passwordLabel.text = @"用户密码";
        passwordLabel.backgroundColor = [UIColor clearColor];
        passwordLabel.font = FONT_MAIN;
        [inputView2 addSubview:passwordLabel];
        
        [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(inputView2.mas_left).offset(padding);
            make.top.equalTo(inputView2.mas_top).offset(padding);
            
            make.height.equalTo(@30);
            make.width.equalTo(@67);
        }];
        
        //密码输入框
        passwordField = [AppUIUtil makeTextField];
        passwordField.placeholder = @"请输入密码";
        passwordField.secureTextEntry = YES;
        passwordField.font = FONT_MAIN;
        [inputView2 addSubview:passwordField];
        
        [passwordField mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(inputView2.mas_top).offset(padding);
            make.left.equalTo(passwordLabel.mas_right);
            make.right.equalTo(inputView2.mas_right);
            
            make.height.equalTo(@30);
        }];
        
        xxView = inputView2;
    }
    
    //密码提示
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"密码由6-20位英文字母，数字或符号组成";
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = FONT_MIDDLE;
    [self addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(xxView.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"确定"];
    [button addTarget:self action:@selector(actionRegister) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(tipLabel.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
}

@end
