//
//  UIImageView+Framework.h
//  Framework
//
//  Created by wuyong on 16/3/3.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Framework)

//设置图片路径，不支持Url
- (NSString *)imagePath;
- (void)setImagePath:(NSString *)imagePath;

//设置图片Url路径
- (NSString *)imageUrl;
- (void)setImageUrl:(NSString *)imageUrl;
- (void)setImageUrl:(NSString *)imageUrl placeholder:(UIImage *)placeholder;
- (void)setImageUrl:(NSString *)imageUrl indicator:(BOOL)indicator;

@end
