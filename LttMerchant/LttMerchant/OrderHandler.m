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
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[OrderEntity class] mappingParam:@{@"buyer_mobile": @"buyerMobile", @"buyer_name": @"buyerName", @"order_amount": @"amount", @"order_no":@"no", @"order_status": @"status", @"seller_mobile":@"sellerMobile", @"seller_name":@"sellerName", @"goods":@"goodsParam",@"update_time":@"updateTime",@"services":@"services"}];
    
    NSString *restPath = [sharedClient formatPath:@"order/info/:no" object:order];
    [sharedClient getObject:order path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) addOrder:(OrderEntity *)order success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[OrderEntity class] mappingParam:@{@"amount": @"amount", @"buyerAddress": @"buyer_address", @"buyerId": @"buyer_id", @"buyerMobile": @"buyer_mobile", @"goodsParam" :@"goods", @"sellerId":@"seller_id",@"sellerMobile":@"seller_mobile",@"intentionId":@"intention_id",@"servicesParam":@"services"}];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[OrderEntity class] mappingParam:@{@"order_no": @"no"}];
    
    [sharedClient putObject:order path:@"order/info" param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) updateOrder:(OrderEntity *)order success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[OrderEntity class] mappingParam:@{@"amount": @"amount", @"buyerAddress": @"buyer_address", @"buyerMobile": @"buyer_mobile", @"goodsParam" :@"goods", @"sellerMobile":@"seller_mobile"}];
    
    NSString *restPath = [sharedClient formatPath:@"order/info/:no" object:order];
    [sharedClient postObject:order path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        failure(error);
    }];
}

- (void) confirmOrder:(OrderEntity *)order param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [sharedClient formatPath:@"order/qrcode/:no" object:order];
    [sharedClient postObject:order path:restPath param:param success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

@end
