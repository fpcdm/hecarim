//
//  CaseFormView.m
//  LttMember
//
//  Created by wuyong on 15/7/14.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseFormView.h"

@interface CaseFormView () <UITextViewDelegate>

@end

@implementation CaseFormView
{
    UILabel *addressLabel;
    UIView *addressBorder;
    UILabel *contactLabel;
    UITextView *remarkTextView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //表单视图
    UIView *formView = [[UIView alloc] init];
    formView.backgroundColor = COLOR_MAIN_WHITE;
    formView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    formView.layer.borderWidth = 0.5f;
    formView.layer.cornerRadius = 5.0f;
    [self addSubview:formView];
    
    int padding = 10;
    
    UIView *superview = self;
    [formView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(20);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.height.equalTo(@160);
    }];
    
    //选择地址事件
    UIButton *formButton = [[UIButton alloc] init];
    formButton.backgroundColor = COLOR_MAIN_CLEAR;
    [formButton addTarget:self action:@selector(actionAddress) forControlEvents:UIControlEventTouchUpInside];
    [formView addSubview:formButton];
    
    [formButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(formView.mas_top);
        make.left.equalTo(formView.mas_left);
        make.right.equalTo(formView.mas_right);
        make.height.equalTo(@80);
    }];
    
    //地址图标
    UIImageView *addressIcon = [[UIImageView alloc] init];
    addressIcon.image = [UIImage imageNamed:@"caseAddress"];
    [formView addSubview:addressIcon];
    
    superview = formView;
    [addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.width.equalTo(@12);
        make.height.equalTo(@20);
    }];
    
    //服务地址
    UIScrollView *addressView = [[UIScrollView alloc] init];
    addressView.showsHorizontalScrollIndicator = NO;
    addressView.showsVerticalScrollIndicator = NO;
    [formView addSubview:addressView];
    
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(addressIcon.mas_right).offset(10);
        make.right.equalTo(superview.mas_right).offset(-30);
        make.height.equalTo(@20);
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionAddress)];
    [addressView addGestureRecognizer:gesture];
    
    //地址文本
    addressLabel = [[UILabel alloc] init];
    addressLabel.font = FONT_MIDDLE;
    [addressView addSubview:addressLabel];
    
    superview = addressView;
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(superview.mas_height);
    }];
    
    //分割线
    addressBorder = [[UIView alloc] init];
    addressBorder.backgroundColor = COLOR_MAIN_BORDER;
    [self addSubview:addressBorder];
    
    superview = formView;
    [addressBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(39.5);
        make.left.equalTo(superview.mas_left).offset(32);
        make.right.equalTo(superview.mas_right).offset(-30);
        make.height.equalTo(@0.5);
    }];
    
    //联系人文本
    contactLabel = [[UILabel alloc] init];
    contactLabel.font = FONT_MIDDLE_BOLD;
    [formView addSubview:contactLabel];
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressBorder.mas_bottom).offset(padding);
        make.left.equalTo(addressIcon.mas_right).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@20);
    }];
    
    //选择地址图标
    UIImageView *chooseIcon = [[UIImageView alloc] init];
    chooseIcon.image = [UIImage imageNamed:@"chooseAddress"];
    [formView addSubview:chooseIcon];
    
    [chooseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview.mas_right).offset(-15);
        make.centerY.equalTo(superview.mas_top).offset(40);
        
        make.width.equalTo(@10);
        make.height.equalTo(@20);
    }];
    
    //分割线
    UIView *contactBorder = [[UIView alloc] init];
    contactBorder.backgroundColor = COLOR_MAIN_BORDER;
    [self addSubview:contactBorder];
    
    [contactBorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressBorder.mas_bottom).offset(39.5);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    //留言图标
    UIImageView *remarkIcon = [[UIImageView alloc] init];
    remarkIcon.image = [UIImage imageNamed:@"caseRemark"];
    [formView addSubview:remarkIcon];
    
    [remarkIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactBorder.mas_bottom).offset(padding + 5);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.width.equalTo(@14);
        make.height.equalTo(@14);
    }];
    
    //输入框
    remarkTextView = [[UITextView alloc] init];
    remarkTextView.placeholder = @"给为您服务的工作人员留言";
    remarkTextView.font = FONT_MIDDLE;
    remarkTextView.delegate = self;
    remarkTextView.contentInset = UIEdgeInsetsMake(-5, -5, 0, 0);
    [formView addSubview:remarkTextView];
    
    superview = formView;
    [remarkTextView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(90);
        make.left.equalTo(remarkIcon.mas_right).offset(padding - 2);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.bottom.equalTo(superview.mas_bottom).offset(-10);
    }];
    
    //关闭键盘Toolbar
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [keyboardToolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)];
    NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    
    [keyboardToolbar setItems:buttonsArray];
    [remarkTextView setInputAccessoryView:keyboardToolbar];
    
    //呼叫按钮
    UIButton *button = [AppUIUtil makeButton:@"呼叫"];
    [button addTarget:self action:@selector(actionSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    superview = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(formView.mas_bottom).offset(20);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    return self;
}

#pragma mark - RenderData
- (void) renderData
{
    NSString *name = [self getData:@"name"];
    if (!name) name = @"";
    NSString *mobile = [self getData:@"mobile"];
    NSString *address = [self getData:@"address"];
    
    //显示联系人
    contactLabel.text = [NSString stringWithFormat:@"%@  %@", name, mobile];
    
    //是否有地址
    if (address) {
        contactLabel.hidden = NO;
        addressBorder.hidden = NO;
        addressLabel.text = address;
        addressLabel.textColor = [UIColor blackColor];
    } else {
        contactLabel.hidden = YES;
        addressBorder.hidden = YES;
        addressLabel.text = @"请选择服务地址";
        addressLabel.textColor = [UIColor redColor];
    }
}

#pragma mark - TextView
- (void)dismissKeyboard
{
    [remarkTextView resignFirstResponder];
}

#pragma mark - Action
- (void) actionAddress
{
    [self.delegate actionAddress];
}

- (void) actionSubmit
{
    [self.delegate actionSubmit:remarkTextView.text];
}

@end