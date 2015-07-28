//
//  ServiceEntity.h
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface ServiceEntity : BaseEntity

@property (nonatomic, retain) NSNumber *id;

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSNumber *number;

@property (nonatomic, retain) NSNumber *price;

@property (nonatomic, retain) NSNumber *typeId;

@property (nonatomic, retain) NSString *typeName;

- (NSNumber *) total;

@end
