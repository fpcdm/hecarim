//
//  HelperHandler.h
//  LttCustomer
//
//  Created by wuyong on 15/6/26.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "UserEntity.h"
#import "AreaEntity.h"

@interface HelperHandler : BaseHandler

/**
 *  检查手机号是否已注册
 *
 *  @param mobile 手机号
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) checkMobile: (NSString *) mobile success: (SuccessBlock) success failure: (FailedBlock) failure;

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
 *  重置密码
 *
 *  @param mobile 手机号
 *  @param vCode 安全码
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) resetPassword: (UserEntity *) user vCode: (NSString *) vCode success: (SuccessBlock) success failure: (FailedBlock) failure;


/**
 *  上传图片
 *
 *  @param uploadImg  图片
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) uploadImage: (FileEntity *) uploadImg success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  查询地区列表
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) queryAreas: (AreaEntity *) area success: (SuccessBlock) success failure: (FailedBlock) failure;



@end
