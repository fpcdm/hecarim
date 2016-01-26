//
//  MerchantHandler.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "MerchantHandler.h"

@implementation MerchantHandler

//商户注册
- (void) registerWithUser:(MerchantEntity *)merchant vCode:(NSString *)vCode success:(SuccessBlock)success failure:(FailedBlock)failure
{
    //调用接口
    RestKitUtil *sharedClient = [RestKitUtil sharedClient];
    RKResponseDescriptor *responseDescriptor = [sharedClient addResponseDescriptor:[UserEntity class] mappingParam:@{@"user_id":@"id"}];
    
    NSString *restPath = [sharedClient formatPath:@"user/merchant" object:merchant];
    
    NSDictionary *param = @{
                            @"merchant_name":merchant.merchant_name ? merchant.merchant_name : @"",
                            @"merchant_address":merchant.merchant_address ? merchant.merchant_address : @"",
                            @"contacter":merchant.contacter ? merchant.contacter : @"",
                            @"contacter_id":merchant.contacter_id ? merchant.contacter_id : @"",
                            @"mobile":merchant.mobile ? merchant.mobile : @"",
                            @"password": merchant.password ? merchant.password : @"",
                            @"vcode" : vCode ? vCode : @"",
                            @"license_img" : merchant.licenseUrl ? merchant.licenseUrl : @"",
                            @"contacter_id_img" : merchant.cardUrl ? merchant.cardUrl : @"",
                            @"province" : merchant.province ? merchant.province : @"",
                            @"city" : merchant.city ? merchant.city : @"",
                            @"area" : merchant.area ? merchant.area : @"",
                            @"street" : merchant.street ? merchant.street : @""
                            };
    [sharedClient putObject:merchant path:restPath param:param success:^(NSArray *result) {
        [sharedClient removeResponseDescriptor:responseDescriptor];
        success(result);
    } failure:^(ErrorEntity *error) {
        [sharedClient removeResponseDescriptor:responseDescriptor];
        failure(error);
    }];
}
@end
