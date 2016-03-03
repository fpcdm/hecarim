//
//  BusinessHandler.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessHandler.h"

@implementation BusinessHandler

- (void)getUserServicesList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[ResultEntity class] mappingParam:@{@"list": @"data"}];
    
    [sharedClient getObject:[ResultEntity new] path:@"casetype/org_types" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void)addBusiness:(BusinessEntity *)business param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[BusinessEntity class] mappingParam:@{@"news_id" : @"newsId"}];
    
    [sharedClient putObject:[BusinessEntity new] path:@"mnews/info" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void)getBusinessList:(BusinessEntity *)business param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[BusinessEntity class] mappingParam:@{@"merchant_name" : @"merchantName",@"news_content" : @"newsContent",@"create_time" : @"createTime",@"news_id" : @"newsId"} keyPath:@"list"];
    
    [sharedClient getObject:[BusinessEntity new] path:@"mnews/list" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];

}

- (void)getBusinessDetail:(BusinessEntity *)business param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[BusinessEntity class] mappingParam:@{
                                            @"case_type_id" : @"caseId",
                                            @"create_time" : @"createTime",
                                            @"merchant_id" : @"merchantId",
                                            @"merchant_name" : @"merchantName",
                                            @"news_content" : @"newsContent",
                                            @"news_id" : @"newsId",
                                            @"news_imgs" : @"newsImgs"
                                            }];
    
    NSString *restPath = [sharedClient formatPath:@"mnews/info/:id" object:business];
    
    [sharedClient getObject:[BusinessEntity new] path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];

}

- (void)deleteBusiness:(BusinessEntity *)business param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];

    NSString *restPath = [sharedClient formatPath:@"mnews/list/:id" object:business];
    
    [sharedClient deleteObject:[NSObject new] path:restPath param:param success:^(NSArray *result){
        
        success(result);
    } failure:^(ErrorEntity *error){
        
        failure(error);
    }];

}

@end
