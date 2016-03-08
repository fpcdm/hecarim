//
//  StaffEntity.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/29.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "StaffEntity.h"
#import "UIImageView+WebCache.h"

@implementation StaffEntity

@synthesize id,is_admin,isMerchant;

@synthesize no,name,nickname,mobile,avatar;

- (void) staffAvatarView:(UIImageView *)view
{
    if (self.avatar && [self.avatar length] > 0) {
        NSLog(@"加载员工头像缓存：%@", self.avatar);
        [view sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:[UIImage imageNamed:@"nopic"]];
    } else {
        view.image = [UIImage imageNamed:@"nopic"];
    }
}


@end
