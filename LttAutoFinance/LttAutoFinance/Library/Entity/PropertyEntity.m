//
//  PropertyEntity.m
//  LttAutoFinance
//
//  Created by wuyong on 15/9/28.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "PropertyEntity.h"
#import "UIImageView+WebCache.h"

@implementation PropertyEntity

@synthesize id;

@synthesize name;

@synthesize icon;

- (void)iconView:(UIImageView *)imageView
{
    if (self.icon && [self.icon length] > 0) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.icon] placeholderImage:nil];
    } else {
        imageView.image = nil;
    }
}

@end
