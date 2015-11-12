//
//  MerchantEntity.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "UserEntity.h"

@interface MerchantEntity : UserEntity

@property (retain , nonatomic) NSString *contacter;

@property (retain , nonatomic) NSString *contacter_id;

@property (retain , nonatomic) NSString *merchant_address;

@property (retain , nonatomic) NSString *merchant_name;

@end
