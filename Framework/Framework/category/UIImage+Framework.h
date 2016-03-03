//
//  UIImage+Framework.h
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Framework)

//从View创建UIImage
+ (instancetype)imageWithView:(UIView *)view;

//从路径创建UIImage，不支持Url
+ (instancetype)imageWithPath:(NSString *)path;

//从Gif创建UIImage
+ (instancetype)imageGifNamed:(NSString *)name;
+ (instancetype)imageGifWithData:(NSData *)data;

@end
