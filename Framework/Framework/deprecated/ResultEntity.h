//
//  ResultEntity.h
//  LttFramework
//
//  Created by wuyong on 15/7/9.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseEntity.h"

@interface ResultEntity : BaseEntity

@property (nonatomic) NSInteger code;

@property (retain, nonatomic) NSString *info;

@property (retain, nonatomic) id data;

- (instancetype) initWithCode: (NSInteger) code info: (NSString *) info data: (id) data;

- (instancetype) initWithInfo: (NSString *) info data: (id) data;

- (instancetype) initWithData: (id) data;

@end
