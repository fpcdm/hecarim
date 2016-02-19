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
#import "ConsumeEntity.h"

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

/**
 *  清空消息通知数量
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) clearNotifications: (DeviceEntity *) device success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 * 查询用户消费记录
 * @param success
 * @param failure
 */
- (void) queryConsumeHistory: (UserEntity *)user param: (NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

/**
 * 获取推荐人信息
 * @param mobile 登录用户的手机号
 * @param success
 * @param failure
 */
- (void) getUserRecommendInfo:(UserEntity *)user param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

/**
 * 获取推荐人信息
 * @param mobile 被推荐的人的手机号
 * @param success
 * @param failure
 */
- (void) setRecommend:(UserEntity *)user param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

/**
 * 获取我推荐的人
 * @param param 参数
 * @param success
 * @param failure
 */
- (void) getMyRecommendList:(UserEntity *)user param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;
 


@end
