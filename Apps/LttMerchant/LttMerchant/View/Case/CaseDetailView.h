//
//  CaseDetailView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/24.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppScrollView.h"
#import "PaymentView.h"

@protocol CaseDetailViewDelegate <NSObject>

- (void)actionContactUser;

- (void)actionContactBuyer;

//编辑信息
- (void)actionEditCase;

//消费记录
- (void)actionConsumeHistory;

//接单
- (void)actionCompeteCase;

//开始服务
- (void)actionStartCase;

//完成服务
- (void)actionFinishCase;

//取消服务
- (void)actionCancelCase;

//编辑商品
- (void)actionEditGoods;

///编辑服务
- (void)actionEditServices;

//微信支付
- (void)actionWeixinQrcode;

//支付宝支付
- (void)actionAlipayQrcode;

//现金支付
- (void)actionUseMoney;

//确认是否现在支付
- (void)actionConfirmPayed;

//重新选择支付方式
- (void)actionChooseMethod;

@end

@interface CaseDetailView : AppScrollView

@property (retain , nonatomic) id<CaseDetailViewDelegate>delegate;

@property (retain , nonatomic) UIImageView *img;

- (void)showImage;

@end

