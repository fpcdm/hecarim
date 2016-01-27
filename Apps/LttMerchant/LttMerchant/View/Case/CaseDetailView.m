//
//  CaseDetailView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/19.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CaseDetailView.h"
#import "CaseEntity.h"
#import "GoodsContainerView.h"
#import "ServicesContainerView.h"
#import <CoreText/CoreText.h>

@implementation CaseDetailView
{
    CaseEntity *intention;
    GoodsContainerView *goodsList;
    ServicesContainerView *servicesList;
    PaymentView *paymentView;
    
    UIView *caseHeaderView;
    UIView *serviceView;
    UIView *goodsListView;
    UIView *servicesListView;
    UIView *payContainer;
    
    int padding;
    UILabel *caseNo;
    UILabel *statusName;
    UILabel *caseTime;
    UILabel *totalAmount;
    UILabel *userLabel;
    UIView *remarkView;
    UITextView *remarkTextView;
    
    UILabel *nameLabel;
    UILabel *addressLabel;
    UILabel *goodsAmountLabel;
    UILabel *goodsTotalLabel;
    UILabel *servicesAmountLabel;

    UIButton *userButton;
    UIButton *editGoods;
    UIButton *editServices;
    UIButton *mobileButton;
    
    //消费记录
    UIButton *recordBtn;
    //编辑按钮
    UIButton *editCase;
    //接单
    UIButton *competeButton;
    //开始服务
    UIButton *startButton;
    //完成服务
    UIButton *finishButton;
    //取消订单
    UIButton *cancelButton;
    
    CGFloat height;
    CGFloat servicesHeight;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    UIView *superView = self.contentView;
    padding = 10;
    
    //顶部视图
    caseHeaderView = [[UIView alloc] init];
    caseHeaderView.backgroundColor = [UIColor colorWithHexString:@"8ed1f3"];
    [self.contentView addSubview:caseHeaderView];
    
    [caseHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@80);
    }];
    //图片视图
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_icon_white"]];
    [caseHeaderView addSubview:image];
    
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseHeaderView.mas_top).offset(padding);
        make.left.equalTo(caseHeaderView.mas_left).offset(padding);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    //编号名称
    UILabel *caseNoLabel = [[UILabel alloc] init];
    caseNoLabel.text = @"编号：";
    caseNoLabel.textColor = COLOR_MAIN_WHITE;
    caseNoLabel.font = FONT_MAIN;
    [caseHeaderView addSubview:caseNoLabel];
    
    [caseNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseHeaderView.mas_top).offset(padding);
        make.left.equalTo(image.mas_right).offset(padding);
        make.height.equalTo(@20);
    }];
    
    //编号内容
    caseNo = [[UILabel alloc] init];
    caseNo.text = @"-";
    caseNo.textColor = COLOR_MAIN_WHITE;
    caseNo.font = FONT_MAIN;
    [caseHeaderView addSubview:caseNo];
    
    [caseNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseHeaderView.mas_top).offset(padding);
        make.left.equalTo(caseNoLabel.mas_right);
    }];
    
    //服务单状态
    statusName = [[UILabel alloc] init];
    statusName.text = @"-";
    statusName.textColor = COLOR_MAIN_WHITE;
    statusName.font = FONT_MAIN;
    [caseHeaderView addSubview:statusName];
    
    [statusName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseHeaderView.mas_top).offset(padding);
        make.right.equalTo(caseHeaderView.mas_right).offset(-padding);
    }];
    
    //服务单时间
    caseTime = [[UILabel alloc] init];
    caseTime.text = @"-";
    caseTime.textColor = COLOR_MAIN_WHITE;
    caseTime.font = FONT_MAIN;
    [caseHeaderView addSubview:caseTime];
    
    [caseTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseNoLabel.mas_bottom);
        make.left.equalTo(caseNoLabel.mas_left);
        make.height.equalTo(@20);
    }];
    
    //总金额名称
    UILabel *totalAmountLabel = [[UILabel alloc] init];
    totalAmountLabel.text = @"总金额：";
    totalAmountLabel.textColor = COLOR_MAIN_WHITE;
    totalAmountLabel.font = FONT_MAIN;
    [caseHeaderView addSubview:totalAmountLabel];
    
    [totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseTime.mas_bottom);
        make.left.equalTo(caseNoLabel.mas_left);
    }];
    
    //总金额
    totalAmount = [[UILabel alloc] init];
    totalAmount.text = @"-";
    totalAmount.textColor = COLOR_MAIN_WHITE;
    totalAmount.font = FONT_MAIN;
    [caseHeaderView addSubview:totalAmount];
    
    [totalAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseTime.mas_bottom);
        make.left.equalTo(totalAmountLabel.mas_right);
    }];
    
    //编辑按钮
    editCase = [[UIButton alloc] init];
    editCase.hidden = YES;
    editCase.layer.borderWidth = 0.5f;
    editCase.layer.borderColor = CGCOLOR_MAIN_BORDER;
    editCase.layer.cornerRadius = 3.0f;
    editCase.titleLabel.font = FONT_MIDDLE;
    editCase.backgroundColor = COLOR_MAIN_WHITE;
    [editCase addTarget:self action:@selector(actionEditCase) forControlEvents:UIControlEventTouchUpInside];
    [editCase setTitle:@"编辑" forState:UIControlStateNormal];
    [editCase setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [caseHeaderView addSubview:editCase];
    
    [editCase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(caseHeaderView.mas_right).offset(-padding);
        make.bottom.equalTo(totalAmountLabel.mas_bottom);
        make.width.equalTo(@50);
        make.height.equalTo(@22);
    }];
    
    
    //服务视图
    serviceView = [[UIView alloc] init];
    serviceView.layer.borderWidth = 0.5f;
    serviceView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    serviceView.backgroundColor = COLOR_MAIN_WHITE;
    [self.contentView addSubview:serviceView];
    
    [serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(caseHeaderView.mas_bottom);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@232);
    }];
    
    //图片视图
    UIImageView *serviceImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_icon"]];
    [serviceView addSubview:serviceImg];
    
    [serviceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceView.mas_top).offset(padding);
        make.left.equalTo(serviceView.mas_left).offset(padding);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    //下单人名称
    UILabel *caseNameLabel = [self makeLabel:@"下单人："];
    [serviceView addSubview:caseNameLabel];
    
    [caseNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(serviceView.mas_top).offset(padding);
        make.left.equalTo(serviceImg.mas_right).offset(padding);
        make.width.equalTo(@64);
        make.height.equalTo(@16);
    }];
    
    //称谓
    userLabel = [self makeLabel:@"-"];
    [serviceView addSubview:userLabel];
    
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(caseNameLabel.mas_bottom).offset(padding);
        make.left.equalTo(caseNameLabel.mas_left);
        make.height.equalTo(@16);
    }];
    
    //下单人信息
    userButton = [[UIButton alloc] init];
    userButton.backgroundColor = [UIColor clearColor];
    userButton.titleLabel.font = FONT_MAIN;
    [userButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(actionContactUser) forControlEvents:UIControlEventTouchUpInside];
    [serviceView addSubview:userButton];
    
    [userButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(userLabel.mas_top);
        make.left.equalTo(userLabel.mas_right).offset(2);
        make.height.equalTo(@16);
    }];
    
    //服务联系人
    UILabel *nameTitle = [self makeLabel:@"服务联系人："];
    [serviceView addSubview:nameTitle];
    
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLabel.mas_bottom).offset(9);
        make.left.equalTo(caseNameLabel.mas_left);
        make.width.equalTo(@96);
        make.height.equalTo(@16);
    }];
    
    //姓名
    nameLabel = [self makeLabel:@"-"];
    [serviceView addSubview:nameLabel];
    
    [nameLabel sizeToFit];
    CGFloat nameWidth = nameLabel.frame.size.width;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTitle.mas_bottom).offset(padding);
        make.left.equalTo(nameTitle.mas_left);
        make.width.equalTo([NSNumber numberWithFloat:nameWidth]);
        make.height.equalTo(@16);
    }];
    
    //电话
    mobileButton = [[UIButton alloc] init];
    mobileButton.backgroundColor = [UIColor clearColor];
    mobileButton.titleLabel.font = FONT_MAIN;
    [mobileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mobileButton addTarget:self action:@selector(actionContactBuyer) forControlEvents:UIControlEventTouchUpInside];
    [serviceView addSubview:mobileButton];
    
    [mobileButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(nameLabel.mas_top);
        make.left.equalTo(nameLabel.mas_right);
        make.height.equalTo(@16);
    }];
    
    //服务地址
    addressLabel = [self makeLabel:@"服务地址：-"];
    addressLabel.textColor = [UIColor colorWithHexString:@"585858"];
    addressLabel.font = FONT_MIDDLE;
    addressLabel.numberOfLines = 0;
    [serviceView addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom);
        make.left.equalTo(caseNameLabel.mas_left);
        make.right.equalTo(serviceView.mas_right).offset(-padding);
        make.height.equalTo(@40);
    }];
    
    //备注视图
    remarkView = [[UIView alloc] init];
    remarkView.backgroundColor = [UIColor clearColor];
    [serviceView addSubview:remarkView];
    
    [remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLabel.mas_bottom).offset(5);
        make.left.equalTo(serviceView.mas_left);
        make.right.equalTo(serviceView.mas_right);
        make.height.equalTo(@65);
    }];
    
    //客户留言
    UILabel *remarkTitle = [self makeLabel:@"客户留言："];
    [remarkView addSubview:remarkTitle];
    
    [remarkTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(remarkView.mas_top);
        make.left.equalTo(caseNameLabel.mas_left);
        make.height.equalTo(@16);
    }];
    
    //需求备注
    remarkTextView = [[UITextView alloc] init];
    remarkTextView.textColor = [UIColor colorWithHexString:@"585858"];
    remarkTextView.font = FONT_MIDDLE;
    remarkTextView.editable = NO;
    //内边距为0
    if (IS_IOS7_PLUS) {
        remarkTextView.textContainerInset = UIEdgeInsetsZero;
    }
    
    [remarkView addSubview:remarkTextView];
    remarkTextView.text = @"-";
    
    [remarkTextView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(remarkTitle.mas_bottom).offset(5);
        make.left.equalTo(caseNameLabel.mas_left);
        make.right.equalTo(remarkView.mas_right).offset(-padding);
        
        make.height.equalTo(@50);
    }];
    
    //消费记录
    recordBtn = [[UIButton alloc] init];
    recordBtn.hidden = YES;
    recordBtn.layer.borderWidth = 0.5f;
    recordBtn.layer.borderColor = CGCOLOR_MAIN_BORDER;
    recordBtn.backgroundColor = COLOR_MAIN_WHITE;
    [recordBtn addTarget:self action:@selector(actionConsumeHistory) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:recordBtn];
    
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@45);
    }];
    
    //消费记录名称
    UILabel *recodeLabel = [[UILabel alloc] init];
    recodeLabel.text = @"消费记录";
    recodeLabel.textColor = COLOR_MAIN_BLACK;
    recodeLabel.font = FONT_MAIN;
    [recordBtn addSubview:recodeLabel];
    
    [recodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(recordBtn.mas_centerY);
        make.left.equalTo(recordBtn.mas_left).offset(padding);
    }];
    //箭头
    UILabel *arrowLabel = [[UILabel alloc] init];
    arrowLabel.text = @">";
    arrowLabel.textColor = COLOR_MAIN_GRAY;
    arrowLabel.font = [UIFont systemFontOfSize:20];
    [recordBtn addSubview:arrowLabel];
    
    [arrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(recordBtn.mas_centerY);
        make.right.equalTo(recordBtn.mas_right).offset(-padding);
    }];
    
    
    //商品列表视图
    goodsListView = [[UIView alloc] init];
    goodsListView.hidden = YES;
    goodsListView.layer.borderWidth = 0.5f;
    goodsListView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    goodsListView.backgroundColor = COLOR_MAIN_WHITE;
    [self.contentView addSubview:goodsListView];
    
    [goodsListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recordBtn.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@95);
    }];
    
    UIView *goodsHeaderView = [[UIView alloc] init];
    goodsHeaderView.backgroundColor = COLOR_MAIN_WHITE;
    [goodsListView addSubview:goodsHeaderView];
    
    [goodsHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsListView.mas_top);
        make.left.equalTo(goodsListView.mas_left);
        make.right.equalTo(goodsListView.mas_right);
        make.height.equalTo(@35);
    }];
    
    UILabel *goodsNameLabel = [[UILabel alloc] init];
    goodsNameLabel.text = @"商品";
    goodsNameLabel.textColor = COLOR_MAIN_BLACK;
    goodsNameLabel.font = FONT_MAIN_BOLD;
    [goodsHeaderView addSubview:goodsNameLabel];
    
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodsHeaderView.mas_centerY);
        make.left.equalTo(goodsHeaderView.mas_left).offset(padding);
        make.height.equalTo(@25);
    }];
    
    editGoods = [[UIButton alloc] init];
    editGoods.layer.borderWidth = 0.5f;
    editGoods.layer.borderColor = [UIColor colorWithHexString:@"0199FF"].CGColor;
    editGoods.layer.cornerRadius = 3.0f;
    editGoods.backgroundColor = [UIColor colorWithHexString:@"0199FF"];
    editGoods.titleLabel.font = FONT_MIDDLE;
    [editGoods addTarget:self action:@selector(actionEditGoods) forControlEvents:UIControlEventTouchUpInside];
    [editGoods setTitle:@"选商品" forState:UIControlStateNormal];
    [editGoods setTitleColor:COLOR_MAIN_WHITE forState:UIControlStateNormal];
    [goodsHeaderView addSubview:editGoods];
    
    [editGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodsHeaderView.mas_centerY);
        make.left.equalTo(goodsNameLabel.mas_right);
        make.right.equalTo(goodsHeaderView.mas_right).offset(-padding);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    UIView *goodsFooterView = [[UIView alloc] init];
    goodsFooterView.backgroundColor = COLOR_MAIN_WHITE;
    [goodsListView addSubview:goodsFooterView];
    
    [goodsFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(goodsListView.mas_bottom);
        make.left.equalTo(goodsListView.mas_left);
        make.right.equalTo(goodsListView.mas_right);
        make.height.equalTo(@35);
    }];
    
    //商品金额小计
    goodsAmountLabel = [[UILabel alloc] init];
    goodsAmountLabel.text = @"小计金额：￥0.00";
    goodsAmountLabel.textColor = COLOR_MAIN_BLACK;
    goodsAmountLabel.font = FONT_MAIN;
    [goodsFooterView addSubview:goodsAmountLabel];
    
    [goodsAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodsFooterView.mas_centerY);
        make.right.equalTo(goodsFooterView.mas_right).offset(-padding);
        make.height.equalTo(@35);
    }];
    
    //商品数量小计
    goodsTotalLabel = [[UILabel alloc] init];
    goodsTotalLabel.text = @"共0件商品";
    goodsTotalLabel.textColor = COLOR_MAIN_BLACK;
    goodsTotalLabel.font = FONT_MAIN;
    [goodsFooterView addSubview:goodsTotalLabel];
    
    [goodsTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(goodsAmountLabel.mas_left).offset(-padding);
        make.centerY.equalTo(goodsFooterView.mas_centerY);
        make.height.equalTo(@35);
    }];
    
    //商品列表视图
    goodsList = [[GoodsContainerView alloc] init];
    [goodsListView addSubview:goodsList];
    
    [goodsList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsHeaderView.mas_bottom);
        make.left.equalTo(goodsListView.mas_left).offset(padding);
        make.bottom.equalTo(goodsFooterView.mas_top);
        make.right.equalTo(goodsListView.mas_right);
        make.height.equalTo(@50);
    }];
    
    
    //服务列表视图
    servicesListView = [[UIView alloc] init];
    servicesListView.hidden = YES;
    servicesListView.layer.borderWidth = 0.5f;
    servicesListView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    servicesListView.backgroundColor = COLOR_MAIN_WHITE;
    [self.contentView addSubview:servicesListView];
    
    [servicesListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsListView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(-0.5);
        make.right.equalTo(superView.mas_right).offset(0.5);
        make.height.equalTo(@95);
    }];
    
    UIView *servicesHeaderView = [[UIView alloc] init];
    servicesHeaderView.backgroundColor = COLOR_MAIN_WHITE;
    [servicesListView addSubview:servicesHeaderView];
    
    [servicesHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(servicesListView.mas_top);
        make.left.equalTo(servicesListView.mas_left);
        make.right.equalTo(servicesListView.mas_right);
        make.height.equalTo(@35);
    }];
    
    UILabel *servicesNameLabel = [[UILabel alloc] init];
    servicesNameLabel.text = @"上门服务";
    servicesNameLabel.textColor = COLOR_MAIN_BLACK;
    servicesNameLabel.font = FONT_MAIN_BOLD;
    [servicesHeaderView addSubview:servicesNameLabel];
    
    [servicesNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(servicesHeaderView.mas_centerY);
        make.left.equalTo(servicesHeaderView.mas_left).offset(padding);
        make.height.equalTo(@25);
    }];
    
    editServices = [[UIButton alloc] init];
    editServices.layer.borderWidth = 0.5f;
    editServices.layer.borderColor = [UIColor colorWithHexString:@"0199FF"].CGColor;
    editServices.layer.cornerRadius = 3.0f;
    editServices.backgroundColor = [UIColor colorWithHexString:@"0199FF"];
    editServices.titleLabel.font = FONT_MIDDLE;
    editServices.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    [editServices addTarget:self action:@selector(actionEditServices) forControlEvents:UIControlEventTouchUpInside];
    [editServices setTitle:@"下订单" forState:UIControlStateNormal];
    [editServices setTitleColor:COLOR_MAIN_WHITE forState:UIControlStateNormal];
    [servicesHeaderView addSubview:editServices];
    
    [editServices mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(servicesHeaderView.mas_centerY);
        make.right.equalTo(servicesHeaderView.mas_right).offset(-padding);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    //商品金额小计
    servicesAmountLabel = [[UILabel alloc] init];
    servicesAmountLabel.text = @"小计金额：￥0.00";
    servicesAmountLabel.textColor = COLOR_MAIN_BLACK;
    servicesAmountLabel.font = FONT_MAIN;
    [servicesListView addSubview:servicesAmountLabel];
    
    [servicesAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(servicesListView.mas_right).offset(-padding);
        make.bottom.equalTo(servicesListView.mas_bottom);
        make.height.equalTo(@35);
    }];
    
    //服务列表
    servicesList = [[ServicesContainerView alloc] init];
    [servicesListView addSubview:servicesList];
    
    [servicesList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(servicesHeaderView.mas_bottom);
        make.left.equalTo(servicesListView.mas_left).offset(padding);
        make.bottom.equalTo(servicesAmountLabel.mas_top);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@25);
    }];
    
    //接单按钮
    competeButton = [AppUIUtil makeButton:@"接单"];
    competeButton.hidden = YES;
    [competeButton addTarget:self action:@selector(actionCompeteCase) forControlEvents:UIControlEventTouchUpInside];
    [competeButton setTitleColor:COLOR_MAIN_WHITE forState:UIControlStateNormal];
    [self.contentView addSubview:competeButton];
    
    [competeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recordBtn.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithFloat:HEIGHT_MAIN_BUTTON]);
    }];
    
    //开始服务
    startButton = [AppUIUtil makeButton:@"开始服务"];
    startButton.hidden = YES;
    [startButton addTarget:self action:@selector(actionStartCase) forControlEvents:UIControlEventTouchUpInside];
    [startButton setTitleColor:COLOR_MAIN_WHITE forState:UIControlStateNormal];
    [self.contentView addSubview:startButton];
    
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(servicesListView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithFloat:HEIGHT_MAIN_BUTTON]);
    }];
    
    //完成服务
    finishButton = [AppUIUtil makeButton:@"完成服务"];
    finishButton.hidden = YES;
    [finishButton addTarget:self action:@selector(actionFinishCase) forControlEvents:UIControlEventTouchUpInside];
    [finishButton setTitleColor:COLOR_MAIN_WHITE forState:UIControlStateNormal];
    [self.contentView addSubview:finishButton];
    
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(servicesListView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithFloat:HEIGHT_MAIN_BUTTON]);
    }];
    
    //取消服务
    cancelButton = [AppUIUtil makeButton:@"取消订单"];
    cancelButton.hidden = YES;
    cancelButton.backgroundColor = COLOR_MAIN_WHITE;
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    [cancelButton addTarget:self action:@selector(actionCancelCase) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [self.contentView addSubview:cancelButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startButton.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithFloat:HEIGHT_MAIN_BUTTON]);
    }];
    
    //支付列表视图
    payContainer = [[UIView alloc] init];
    payContainer.hidden = YES;
    [self addSubview:payContainer];
    
    [payContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceView.mas_bottom);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@225);
    }];
    
    self.img = [[UIImageView alloc] init];
    self.img.hidden = YES;
    self.contentSize = CGSizeMake(SCREEN_WIDTH, 500);
    return self;
}

