//
//  GoodsModel.h
//  LttCustomer
//
//  Created by wuyong on 15/5/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface GoodsEntity : BaseEntity

@property (nonatomic, retain) NSNumber *id;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSNumber *number;

@property (nonatomic, retain) NSNumber *price;

@property (nonatomic, retain) NSString *specName;

@property (nonatomic, retain) NSNumber *categoryId;

@property (nonatomic, retain) NSNumber *brandId;

@property (nonatomic, retain) NSNumber *modelId;

@property (nonatomic, retain) NSNumber *priceId;

@property (nonatomic, retain) NSArray *priceList;

@property (nonatomic, retain) NSArray *specList;

- (NSNumber *) total;

@end
