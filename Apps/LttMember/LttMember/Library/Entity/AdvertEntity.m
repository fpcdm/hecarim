//
//  AdvertEntity.m
//  LttMember
//
//  Created by wuyong on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AdvertEntity.h"
#import "UIImageView+WebCache.h"

@implementation AdvertEntity

@synthesize title;

@synthesize image;

- (void) imageView:(UIImageView *)view
{
    if (self.image && [self.image length] > 0) {
        [view sd_setImageWithURL:[NSURL URLWithString:self.image] placeholderImage:nil];
    } else {
        view.image = nil;
    }
}

@end
