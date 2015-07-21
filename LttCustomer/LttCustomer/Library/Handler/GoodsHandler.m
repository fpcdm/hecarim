//
//  GoodsHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsHandler.h"

@implementation GoodsHandler

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
    
    NSString *restPath = [sharedClient formatPath:@"goods/brand_model/:id" object:brand];
    [sharedClient getObject:brand path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

@end