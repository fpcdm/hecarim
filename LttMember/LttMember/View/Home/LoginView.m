//
//  LoginView.m
//  LttMember
//
//  Created by wuyong on 15/6/12.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
{
    UITextField *mobileField;
    UITextField *passwordField;
    UIButton *button;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //输入视图
    UIView *inputView = [UIView new];
    inputView.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    inputView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    inputView.layer.borderWidth = 0.5f;
    [self addSubview:inputView];
    
    UIView *superview = self;
    int padding = 10;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(20);
        make.left.equalTo(superview.mas_left).offset(-0.5);
        make.right.equalTo(superview.mas_right).offset(0.5);
        
        make.height.equalTo(@100);
    }];
    
    //账户
    UILabel *accountLabel = [UILabel new];
    accountLabel.text = @"账户";
    accountLabel.font = FONT_MAIN;
    [inputView addSubview:accountLabel];
    
    superview = inputView;
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(20);
        make.top.equalTo(superview.mas_top).offset(padding);
        
        make.height.equalTo(@30);
        make.width.equalTo(@40);
    }];
    
    //手机号输入框
    mobileField = [AppUIUtil makeTextField];
    mobileField.keyboardType = UIKeyboardTypePhonePad;
    mobileField.placeholder = @"请输入手机号";
    mobileField.font = FONT_MAIN;
    [inputView addSubview:mobileField];
    
    [mobileField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(accountLabel.mas_right);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@30);
    }];
    
    //间隔
    UIView *borderView = [[UIView alloc] init];
    borderView.backgroundColor = COLOR_MAIN_BORDER;
    [inputView addSubview:borderView];
    
    [borderView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(accountLabel.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.height.equalTo(@0.5);
    }];
    
    //密码
    UILabel *passwordLabel = [UILabel new];
    passwordLabel.text = @"密码";
    passwordLabel.font = FONT_MAIN;
    [inputView addSubview:passwordLabel];
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(accountLabel.mas_left);
        make.top.equalTo(borderView.mas_bottom).offset(padding);
        
        make.width.equalTo(accountLabel.mas_width);
        make.height.equalTo(accountLabel.mas_height);
    }];
    
    //密码输入框
    passwordField = [AppUIUtil makeTextField];
    passwordField.placeholder = @"请输入密码";
    passwordField.secureTextEntry = YES;
    passwordField.font = FONT_MAIN;
    [inputView addSubview:passwordField];
    
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(borderView.mas_bottom).offset(padding);
        make.left.equalTo(mobileField.mas_left);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@30);
    }];
    
    //按钮
    button = [AppUIUtil makeButton:@"登陆"];
    [button addTarget:self action:@selector(actionLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    superview = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(inputView.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];

    //找回密码
    UIButton *findPwdBtn = [[UIButton alloc] init];
    [findPwdBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [findPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [findPwdBtn addTarget:self action:@selector(actionFindPwd) forControlEvents:UIControlEventTouchUpInside];
    findPwdBtn.titleLabel.font = FONT_MAIN;
    findPwdBtn.layer.cornerRadius = 0.0f;
    findPwdBtn.layer.borderWidth = 0.0f;
    [self addSubview:findPwdBtn];
    
    
    [findPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
    }];
    
    return self;
}

- (void)renderData
{
    //是否显示微信
    NSNumber *weixinInstalled = [self getData:@"weixin"];
    BOOL showWeixin = [@1 isEqualToNumber:weixinInstalled] ? YES : NO;
    CGFloat buttonWidth = showWeixin ? 1.0/3 : 1.0/2;
    
    //第三方登陆
    UIButton *wechatButton = nil;
    UIView *superview = self;
    if (showWeixin) {
        wechatButton = [self makeButton:[UIImage imageNamed:@"loginWechat"] title:@"微信登陆"];
        [wechatButton addTarget:self action:@selector(actionLoginWechat) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:wechatButton];
        
        [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superview.mas_left);
            make.bottom.equalTo(superview.mas_bottom);
            make.width.equalTo(superview.mas_width).multipliedBy(buttonWidth);
            make.height.equalTo(@45);
        }];
    }
    
    UIButton *qqButton = [self makeButton:[UIImage imageNamed:@"loginQQ"] title:@"QQ登陆"];
    [qqButton addTarget:self action:@selector(actionLoginQQ) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:qqButton];
    
    [qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if (showWeixin) {
            make.left.equalTo(wechatButton.mas_right);
        } else {
            make.left.equalTo(superview.mas_left);
        }
        make.bottom.equalTo(superview.mas_bottom);
        make.width.equalTo(superview.mas_width).multipliedBy(buttonWidth);
        make.height.equalTo(@45);
    }];
    
    UIButton *sinaButton = [self makeButton:[UIImage imageNamed:@"loginSina"] title:@"微博登陆"];
    [sinaButton addTarget:self action:@selector(actionLoginSina) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sinaButton];
    
    [sinaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qqButton.mas_right);
        make.right.equalTo(superview.mas_right).offset(1);
        make.bottom.equalTo(superview.mas_bottom);
        make.height.equalTo(@45);
    }];
}

- (UIButton *)makeButton:(UIImage *)icon title: (NSString *)title
{
    UIButton *loginButton = [[UIButton alloc] init];
    loginButton.backgroundColor = COLOR_MAIN_WHITE;
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = icon;
    [loginButton addSubview:iconView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(loginButton.mas_centerY);
        make.right.equalTo(loginButton.mas_centerX).offset(-20);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = COLOR_MAIN_DARK;
    titleLabel.font = FONT_MIDDLE;
    [loginButton addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton.mas_centerX).offset(-16);
        make.centerY.equalTo(loginButton.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = COLOR_MAIN_BG;
    [loginButton addSubview:sepView];
    
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginButton.mas_right);
        make.centerY.equalTo(loginButton.mas_centerY);
        make.width.equalTo(@1);
        make.height.equalTo(@20);
    }];
    
    return loginButton;
}

- (void)actionLogin
{
    [mobileField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    //记录用户信息
    UserEntity *user = [[UserEntity alloc] init];
    user.mobile = mobileField.text;
    user.password = passwordField.text;
    
    [self.delegate actionLogin:user];
}

- (void)actionLoginWechat
{
    [self.delegate actionLoginWechat];
}

- (void)actionLoginQQ
{
    [self.delegate actionLoginQQ];
}

- (void)actionLoginSina
{
    [self.delegate actionLoginSina];
}

- (void)actionFindPwd
{
    [self.delegate actionFindPwd];
}

@end
