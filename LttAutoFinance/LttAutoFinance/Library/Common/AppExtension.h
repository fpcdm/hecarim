//
//  StorageUtil.h
//  LttAutoFInance
//
//  Created by wuyong on 15/5/1.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppExtension.h"
#import "StorageUtil.h"

//StorageUtil分类
@interface StorageUtil (App)

- (void) setSmsTime: (NSDate *) time;

- (NSDate *) getSmsTime;

@end

//UserEntity分类
@interface UserEntity (App)

//头像绑定view显示（图片缓存预加载）
- (void) avatarView: (UIImageView *) view;

@end