- (void)setCase
{
    intention = [self fetch:@"intention"];
    caseNo.text = intention.no;
    statusName.text = [intention statusName];
    caseTime.text = intention.createTime;
    totalAmount.text = [NSString stringWithFormat:@"%@",![@0 isEqualToNumber:intention.totalAmount] ? [NSString stringWithFormat:@"￥%.2f", (intention.totalAmount ? [intention.totalAmount floatValue] : 0.00)] : @"-"];
    
    //下单人
    userLabel.text = intention.userAppellation;
    [userLabel sizeToFit];
    CGFloat userWidth = userLabel.frame.size.width;
    [userLabel mas_updateConstraints:^(MASConstraintMaker *make){
        make.width.equalTo([NSNumber numberWithFloat:userWidth]);
    }];
    
    //下单人电话数字
    NSString *userName = intention.userName ? intention.userName : @"-";
    NSString *userMobile;
    if (intention.userAppellation == nil || intention.userAppellation.length < 1) {
        userMobile = [NSString stringWithFormat:@"%@ (%@)", userName, intention.userMobile ? intention.userMobile : @"-"];
        
        NSMutableAttributedString *userStr = [[NSMutableAttributedString alloc]initWithString:userMobile];
        NSRange userRange = {2 + [userName length],[userStr length] - 3 - [userName length]};
        [userStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:userRange];
        [userButton setAttributedTitle:userStr forState:UIControlStateNormal];
    } else {
        userMobile = [NSString stringWithFormat:@"(%@ %@)", userName, intention.userMobile ? intention.userMobile : @"-"];
        
        NSMutableAttributedString *userStr = [[NSMutableAttributedString alloc]initWithString:userMobile];
        NSRange userRange = {2 + [userName length],[userStr length] - 3 - [userName length]};
        [userStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:userRange];
        [userButton setAttributedTitle:userStr forState:UIControlStateNormal];
    }
    
    //服务联系人
    nameLabel.text = intention.buyerName;
    [nameLabel sizeToFit];
    CGFloat nameWidth = nameLabel.frame.size.width;
    [nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithFloat:nameWidth]);
    }];
    
    //电话号码数字
    NSString *buyerMobile = [NSString stringWithFormat:@" (%@)", intention.buyerMobile];
    NSMutableAttributedString *mobileStr = [[NSMutableAttributedString alloc]initWithString:buyerMobile];
    NSRange contentRange = {2,[mobileStr length] - 3};
    [mobileStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [mobileButton setAttributedTitle:mobileStr forState:UIControlStateNormal];
    
    addressLabel.text = [NSString stringWithFormat:@"服务地址：%@",intention.buyerAddress];
    
    NSString *customerRemark = [NSString stringWithFormat:@"%@(%@%@)",
                                intention.customerRemark ? intention.customerRemark : @"",
                                intention.typeName ? intention.typeName : @"",
                                intention.propertyName && [intention.propertyName length] > 0 ? [NSString stringWithFormat:@"-%@", intention.propertyName] : @""
                                ];
    remarkTextView.text = customerRemark;
    
    
    //商品
    NSDictionary *goodsInfo = [self fetch:@"goodsInfo"];
    NSString *goodsAmount = [NSString stringWithFormat:@"%@",goodsInfo[@"goodsAmount"]];
    NSString *goodsAmountStr = [NSString stringWithFormat:@"小计金额：%@",goodsAmount];
    NSMutableAttributedString *goodsAmountAttr = [[NSMutableAttributedString alloc] initWithString:goodsAmountStr];
    [goodsAmountAttr addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)FONT_MAIN_BOLD.fontName,
                                                                        FONT_MAIN_BOLD.pointSize,
                                                                        NULL))
                       range:NSMakeRange(5, [goodsAmount length])];

    goodsAmountLabel.attributedText = goodsAmountAttr;

    
    NSString *goodsNumber = [NSString stringWithFormat:@"%@",goodsInfo[@"goodsNumber"]];
    NSString *goodsTotalStr = [NSString stringWithFormat:@"共%@件商品",goodsNumber];
    NSMutableAttributedString *goodsTotalAttr = [[NSMutableAttributedString alloc] initWithString:goodsTotalStr];
    [goodsTotalAttr addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)FONT_MAIN_BOLD.fontName,
                                                      FONT_MAIN_BOLD.pointSize,
                                                      NULL))
                       range:NSMakeRange(1, [goodsNumber length])];

    goodsTotalLabel.attributedText = goodsTotalAttr;
    
    NSDictionary *servicesInfo = [self fetch:@"servicesInfo"];
    NSString *servicesAmount = [NSString stringWithFormat:@"%@",servicesInfo[@"servicesAmount"]];
    NSString *servicesAmountStr = [NSString stringWithFormat:@"小计金额：%@",servicesAmount];
    NSMutableAttributedString *servicesAmountAttr = [[NSMutableAttributedString alloc] initWithString:servicesAmountStr];
    [servicesAmountAttr addAttribute:(NSString *)kCTFontAttributeName value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)FONT_MAIN_BOLD.fontName,
                                                                                                                       FONT_MAIN_BOLD.pointSize,
                                                                                                                       NULL)) range:NSMakeRange(5, [servicesAmount length])];
    servicesAmountLabel.attributedText = servicesAmountAttr;
}


