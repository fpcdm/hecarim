//
//  UIImage+Framework.m
//  Framework
//
//  Created by 吴勇 on 16/1/30.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "UIImage+Framework.h"
#import "UIImage+GIF.h"

@implementation UIImage (Framework)

+ (instancetype)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)imageWithPath:(NSString *)path
{
    if (!path.isNotEmpty) return nil;
    
    if (path.isAbsolutePath) {
        return [UIImage imageWithContentsOfFile:path];
    } else {
        return [UIImage imageNamed:path];
    }
}

+ (instancetype)imageGifNamed:(NSString *)name
{
    return [UIImage sd_animatedGIFNamed:name];
}

+ (instancetype)imageGifWithData:(NSData *)data
{
    return [UIImage sd_animatedGIFWithData:data];
}

@end
