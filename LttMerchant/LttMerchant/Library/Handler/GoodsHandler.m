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
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[GoodsEntity class] mappingParam:@{@"goods_id": @"id", @"goods_name": @"name", @"price_list":@"priceList", @"spec_list":@"specList"}];
    
    NSString *restPath = [sharedClient formatPath:@"merchandise/prices/:id" object:model];
    [sharedClient getObject:model path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        //整理数据
        if ([result count] > 0) {
            GoodsEntity *goods = [result firstObject];
            NSMutableArray *specList = [[NSMutableArray alloc] init];
            if (goods.specList && [goods.specList count] > 0) {
                for (NSDictionary *specDict in goods.specList) {
                    SpecEntity *specEntity = [[SpecEntity alloc] init];
                    specEntity.id = [specDict objectForKey:@"spec_id"];
                    specEntity.name = [specDict objectForKey:@"spec_name"];
                    
                    //子规格列表
                    NSMutableArray *children = [[NSMutableArray alloc] init];
                    NSArray *subList = [specDict objectForKey:@"list"];
                    if (subList && [subList count] > 0) {
                        for (NSDictionary *subDict in subList) {
                            SpecEntity *subEntity = [[SpecEntity alloc] init];
                            subEntity.id = [subDict objectForKey:@"spec_id"];
                            subEntity.name = [subDict objectForKey:@"spec_name"];
                            subEntity.children = @[];
                            
                            [children addObject:subEntity];
                        }
                    }
                    specEntity.children = children;
                    
                    //添加到列表中
                    [specList addObject:specEntity];
                }
            }
            goods.specList = specList;
        }
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

@end
