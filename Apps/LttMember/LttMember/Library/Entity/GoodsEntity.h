//
//  GoodsModel.h
//  LttMember
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

- (NSNumber *) total;

@end
