//
//  PaymentHandler.m
//  LttMember
//
//  Created by wuyong on 15/12/24.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "PaymentHandler.h"

@implementation PaymentHandler

- (void) makeWeixinOrder:(PaymentEntity *)payment param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[PaymentEntity class] mappingParam:@{@"amount": @"amount", @"caseId": @"case_id", @"type":@"type"}];
    
    NSDictionary *responseMapping = @{
                                      @"noncestr": @"nonceStr",
                                      @"package": @"package",
                                      @"partnerid": @"partnerId",
                                      @"prepayid": @"prepayId",
                                      @"sign": @"sign",
                                      //先映射openId，后续再替换，因为时间戳不是字符串
                                      @"timestamp": @"openID",
                                      };
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[PayReq class] mappingParam:responseMapping];
    
    [sharedClient getObject:payment path:@"pay/app_wxpay_signature" param:param success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        //还原openID为timeStamp
        if ([result count] > 0) {
            PayReq *req = [result firstObject];
            if (req.openID) {
                req.timeStamp = [req.openID intValue];
                req.openID = nil;
            }
            result = @[req];
        }
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
    
}

- (void) makeAlipayOrder:(PaymentEntity *)payment param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[PaymentEntity class] mappingParam:@{@"amount": @"amount", @"caseId": @"case_id", @"type":@"type"}];
    
    NSDictionary *responseMapping = @{
                                      @"_input_charset": @"inputCharset",
                                      @"body": @"productDescription",
                                      @"notify_url": @"notifyURL",
                                      @"out_trade_no": @"tradeNO",
                                      @"partner": @"partner",
                                      @"payment_type": @"paymentType",
                                      @"seller_id": @"seller",
                                      @"service": @"service",
                                      @"sign": @"sign",
                                      @"sign_type": @"signType",
                                      @"subject": @"productName",
                                      @"total_fee": @"amount",
                                      };
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[AlipayOrder class] mappingParam:responseMapping];
    
    [sharedClient getObject:payment path:@"pay/app_alipay_signature" param:param success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) payCaseWithBalance:(CaseEntity *)intention param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[CaseEntity class] mappingParam:@{@"id": @"case_id"}];
    
    [sharedClient postObject:intention path:@"pay/balance" param:param success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        failure(error);
    }];
}

@end
