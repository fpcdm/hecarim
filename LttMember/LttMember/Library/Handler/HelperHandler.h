//
//  HelperHandler.h
//  LttMember
//
//  Created by wuyong on 15/6/26.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "LocationEntity.h"
#import "AreaEntity.h"
#import "UserEntity.h"

@interface HelperHandler : BaseHandler

/**
 *  查询用户位置
 *
 *  @param location GPS坐标
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) queryLocation: (LocationEntity *) location success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  查询服务人员数量
 *
 *  @param location GPS坐标
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) queryServiceNumber: (LocationEntity *) location success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  查询地区列表
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) queryAreas: (AreaEntity *) area success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  发送验证码
 *
 *  @param mobile 手机号
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) sendMobileCode: (NSString *) mobile success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  验证短信验证码
 *
 *  @param mobile 手机号
 *  @param code 验证码
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) verifyMobileCode: (NSString *) mobile code: (NSString *) code success: (SuccessBlock) success failure: (FailedBlock) failure;


/**
 *  检查手机号是否已注册
 *
 *  @param mobile 手机号
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) checkMobile: (NSString *) mobile success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  重置密码
 *
 *  @param mobile 手机号
 *  @param vCode 安全码
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) resetPassword: (UserEntity *)user vCode: (NSString *) vCode success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
