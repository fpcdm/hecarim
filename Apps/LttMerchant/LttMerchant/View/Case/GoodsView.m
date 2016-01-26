//
//  GoodsView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/18.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "GoodsView.h"
#import "CaseEntity.h"

@implementation GoodsView
{
    UILabel *caseNo;
    UILabel *statusName;
    UIButton *button;
    UIButton *backBtn;
    UIView *buttomView;
    DLRadioButton *radio;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self;
    int padding = 10;
    
    //顶部编号视图
    UIView *caseView = [[UIView alloc] init];
    caseView.backgroundColor = [UIColor colorWithHexString:@"8ed1f3"];
    [self addSubview:caseView];
    
    [caseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@50);
    }];
    //图片视图
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_icon_white"]];
    [caseView addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(caseView.mas_centerY);
        make.left.equalTo(caseView.mas_left).offset(padding);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    //编号名称
    UILabel *caseNoLabel = [[UILabel alloc] init];
    caseNoLabel.text = @"编号：";
    caseNoLabel.textColor = COLOR_MAIN_WHITE;
    caseNoLabel.font = FONT_MAIN;
    [caseView addSubview:caseNoLabel];
    
    [caseNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(caseView.mas_centerY);
        make.left.equalTo(image.mas_right).offset(padding);
    }];
    //编号内容
    caseNo = [[UILabel alloc] init];
    caseNo.textColor = COLOR_MAIN_WHITE;
    caseNo.font = FONT_MAIN;
    [caseView addSubview:caseNo];
    
    [caseNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(caseView.mas_centerY);
        make.left.equalTo(caseNoLabel.mas_right);
    }];
    //订单状态
    statusName = [[UILabel alloc] init];
    statusName.textColor = COLOR_MAIN_WHITE;
    statusName.font = FONT_MAIN;
    [caseView addSubview:statusName];
    
    [statusName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(caseView.mas_centerY);
        make.right.equalTo(caseView.mas_right).offset(-padding);
    }];
    
    //按钮
    button = [AppUIUtil makeButton:@"添加商品"];
    button.titleLabel.font = FONT_MAIN;
    [button addTarget:self action:@selector(actionAddGoods) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:COLOR_MAIN_WHITE forState:UIControlStateNormal];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.bottom.equalTo(superView.mas_bottom).offset(-95);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    //返回按钮
    backBtn = [AppUIUtil makeButton:@"返回详情"];
    backBtn.titleLabel.font = FONT_MAIN;
    [backBtn addTarget:self action:@selector(actionBackList) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitleColor:COLOR_MAIN_WHITE forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(10);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    //全选和删除视图
    buttomView = [[UIView alloc] init];
    buttomView.backgroundColor = COLOR_MAIN_WHITE;
    buttomView.layer.borderWidth = 0.5f;
    buttomView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    buttomView.hidden = YES;
    [self addSubview:buttomView];
    
    [buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.bottom.equalTo(superView.mas_bottom).offset(0.5);
        make.height.equalTo(@70);
    }];
    //全选按钮
    radio = [[DLRadioButton alloc] init];
    radio.iconColor = [UIColor colorWithHexString:@"CBCBCB"];
    radio.iconSize = 18;
    radio.iconStrokeWidth = 1.0f;
    radio.titleLabel.font = FONT_MAIN;
    [radio setTitle:@"全选" forState:UIControlStateNormal];
    [radio setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [radio addTarget:self action:@selector(actionChooseAll) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:radio];
    
    [radio mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(buttomView.mas_left).offset(padding);
        make.top.equalTo(buttomView.mas_top).offset(padding);
        make.width.equalTo(@60);
    }];
    //删除按钮
    UIButton *deleteBtn = [[UIButton alloc] init];
    deleteBtn.layer.borderWidth = 0.5f;
    deleteBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
    deleteBtn.layer.cornerRadius = 3.0f;
    deleteBtn.backgroundColor = COLOR_MAIN_WHITE;
    deleteBtn.titleLabel.font = FONT_MAIN;
    [deleteBtn addTarget:self action:@selector(actionDeleteGoods) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [buttomView addSubview:deleteBtn];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buttomView.mas_top).offset(padding);
        make.right.equalTo(buttomView.mas_right).offset(-padding);
        make.width.equalTo(@50);
        make.height.equalTo(@22);
    }];
    
    self.listView = [[GoodsListView alloc] init];
    self.listView.backgroundColor = COLOR_MAIN_WHITE;
    [self addSubview:self.listView];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.bottom.equalTo(button.mas_top).offset(-padding);
    }];
    
    return self;
}

- (void)setCaseNo
{
    CaseEntity *caseEntity = [self fetch:@"caseEntity"];
    caseNo.text = caseEntity.no;
    statusName.text = [caseEntity statusName];
}

- (void)display
{
    [self.listView assign:@"goodsList" value:[self fetch:@"goodsList"]];
    [self.listView display];
}

//添加商品
- (void)actionAddGoods
{
    [self.delegate actionAddGoods];
}

//显示或隐藏添加、全选、删除
- (void)setButtonAndButtomShowHide:(BOOL)type
{
    if (type) {
        button.hidden = YES;
        backBtn.hidden = YES;
        buttomView.hidden = NO;
    } else {
        button.hidden = NO;
        backBtn.hidden = NO;
        buttomView.hidden = YES;
    }
}

//全选按钮
- (void)actionChooseAll
{
    [self.delegate actionChooseAll:radio];
}

//删除商品
- (void)actionDeleteGoods
{
    [self.delegate actionDeleteGoods:radio];
}

- (void)actionBackList
{
    [self.delegate actionBackList];
}

@end
