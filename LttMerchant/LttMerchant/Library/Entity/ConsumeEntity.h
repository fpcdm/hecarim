//
//  ConsumeEntity.h
//  LttMerchant
//
//  Created by wuyong on 15/9/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface ConsumeEntity : BaseEntity

@property (retain, nonatomic) NSString *consumeTime;

@property (retain, nonatomic) NSDictionary *consumeContent;

@end
