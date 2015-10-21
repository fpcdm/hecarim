//
//  CategoryModel.m
//  LttMember
//
//  Created by wuyong on 15/5/6.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CategoryEntity.h"
#import "UIImageView+WebCache.h"

@implementation CategoryEntity

@synthesize id;

@synthesize name;

@synthesize icon;

@synthesize selectedIcon;

@synthesize remark;

@synthesize sort;

- (void) iconView:(UIImageView *)view
{
    if (self.icon && [self.icon length] > 0) {
        [view sd_setImageWithURL:[NSURL URLWithString:self.icon] placeholderImage:nil];
    }
}

- (void) selectedIconView:(UIImageView *)view
{
    if (self.selectedIcon && [self.selectedIcon length] > 0) {
        [view sd_setImageWithURL:[NSURL URLWithString:self.selectedIcon] placeholderImage:nil];
    }
}

@end
