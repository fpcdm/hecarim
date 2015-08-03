//
//  GoodsHandler.h
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "CategoryEntity.h"
#import "BrandEntity.h"
#import "ModelEntity.h"
#import "GoodsEntity.h"

@interface GoodsHandler : BaseHandler

- (void) queryCategories: (CategoryEntity *) category success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryCategoryBrands: (CategoryEntity *) category success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryBrandModels: (BrandEntity *) brand param: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryModelGoods: (ModelEntity *) model success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
