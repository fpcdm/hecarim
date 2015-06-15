//
//  StorageUtil.m
//  LttCustomer
//
//  Created by wuyong on 15/5/1.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppExtension.h"

//StorageUtil分类
@implementation StorageUtil (App)

@end

//UserEntity分类
@implementation UserEntity (App)

- (UIImage *)avatarImage
{
    //todo: 初始化头像
    if (self.avatar) {
    }
    
    //返回默认头像
    UIImage *image = [UIImage imageNamed:@"nopic"];
    return image;
}

- (NSString *)sexName
{
    if (self.sex == nil || [@0 isEqualToNumber:self.sex]) {
        return @"";
    } else if ([@1 isEqualToNumber:self.sex]) {
        return @"男";
    } else {
        return @"女";
    }
}

@end
