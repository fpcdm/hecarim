//
//  HelperHandler.m
//  LttCustomer
//
//  Created by wuyong on 15/6/26.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HelperHandler.h"

@implementation HelperHandler

- (void)queryLocation:(LocationEntity *)location success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[LocationEntity class] mappingParam:@{@"address": @"address"}];
    
    NSDictionary *param = @{@"lat":location.latitude, @"lon":location.longitude};
    [sharedClient getObject:[LocationEntity new] path:@"location/address" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

- (void)queryAreas:(AreaEntity *)area success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //登录接口调用
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[AreaEntity class] mappingParam:@{@"area_code": @"code", @"area_name": @"name"}];
    
    NSDictionary *param = @{@"parent_code": area.code ? area.code : @0};
    [sharedClient getObject:[AreaEntity new] path:@"area/children" param:param success:^(NSArray *result){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        success(result);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

@end
