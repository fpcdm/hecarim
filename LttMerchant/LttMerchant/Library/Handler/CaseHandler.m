//
//  CaseHandler.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseHandler.h"

@implementation CaseHandler

- (void) queryCase:(CaseEntity *)caseEntity success:(SuccessBlock)success failure:(FailedBlock)failure
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
                                   @"property_id": @"propertyId",
                                   @"property_name": @"propertyName",
                                   @"user_id": @"userId",
                                   @"user_name": @"userName",
                                   @"user_mobile": @"userMobile",
                                   @"user_avatar": @"userAvatar",
                                   @"user_appellation": @"userAppellation",
                                   @"goods": @"goodsParam",
                                   @"services": @"servicesParam"
                                   };
    
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[CaseEntity class] mappingParam:mappingParam];
    
    NSString *restPath = [sharedClient formatPath:@"cases/info/:id" object:caseEntity];
    [sharedClient getObject:caseEntity path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        //整理需求数据
        CaseEntity *resultEntity = [result firstObject];
        
        //处理订单号
        if (resultEntity.no && [resultEntity.no length] > 15) {
            resultEntity.no = [resultEntity.no substringToIndex:15];
        }
        
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
                    goods.categoryId = [goodsItem objectForKey:@"category_id"];
                    goods.brandId = [goodsItem objectForKey:@"brand_id"];
                    goods.modelId = [goodsItem objectForKey:@"model_id"];
                    goods.priceId = [goodsItem objectForKey:@"price_id"];
                    goods.name = [goodsItem objectForKey:@"goods_name"];
                    goods.number = [goodsItem objectForKey:@"goods_num"];
                    goods.price = [goodsItem objectForKey:@"goods_price"];
                    goods.specName = [goodsItem objectForKey:@"specs"];
                    
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
        
        //覆盖返回值
        result = @[resultEntity];
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryCases:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[CaseEntity class] mappingParam:@{@"case_id": @"id", @"case_no": @"no", @"create_time": @"createTime", @"status":@"status", @"contact": @"buyerName", @"contact_mobile":@"buyerMobile"} keyPath:@"list"];
    
    NSString *restPath = @"employee/cases";
    [sharedClient getObject:[CaseEntity new] path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        //处理订单号
        for (CaseEntity *entity in result) {
            if (entity.no && [entity.no length] > 15) {
                entity.no = [entity.no substringToIndex:15];
            }
        }
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) competeCase:(CaseEntity *)caseEntity success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [[RestKitUtil sharedClient] formatPath:@"employee/response/:id" object:caseEntity];
    [sharedClient putObject:caseEntity path:restPath param:nil success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void) giveupCase:(CaseEntity *)caseEntity success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [[RestKitUtil sharedClient] formatPath:@"employee/response/:id" object:caseEntity];
    [sharedClient deleteObject:caseEntity path:restPath param:nil success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void) updateCaseStatus:(CaseEntity *)caseEntity param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSString *restPath = [sharedClient formatPath:@"cases/status/:id" object:caseEntity];
    [sharedClient postObject:caseEntity path:restPath param:param success:^(NSArray *result){
        success(result);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void) addCaseGoods:(CaseEntity *)caseEntity success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[CaseEntity class] mappingParam:@{@"id": @"case_id", @"goodsParam": @"list"}];
    
    [sharedClient putObject:caseEntity path:@"cases/merchandises" param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        failure(error);
    }];
}

- (void) editCaseGoods:(CaseEntity *)caseEntity success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[CaseEntity class] mappingParam:@{@"goodsParam": @"list"}];
    
    NSString *restPath = [sharedClient formatPath:@"cases/merchandises/:id" object:caseEntity];
    [sharedClient postObject:caseEntity path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        failure(error);
    }];
}

- (void) addCaseServices:(CaseEntity *)caseEntity success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[CaseEntity class] mappingParam:@{@"id": @"case_id", @"servicesParam": @"list"}];
    
    [sharedClient putObject:caseEntity path:@"cases/services" param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        failure(error);
    }];
}

- (void) editCaseServices:(CaseEntity *)caseEntity success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKRequestDescriptor *requestDescriptor = [sharedClient addRequestDescriptor:[CaseEntity class] mappingParam:@{@"servicesParam": @"list"}];
    
    NSString *restPath = [sharedClient formatPath:@"cases/services/:id" object:caseEntity];
    [sharedClient postObject:caseEntity path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeRequestDescriptor:requestDescriptor];
        
        failure(error);
    }];
}

@end
