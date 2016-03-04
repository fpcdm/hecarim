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
                                   @"case_type_property_id": @"propertyId",
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
        
        BusinessEntity *business = [result firstObject];
        //格式化图片
        NSArray *imagesArray = business.images.isNotEmpty ? business.images : nil;
        NSMutableArray *images = [NSMutableArray array];
        if (imagesArray) {
            for (NSDictionary *image in imagesArray) {
                ImageEntity *imageEntity = [[ImageEntity alloc] init];
                imageEntity.imageUrl = [image objectForKey:@"img_url"];
                imageEntity.thumbUrl = [image objectForKey:@"thumb_url"];
                [images addObject:imageEntity];
            }
        }
        business.images = images;
        
        success(@[business]);
    } failure:^(ErrorEntity *error){
        [sharedClient removeResponseDescriptor:responseDescriptor];
        
        failure(error);
    }];
}

@end
