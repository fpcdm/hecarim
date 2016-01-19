//
//  IntentionHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseHandler.h"

@implementation CaseHandler

- (void) addIntention:(CaseEntity *)intention success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[CaseEntity class] mappingParam:@{@"typeId": @"type", @"customerRemark": @"remark", @"buyerAddress": @"address", @"addressId": @"address_id"}];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[CaseEntity class] mappingParam:@{@"intention_id": @"id"}];
    
    [sharedClient putObject:intention path:@"cases/info" param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryIntention:(CaseEntity *)caseEntity success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSDictionary *mappingParam = @{
                                   @"case_amount": @"totalAmount",
                                   @"case_id": @"id",
                                   @"case_no": @"no",
                                   @"case_status": @"status",
                                   @"contact": @"buyerName",
                                   @"contact_mobile": @"buyerMobile",
                                   @"contact_address": @"buyerAddress",
                                   @"create_time": @"createTime",
                                   @"customer_remark": @"customerRemark",
                                   @"map_url": @"mapUrl",
                                   @"rate_star": @"rateStar",
                                   @"remark": @"staffRemark",
                                   @"staff_id": @"staffId",
                                   @"staff_name": @"staffName",
                                   @"staff_mobile": @"staffMobile",
                                   @"staff_avatar": @"staffAvatar",
                                   @"type_id": @"typeId",
                                   @"type_name": @"typeName",
                                   @"user_id": @"userId",
                                   @"user_name": @"userName",
                                   @"user_mobile": @"userMobile",
                                   @"user_avatar": @"userAvatar",
                                   @"goods": @"goodsParam",
                                   @"services": @"servicesParam"
                                   };
    
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[CaseEntity class] mappingParam:mappingParam];
    
    NSString *restPath = [sharedClient formatPath:@"cases/info/:id" object:caseEntity];
    [sharedClient getObject:caseEntity path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        //整理需求数据
        for (CaseEntity *resultEntity in result) {
            [self formatIntention:resultEntity];
        }
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

//格式化需求商品和服务信息
- (void) formatIntention: (CaseEntity *)resultEntity
{
    //解析订单商品
    NSMutableArray *goodsArray = [NSMutableArray arrayWithObjects:nil];
    if (resultEntity.goodsParam) {
        NSNumber *goodsAmount = [resultEntity.goodsParam objectForKey:@"amount"];
        resultEntity.goodsAmount = goodsAmount ? goodsAmount : @0.00;
        
        NSArray *goodsList = [resultEntity.goodsParam objectForKey:@"list"];
        if (goodsList && [goodsList count] > 0) {
            for (NSDictionary *goodsItem in goodsList) {
                GoodsEntity *goods = [[GoodsEntity alloc] init];
                goods.id = [goodsItem objectForKey:@"goods_id"];
                goods.name = [goodsItem objectForKey:@"goods_name"];
                goods.number = [goodsItem objectForKey:@"goods_num"];
                goods.price = [goodsItem objectForKey:@"goods_price"];
                id specName = [goodsItem objectForKey:@"specs"];
                if (specName) goods.specName = specName;
                
                [goodsArray addObject:goods];
            }
        }
    }
    resultEntity.goods = goodsArray;
    resultEntity.goodsParam = nil;
    
    //解析服务
    NSMutableArray *servicesArray = [NSMutableArray arrayWithObjects:nil];
    if (resultEntity.servicesParam) {
        NSNumber *servicesAmount = [resultEntity.servicesParam objectForKey:@"amount"];
        resultEntity.servicesAmount = servicesAmount ? servicesAmount : @0.00;
        
        NSArray *serviceList = [resultEntity.servicesParam objectForKey:@"list"];
        if (serviceList && [serviceList count] > 0) {
            for (NSDictionary *serviceItem in serviceList) {
                ServiceEntity *service = [[ServiceEntity alloc] init];
                service.name = [serviceItem objectForKey:@"content"];
                service.price = [serviceItem objectForKey:@"price"];
                service.typeName = [serviceItem objectForKey:@"category_name"];
                service.typeId = [serviceItem objectForKey:@"category_id"];
                
                [servicesArray addObject:service];
            }
        }
    }
    resultEntity.services = servicesArray;
    resultEntity.servicesParam = nil;
}

- (void) queryIntentions:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSDictionary *mappingParam = @{
                                   @"case_id": @"id",
                                   @"case_no": @"no",
                                   @"create_time": @"createTime",
                                   @"status":@"status",
                                   @"type_id": @"typeId",
                                   @"type_name": @"typeName",
                                   @"remark":@"staffRemark",
                                   @"customer_remark":@"customerRemark",
                                   @"goods": @"goodsParam",
                                   @"services": @"servicesParam"
                                   };
    
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[CaseEntity class] mappingParam:mappingParam keyPath:@"list"];
    
    NSString *restPath = @"cases/list";
    [sharedClient getObject:[CaseEntity new] path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        for (CaseEntity *resultEntity in result) {
            [self formatIntention:resultEntity];
        }
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) cancelIntention:(CaseEntity *)intention success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [[RestKitUtil sharedClient] formatPath:@"cases/info/:id" object:intention];
    [sharedClient deleteObject:intention path:restPath param:nil success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void) updateIntentionStatus:(CaseEntity *)intention param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [sharedClient formatPath:@"cases/status/:id" object:intention];
    [sharedClient postObject:intention path:restPath param:param success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void) addIntentionEvaluation:(CaseEntity *)intention success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[CaseEntity class] mappingParam:@{@"no": @"case_no", @"rateStar": @"rate_star"}];
    
    [sharedClient putObject:intention path:@"member/evaluation" param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        failure(error);
    }];
}

@end