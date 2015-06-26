//
//  UserHandler.h
//  LttCustomer
//
//  Created by wuyong on 15/5/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "UserEntity.h"
#import "AddressEntity.h"

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

@end
