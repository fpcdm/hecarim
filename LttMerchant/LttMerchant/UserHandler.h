//
//  UserHandler.h
//  LttCustomer
//
//  Created by wuyong on 15/5/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "UserEntity.h"
#import "DeviceEntity.h"

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
 *  退出
 *
 *  @param user    用户
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) logoutWithUser: (UserEntity *) user success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  更新用户心跳
 *
 *  @param user    用户
 *  @param param   附加参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) updateHeartbeat: (UserEntity *) user param: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  新增设备接口
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) addDevice: (DeviceEntity *) device success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
