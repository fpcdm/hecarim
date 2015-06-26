//
//  HelperHandler.h
//  LttCustomer
//
//  Created by wuyong on 15/6/26.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "LocationEntity.h"
#import "AreaEntity.h"

@interface HelperHandler : BaseHandler

/**
 *  查询用户位置
 *
 *  @param param 参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) queryLocation: (LocationEntity *) location success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  查询地区列表
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) queryAreas: (AreaEntity *) area success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
