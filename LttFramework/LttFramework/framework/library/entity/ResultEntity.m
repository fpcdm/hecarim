//
//  ResultEntity.m
//  LttFramework
//
//  Created by wuyong on 15/7/9.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "ResultEntity.h"

@implementation ResultEntity

@synthesize code;

@synthesize info;

@synthesize data;

- (instancetype) initWithCode:(NSInteger)resultCode info:(NSString *)resultInfo data:(id)resultData
{
    self = [super init];
    if (!self) return nil;
    
    self.code = resultCode;
    self.info = resultInfo;
    self.data = resultData;
    
    return self;
}

- (instancetype) initWithInfo:(NSString *)resultInfo data:(id)resultData
{
    return [self initWithCode:0 info:resultInfo data:resultData];
}

- (instancetype) initWithData:(id)resultData
{
    return [self initWithCode:0 info:nil data:resultData];
    
}

@end