- (void)display
{
    [self setCase];
    //商品列表
    NSMutableArray *goodsData = [self fetch:@"goodsList"];
    NSInteger count = [goodsData count];
    height = 95;
    if ([@"type" isEqualToString:goodsData[0][@"type"]]) {
        height = count * 50 + 70;
    }
    [goodsListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    //服务列表
    NSMutableArray *servicesData = [self fetch:@"servicesList"];
    NSInteger servicesCount = [servicesData count];
    servicesHeight = servicesCount * 25 + 70;
    [servicesListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(servicesHeight));
    }];
    [servicesList mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(servicesHeight - 70));
    }];
    
    //切换状态
    [self intentionStatusView];
    //获取商品列表
    [goodsList assign:@"goodsList" value:goodsData];
    [goodsList display];
    
    //获取服务列表
    [servicesList assign:@"servicesList" value:servicesData];
    [servicesList display];
}

//显示二维码
- (void)showImage
{
    self.img.hidden = NO;
    [paymentView.qrcodeView addSubview:self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(paymentView.qrcodeView.mas_top).offset(10);
        make.centerX.equalTo(paymentView.qrcodeView.mas_centerX);
        make.height.equalTo(@150);
        make.width.equalTo(@150);
    }];
    [payContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@225);
    }];
}

