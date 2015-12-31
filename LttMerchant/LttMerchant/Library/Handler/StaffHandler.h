//
//  StaffHandler.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/30.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "StaffEntity.h"

@interface StaffHandler : BaseHandler

/**
 * 检查用户权限
 * @param success
 * @param failure
 */
- (void) userPermissions:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

/**
 * 获取员工列表
 * @param param 参数
 * @param success
 * @param failure
 */
- (void) getStaffList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

/**
 * 添加员工
 * @param param 参数
 * @param success
 * @param failure
 */
- (void) addStaff:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

/**
 * 员工详情
 * @param param 参数
 * @param success
 * @param failure
 */
- (void) staffDetail:(StaffEntity *)staff param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

/**
 * 编辑员工
 * @param param 参数
 * @param success
 * @param failure
 */
- (void) editStaff:(StaffEntity *)staffEntity param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

/**
 *  上传头像
 *
 *  @param avatar  头像
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void) uploadAvatar: (FileEntity *) avatar success: (SuccessBlock) success failure: (FailedBlock) failure;

/**
 * 重置密码
 * @param param 参数
 * @param success
 * @param failure
 */
- (void) resetStaffPassword:(StaffEntity *)staff param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

@end
