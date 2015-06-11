//
//  OrderHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "OrderHandler.h"

@implementation OrderHandler

- (void) queryOrders:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[OrderEntity class] mappingParam:@{@"order_no": @"no", @"create_time": @"createTime", @"amount": @"amount", @"buyer_mobile":@"buyerMobile", @"buyer_name": @"buyerName", @"seller_mobile":@"sellerMobile", @"seller_name":@"sellerName", @"update_time":@"updateTime", @"goods":@"goods",@"order_status":@"status"} keyPath:@"list"];
    
    NSString *restPath = @"member/orders";
    [sharedClient getObject:[OrderEntity new] path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryOrder:(OrderEntity *)order success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[OrderEntity class] mappingParam:@{@"buyer_mobile": @"buyerMobile", @"buyer_name": @"buyerName", @"order_amount": @"amount", @"order_no":@"no", @"order_status": @"status", @"seller_mobile":@"sellerMobile", @"seller_name":@"sellerName", @"goods":@"goods",@"update_time":@"updateTime"}];
    
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