//切换按钮状态
- (void)intentionStatusView
{
    //待接单
    if ([CASE_STATUS_NEW isEqualToString:intention.status]) {
        //隐藏编辑按钮
        editCase.hidden = YES;
        
        //显示备注
        remarkView.hidden = NO;
        
        //显示消费记录
        recordBtn.hidden = NO;
        
        //隐藏商品列表
        goodsListView.hidden = YES;
        
        //隐藏服务列表
        servicesListView.hidden = YES;
        
        //隐藏支付视图
        payContainer.hidden = YES;
        
        //显示接单按钮
        competeButton.hidden = NO;
        
        //隐藏开始服务按钮
        startButton.hidden = YES;
        
        //隐藏完成服务按钮
        finishButton.hidden = YES;
        
        //隐藏取消按钮
        cancelButton.hidden = YES;
        
        //已接单
    } else if ([CASE_STATUS_LOCKED isEqualToString:intention.status]) {
        //隐藏编辑按钮
        editCase.hidden = YES;
        
        //显示备注
        remarkView.hidden = NO;
        
        //显示消费记录
        recordBtn.hidden = NO;
        
        //隐藏商品列表
        goodsListView.hidden = NO;
        
        //隐藏服务列表
        servicesListView.hidden = NO;
        
        //隐藏支付视图
        payContainer.hidden = YES;
        
        //显示接单按钮
        competeButton.hidden = YES;
        
        //隐藏开始服务按钮
        startButton.hidden = NO;
        
        //隐藏完成服务按钮
        finishButton.hidden = YES;
        
        //隐藏取消按钮
        cancelButton.hidden = NO;
        
        CGFloat viewHeight = 80 + 222 + 45 * 3 + height + servicesHeight + 10 * 6;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, viewHeight);
        
        //服务中
    } else if ([CASE_STATUS_CONFIRMED isEqualToString:intention.status]) {
        //隐藏编辑按钮
        editCase.hidden = YES;
        
        //显示备注
        remarkView.hidden = NO;
        
        //显示消费记录
        recordBtn.hidden = YES;
        
        //隐藏商品列表
        goodsListView.hidden = NO;
        
        //隐藏服务列表
        servicesListView.hidden = NO;
        
        //隐藏支付视图
        payContainer.hidden = YES;
        
        //显示接单按钮
        competeButton.hidden = YES;
        
        //隐藏开始服务按钮
        startButton.hidden = YES;
        
        //隐藏完成服务按钮
        finishButton.hidden = NO;
        
        //隐藏取消按钮
        cancelButton.hidden = NO;
        
        [self setGoodsListViewPosition];
        
        CGFloat viewHeight = 80 + 222 + height + servicesHeight + 10 * 5 + 45 * 2;
        NSLog(@"服务中视图高度是：%f",viewHeight);
        self.contentSize = CGSizeMake(SCREEN_WIDTH, viewHeight);
        
        //服务完成
    } else if ([CASE_STATUS_TOPAY isEqualToString:intention.status]) {
        //隐藏编辑按钮
        editCase.hidden = YES;
        
        //显示备注
        remarkView.hidden = YES;
        
        //显示消费记录
        recordBtn.hidden = YES;
        
        //隐藏商品列表
        goodsListView.hidden = YES;
        
        //隐藏服务列表
        servicesListView.hidden = YES;
        
        //隐藏支付视图
        payContainer.hidden = NO;
        
        //显示接单按钮
        competeButton.hidden = YES;
        
        //隐藏开始服务按钮
        startButton.hidden = YES;
        
        //隐藏完成服务按钮
        finishButton.hidden = YES;
        
        //隐藏取消按钮
        cancelButton.hidden = YES;
        
        CGFloat viewHeight = 80 + 222 - 65 + 10;
        
        [self setServiceViewHeight];
        NSArray *payment = [self fetch:@"payments"];
        if (payment.count > 0) {
            paymentView = [[PaymentView alloc] init];
            paymentView.delegate = self.delegate;
            [paymentView assign:@"payments" value:payment];
            [paymentView display];
            [payContainer addSubview:paymentView];
            
            [paymentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(payContainer.mas_top);
                make.left.equalTo(payContainer.mas_left);
                make.bottom.equalTo(payContainer.mas_bottom);
                make.right.equalTo(payContainer.mas_right);
            }];
            viewHeight = 80 + 222 - 65 + 225;
            self.contentSize = CGSizeMake(SCREEN_WIDTH, viewHeight);
        } else {
            self.contentSize = CGSizeMake(SCREEN_WIDTH, viewHeight);
        }
        //已支付
    } else if ([CASE_STATUS_PAYED isEqualToString:intention.status]) {
        //隐藏编辑按钮
        editCase.hidden = YES;
        
        //显示备注
        remarkView.hidden = YES;
        
        //显示消费记录
        recordBtn.hidden = YES;
        
        //隐藏商品列表
        goodsListView.hidden = NO;
        
        //隐藏编辑商品按钮
        editGoods.hidden = YES;
        
        //隐藏服务列表
        servicesListView.hidden = NO;
        
        //隐藏编辑服务按钮
        editServices.hidden = YES;
        
        //隐藏支付视图
        payContainer.hidden = YES;
        
        //显示接单按钮
        competeButton.hidden = YES;
        
        //隐藏开始服务按钮
        startButton.hidden = YES;
        
        //隐藏完成服务按钮
        finishButton.hidden = YES;
        
        //隐藏取消按钮
        cancelButton.hidden = YES;
        
        [self setGoodsListViewPosition];
        [self setServiceViewHeight];
        
        CGFloat viewHeight = 80 + 125 + height + servicesHeight + 10 + 42;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, viewHeight);
        
        NSLog(@"完成视图高度：%f",viewHeight);
        //已结束
    } else if ([CASE_STATUS_SUCCESS isEqualToString:intention.status]) {
        //隐藏编辑按钮
        editCase.hidden = YES;
        
        //显示备注
        remarkView.hidden = YES;
        
        //显示消费记录
        recordBtn.hidden = YES;
        
        //隐藏商品列表
        goodsListView.hidden = NO;
        
        //隐藏编辑商品按钮
        editGoods.hidden = YES;
        
        //隐藏服务列表
        servicesListView.hidden = NO;
        
        //隐藏编辑服务按钮
        editServices.hidden = YES;
        
        //隐藏支付视图
        payContainer.hidden = YES;
        
        //显示接单按钮
        competeButton.hidden = YES;
        
        //隐藏开始服务按钮
        startButton.hidden = YES;
        
        //隐藏完成服务按钮
        finishButton.hidden = YES;
        
        //隐藏取消按钮
        cancelButton.hidden = YES;
        
        
        [self setGoodsListViewPosition];
        [self setServiceViewHeight];
        
        CGFloat viewHeight = 80 + 125 + height + servicesHeight + 10 + 42;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, viewHeight);
    }
}

