//
//  ErrorEntity.h
//  LttFramework
//
//  Created by wuyong on 15/6/3.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseEntity.h"

@interface ErrorEntity : BaseEntity

@property (nonatomic) NSInteger code;

@property (nonatomic, retain) NSString *message;

- (instancetype) initWithError: (NSError *) error;

- (instancetype) initWithCode: (NSInteger) code message: (NSString *) message;

- (instancetype) initWithMessage: (NSString *) message;

@end
