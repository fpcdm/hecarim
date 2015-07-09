//
//  RegisterExistView.m
//  LttCustomer
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "RegisterExistView.h"

@implementation RegisterExistView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"nopic"];
    [self addSubview:imageView];
    
    UIView *superview = self;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(70);
        make.centerX.equalTo(superview.mas_centerX);
        
        make.width.equalTo(@50);
        make.height.equalTo(@40);
    }];
    
    return self;
}

@end
