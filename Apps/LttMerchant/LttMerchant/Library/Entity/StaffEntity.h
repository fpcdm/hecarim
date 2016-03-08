//
//  StaffEntity.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/29.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BaseEntity.h"

@interface StaffEntity : BaseEntity

@property (retain, nonatomic) NSNumber *id;

@property (retain, nonatomic) NSString *no;

@property (retain, nonatomic) NSString *name;

@property (retain, nonatomic) NSString *nickname;

@property (retain, nonatomic) NSString *mobile;

@property (retain, nonatomic) NSString *avatar;

@property (retain, nonatomic) NSNumber *is_admin;

@property (retain, nonatomic) NSNumber *isMerchant;


//员工头像绑定view显示（图片缓存预加载）
- (void) staffAvatarView: (UIImageView *) view;

@end
