//
//  UIImageView+Framework.m
//  Framework
//
//  Created by wuyong on 16/3/3.
//  Copyright © 2016年 ocphp.com. All rights reserved.
//

#import "UIImageView+Framework.h"
#import "UIImage+Framework.h"
#import "UIView+Framework.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Framework)

- (NSString *)imagePath
{
    return [self getAssociatedObjectForKey:"imagePath"];
}

- (void)setImagePath:(NSString *)imagePath
{
    if (!imagePath.isNotEmpty) {
        [self removeAssociatedObjectForKey:"imagePath"];
        self.image = nil;
        return;
    }
    
    [self setAssociatedObject:imagePath forKey:"imagePath"];
    self.image = [UIImage imageWithPath:imagePath];
}

- (NSString *)imageUrl
{
    return [self getAssociatedObjectForKey:"imageUrl"];
}

- (void)setImageUrl:(NSString *)imageUrl
{
    [self setImageUrl:imageUrl placeholder:nil];
}

- (void)setImageUrl:(NSString *)imageUrl placeholder:(UIImage *)placeholder
{
    if (!imageUrl.isNotEmpty) {
        [self removeAssociatedObjectForKey:"imageUrl"];
        self.image = nil;
        return;
    }
    
    [self setAssociatedObject:imageUrl forKey:"imageUrl"];
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder];
}

- (void)setImageUrl:(NSString *)imageUrl indicator:(BOOL)indicator
{
    if (!imageUrl.isNotEmpty) {
        [self removeAssociatedObjectForKey:"imageUrl"];
        self.image = nil;
        return;
    }
    
    [self setAssociatedObject:imageUrl forKey:"imageUrl"];
    
    if (!indicator) {
        [self sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        return;
    }
    
    [self showIndicator];
    
    @weakify(self);
    [self sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       @strongify(self);
                       
                       [self hideIndicator];
                   }
     ];
}

@end
