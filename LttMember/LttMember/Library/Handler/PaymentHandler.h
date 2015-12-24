//
//  PaymentHandler.h
//  LttMember
//
//  Created by wuyong on 15/12/24.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "PaymentEntity.h"
#import "CaseEntity.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayOrder.h"

@interface PaymentHandler : BaseHandler

//生成微信支付订单
- (void) makeWeixinOrder:(PaymentEntity *)payment param:(NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//生成支付宝支付订单
- (void) makeAlipayOrder:(PaymentEntity *)payment param:(NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//使用余额支付订单
- (void) payCaseWithBalance:(CaseEntity *)intention param:(NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
