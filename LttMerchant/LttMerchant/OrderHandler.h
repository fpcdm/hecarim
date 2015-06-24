//
//  OrderHandler.h
//  LttCustomer
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "OrderEntity.h"

@interface OrderHandler : BaseHandler

- (void) queryOrder: (OrderEntity *) order success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) addOrder: (OrderEntity *) order success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) updateOrder: (OrderEntity *) order success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) confirmOrder: (OrderEntity *) order param: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
