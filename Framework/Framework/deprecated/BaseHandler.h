//
//  BaseHandler.h
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultEntity.h"

/**
 *  Handler处理成功时调用的Block
 */
typedef void (^SuccessBlock)(NSArray *result);

/**
 *  Handler处理失败时调用的Block
 */
typedef void (^FailedBlock)(ErrorEntity *error);

@interface BaseHandler : NSObject

@end
