//
//  AdvertEntity.m
//  LttMember
//
//  Created by wuyong on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AdvertEntity.h"

@implementation AdvertEntity

@synthesize title;

@synthesize image;

- (void) imageView:(UIImageView *)view
{
    if (self.image && [self.image length] > 0) {
        view.imageUrl = self.image;
    } else {
        view.image = nil;
    }
}

@end
