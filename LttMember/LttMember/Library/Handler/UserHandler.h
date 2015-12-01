//
//  UserHandler.h
//  LttMember
//
//  Created by wuyong on 15/5/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "UserEntity.h"
#import "AddressEntity.h"
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
 *  注册用户
 *
 *  @param user    用户
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) registerWithUser: (UserEntity *) user success: (SuccessBlock) success failure: (FailedBlock) failure;

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
 *  新增收货地址
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) addAddress: (AddressEntity *) address success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  编辑收货地址
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) editAddress: (AddressEntity *) address success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  设置默认收货地址
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) setDefaultAddress: (AddressEntity *) address success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  收货地址详情
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) queryAddress: (AddressEntity *) address success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  删除收货地址
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) deleteAddress: (AddressEntity *) address success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  收货地址列表
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) queryUserAddresses: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  获取默认收货地址
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) queryUserDefaultAddress: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  修改用户资料
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) editUser: (UserEntity *) user success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  用户提交反馈
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) addSuggestion: (NSString *) suggestion success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  修改登陆密码
 *
 *  @param password 新密码
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) changePassword: (UserEntity *) user password: (NSString *) password success: (SuccessBlock) success failure: (FailedBlock) failure;

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
 *  检查手机号是否已注册
 *
 *  @param mobile 手机号
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) checkMobile: (NSString *) mobile success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  上传头像
 *
 *  @param avatar  头像
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) uploadAvatar: (FileEntity *) avatar success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  获取用户推荐人
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) getReferee: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 *  设置用户推荐人
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) setReferee: (NSString *) mobile success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
