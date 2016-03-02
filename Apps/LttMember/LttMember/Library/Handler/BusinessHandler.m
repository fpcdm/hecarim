//
//  BusinessHandler.m
//  LttMember
//
//  Created by wuyong on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessHandler.h"

@implementation BusinessHandler

- (void) queryBusinessList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSDictionary *mappingParam = @{
                                   @"create_time": @"createTime",
                                   @"merchant_name": @"merchantName",
                                   @"news_content": @"content",
                                   @"news_id":@"id",
                                   };
    
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[BusinessEntity class] mappingParam:mappingParam keyPath:@"list"];
    
    NSString *restPath = @"mnews/list";
    [sharedClient getObject:[BusinessEntity new] path:restPath param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void) queryBusiness:(BusinessEntity *)businessEntity success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    
    NSDictionary *mappingParam = @{
                                   @"case_type_id": @"typeId",
                                   @"create_time": @"createTime",
                                   @"merchant_id":@"merchantId",
                                   @"merchant_name": @"merchantName",
                                   @"news_content": @"content",
                                   @"news_id":@"id",
                                   @"news_imgs":@"images",
                                   };
    
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[BusinessEntity class] mappingParam:mappingParam];
    
    NSString *restPath = [sharedClient formatPath:@"mnews/info/:id" object:businessEntity];
    [sharedClient getObject:businessEntity path:restPath param:nil success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

@end
