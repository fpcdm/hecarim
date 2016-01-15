//
//  MerchantHandler.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "MerchantEntity.h"

@interface MerchantHandler : BaseHandler

/**
 * 商户注册
 
 * @param user 商户
 * @param vCode 安全码
 * @param success 成功回调
 * @param failure 失败回调
 */
- (void) registerWithUser: (UserEntity *)user vCode: (NSString *)vCode success:(SuccessBlock) success failure:(FailedBlock) failure;

@end