//设置商品列表视图高度
- (void)setGoodsListViewPosition
{
    [goodsListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceView.mas_bottom).offset(padding);
    }];
}

//设置服务列表视图高度
- (void)setServiceViewHeight
{
    [serviceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@142);
    }];
}

//文本
- (UILabel *) makeLabel: (NSString *) text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = FONT_MAIN;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark - Action
//编辑
- (void)actionEditCase
{
    [self.delegate actionEditCase];
}


//下单人电话拨号
- (void)actionContactUser
{
    [self.delegate actionContactUser];
}

//服务联系人电话拨号
- (void)actionContactBuyer
{
    [self.delegate actionContactBuyer];
}

//消费记录
- (void)actionConsumeHistory
{
    [self.delegate actionConsumeHistory];
}

//编辑商品
- (void)actionEditGoods
{
    [self.delegate actionEditGoods];
}

//编辑服务
- (void)actionEditServices
{
    [self.delegate actionEditServices];
}

//开始接单
- (void)actionCompeteCase
{
    [self.delegate actionCompeteCase];
}

//开始服务
- (void)actionStartCase
{
    [self.delegate actionStartCase];
}

//完成服务
- (void)actionFinishCase
{
    [self.delegate actionFinishCase];
}

//取消服务
- (void)actionCancelCase
{
    [self.delegate actionCancelCase];
}

@end