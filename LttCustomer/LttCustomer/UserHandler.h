//
//  UserHandler.h
//  LttCustomer
//
//  Created by wuyong on 15/5/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "UserEntity.h"
#import "LocationEntity.h"

@interface UserHandler : BaseHandler

/**
 *  登陆
 *
 *  @param user    用户
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) loginWithUser: (UserEntity *) user success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  查询用户位置
 *
 *  @param param 参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) queryLocation: (LocationEntity *) location success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
