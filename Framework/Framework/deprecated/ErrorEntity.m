//
//  ErrorEntity.m
//  LttFramework
//
//  Created by wuyong on 15/6/3.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "ErrorEntity.h"

@implementation ErrorEntity

@synthesize code;

@synthesize message;

- (instancetype) initWithError:(NSError *)error
{
    return [self initWithCode:error.code message:[error localizedDescription]];
}

- (instancetype) initWithCode:(NSInteger)errorCode message:(NSString *)errorMessage
{
    self = [super init];
    if (!self) return nil;
    
    self.code = errorCode;
    self.message = errorMessage;
    
    return self;
}

- (instancetype) initWithMessage:(NSString *)errorMessage
{
    return [self initWithCode:0 message:errorMessage];
}

@end
