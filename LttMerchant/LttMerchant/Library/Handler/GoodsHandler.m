//
//  GoodsHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsHandler.h"

@implementation GoodsHandler

- (void) queryCategories:(CategoryEntity *)category success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //获取品牌列表
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[CategoryEntity class] mappingParam:@{@"category_id": @"id", @"category_name": @"name"} keyPath:@"list"];
    
    //转换参数
    NSDictionary *param = @{
                            @"parent_id": category.id ? category.id : @0,
                            @"trade_id": category.tradeId ? category.tradeId : @0
                            };
    
    NSString *restPath = @"category/categories";
    [sharedClient getObject:category path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryCategoryBrands:(CategoryEntity *)category success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //获取品牌列表
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[BrandEntity class] mappingParam:@{@"brand_id": @"id", @"brand_name": @"name"} keyPath:@"list"];
    
    NSString *restPath = [sharedClient formatPath:@"brand/category/:id" object:category];
    [sharedClient getObject:category path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryBrandModels:(BrandEntity *)brand param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //获取型号列表
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[ModelEntity class] mappingParam:@{@"model_id": @"id", @"model_name": @"name"} keyPath:@"list"];
    
    NSString *restPath = [sharedClient formatPath:@"model/brand_model/:id" object:brand];
    [sharedClient getObject:brand path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryModelGoods:(ModelEntity *)model success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[GoodsEntity class] mappingParam:@{@"goods_id": @"id", @"goods_name": @"name", @"price_list":@"priceList", @"spec_list":@"specList"} keyPath:@"list"];
    
    NSString *restPath = [sharedClient formatPath:@"merchandise/list_by_model/:id" object:model];
    [sharedClient getObject:model path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

@end
