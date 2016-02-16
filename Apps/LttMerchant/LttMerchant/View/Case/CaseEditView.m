//
//  CaseEditView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/3.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CaseEditView.h"
#import "CaseEntity.h"

@implementation CaseEditView
{
    UILabel *caseNo;
    UILabel *statusName;
    UILabel *timeLabel;
    UILabel *totalLabel;
    UITextView *caseRemark;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    int padding = 10;
    
    //顶部视图
    UIView *caseView = [UIView new];
    caseView.backgroundColor = [UIColor colorWithHexString:@"8ed1f3"];
    [self addSubview:caseView];
    
    [caseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@80);
    }];
    
    //图片
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_icon_white"]];
    [caseView addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseView.mas_top).offset(padding);
        make.left.equalTo(caseView.mas_left).offset(padding);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    //编号
    UILabel *caseNoLabel = [[UILabel alloc] init];
    caseNoLabel.text = @"编号:";
    caseNoLabel.textColor = COLOR_MAIN_WHITE;
    caseNoLabel.font = FONT_MAIN;
    [caseView addSubview:caseNoLabel];
    
    [caseNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseView.mas_top).offset(padding);
        make.left.equalTo(image.mas_right).offset(padding);
        make.height.equalTo(@20);
    }];
    //编号NO
    caseNo = [[UILabel alloc] init];
    caseNo.textColor = COLOR_MAIN_WHITE;
    caseNo.font = FONT_MAIN;
    [caseView addSubview:caseNo];
    
    [caseNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseView.mas_top).offset(padding);
        make.left.equalTo(caseNoLabel.mas_right).offset(padding);
        make.height.equalTo(@20);
    }];
    
    //状态
    statusName = [[UILabel alloc] init];
    statusName.textColor = COLOR_MAIN_WHITE;
    statusName.font = FONT_MAIN;
    [caseView addSubview:statusName];
    
    [statusName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseView.mas_top).offset(padding);
        make.right.equalTo(caseView.mas_right).offset(-padding);
        make.height.equalTo(@20);
    }];
    
    //时间
    timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = COLOR_MAIN_WHITE;
    timeLabel.font = FONT_MIDDLE;
    [caseView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseNoLabel.mas_bottom);
        make.left.equalTo(image.mas_right).offset(padding);
        make.height.equalTo(@20);
    }];
    
    //总金额
    UILabel *totalName = [[UILabel alloc] init];
    totalName.text = @"总金额:";
    totalName.textColor = COLOR_MAIN_WHITE;
    totalName.font = FONT_MAIN;
    [caseView addSubview:totalName];
    
    [totalName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom);
        make.left.equalTo(image.mas_right).offset(padding);
    }];
    //总金额价格
    totalLabel = [[UILabel alloc] init];
    totalLabel.textColor = COLOR_MAIN_WHITE;
    totalLabel.font = FONT_MAIN;
    [caseView addSubview:totalLabel];

    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom);
        make.left.equalTo(totalName.mas_right).offset(padding);
    }];

    //大文本输入框
    caseRemark = [[UITextView alloc] init];
    caseRemark.placeholder = @"备注";
    caseRemark.textColor = COLOR_MAIN_BLACK;
    caseRemark.font = FONT_MAIN;
    caseRemark.layer.borderWidth = 0.5f;
    caseRemark.layer.borderColor = CGCOLOR_MAIN_BORDER;
    caseRemark.layer.cornerRadius = 3.0f;
    [self addSubview:caseRemark];
    
    [caseRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@160);
    }];
    
    //按钮
    UIButton *button = [AppUIUtil makeButton:@"保存"];
    [button addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseRemark.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    //关闭键盘Toolbar
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    [keyboardToolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard)];
    NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, doneButton, nil];
    
    [keyboardToolbar setItems:buttonsArray];
    [caseRemark setInputAccessoryView:keyboardToolbar];

    return self;
}

#pragma mark - TextView
- (void)dismissKeyboard
{
    [caseRemark resignFirstResponder];
}

- (void)display
{
    CaseEntity *caseEntity = [self fetch:@"caseEntity"];
    caseNo.text = caseEntity.no;
    statusName.text = [caseEntity statusName];
    timeLabel.text = caseEntity.createTime;
    totalLabel.text = caseEntity.totalAmount && [caseEntity.totalAmount floatValue] > 0.0 ? [NSString stringWithFormat:@"￥%.2f", [caseEntity.totalAmount floatValue]] : @"-";
}

- (void)actionSave
{
    [self.delegate actionSave:caseRemark.text];
}

@end
