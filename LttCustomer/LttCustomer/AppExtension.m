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
    UIImage *image = nil;
    if (self.avatar && [[NSFileManager defaultManager] fileExistsAtPath:self.avatar]) {
        image = [UIImage imageWithContentsOfFile:self.avatar];
    } else {
        //返回默认头像
        image = [UIImage imageNamed:@"nopic"];
    }
    return image;
}

@end
