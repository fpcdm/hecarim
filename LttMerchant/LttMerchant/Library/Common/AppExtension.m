//
//  StorageUtil.m
//  LttCustomer
//
//  Created by wuyong on 15/5/1.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppExtension.h"
#import "UIImageView+WebCache.h"

//StorageUtil分类
@implementation StorageUtil (App)

@end

//UserEntity分类
@implementation UserEntity (App)

- (void) avatarView:(UIImageView *)view
{
    if (self.avatar && [self.avatar length] > 0) {
        NSLog(@"加载头像缓存：%@", self.avatar);
        [view sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:[UIImage imageNamed:@"nopic"]];
    } else {
        view.image = [UIImage imageNamed:@"nopic"];
    }
}

@end
