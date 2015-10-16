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

@synthesize remark;

@synthesize detail;

@synthesize sort;

- (void) groupIconView:(UIImageView *)view
{
    if (self.icon && [self.icon length] > 0) {
        [view sd_setImageWithURL:[NSURL URLWithString:self.icon] placeholderImage:[UIImage imageNamed:@"homeGroup"]];
    } else {
        view.image = [UIImage imageNamed:@"homeGroup"];
    }
}

- (void) itemIconView:(UIImageView *)view
{
    if (self.icon && [self.icon length] > 0) {
        [view sd_setImageWithURL:[NSURL URLWithString:self.icon] placeholderImage:[UIImage imageNamed:@"homeItem"]];
    } else {
        view.image = [UIImage imageNamed:@"homeItem"];
    }
}

@end
