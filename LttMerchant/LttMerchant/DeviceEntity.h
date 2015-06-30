//
//  DeviceEntity.h
//  LttCustomer
//
//  Created by wuyong on 15/6/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface DeviceEntity : BaseEntity

@property (nonatomic, retain) NSString *id;

@property (nonatomic, retain) NSString *token;

@property (nonatomic, retain) NSString *type;

@property (nonatomic, retain) NSString *app;

@end
