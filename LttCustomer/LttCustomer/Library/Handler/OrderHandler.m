//
//  OrderHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "OrderHandler.h"

@implementation OrderHandler

- (void) queryOrder:(OrderEntity *)order success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[OrderEntity class] mappingParam:@{@"buyer_mobile": @"buyerMobile", @"buyer_name": @"buyerName", @"order_amount": @"amount", @"order_no":@"no", @"order_status": @"status", @"seller_mobile":@"sellerMobile", @"seller_name":@"sellerName", @"seller_avatar": @"sellerAvatar", @"goods":@"goodsParam",@"services":@"services",@"update_time":@"updateTime", @"rate_star":@"commentLevel"}];
    
    NSString *restPath = [sharedClient formatPath:@"order/info/:no" object:order];
    [sharedClient getObject:order path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) updateOrderStatus:(OrderEntity *)order param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [sharedClient formatPath:@"order/status/:no" object:order];
    [sharedClient postObject:order path:restPath param:param success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void) addOrderEvaluation:(OrderEntity *)order success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[OrderEntity class] mappingParam:@{@"no": @"case_no", @"commentLevel": @"rate_star"}];
    
    [sharedClient putObject:order path:@"member/evaluation" param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        failure(error);
    }];
}

- (void) queryOrderQrcode:(OrderEntity *)order success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[OrderEntity class] mappingParam:@{@"qrcode": @"qrcode"}];
    
    NSString *restPath = [sharedClient formatPath:@"order/qrcode/:no" object:order];
    [sharedClient getObject:order path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

@end
