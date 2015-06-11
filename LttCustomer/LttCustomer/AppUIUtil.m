//
//  AppUIUtil.m
//  LttCustomer
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppUIUtil.h"
#import "Config.h"

@implementation AppUIUtil

+ (UIBarButtonItem *) makeBarButtonItem: (NSString *) title
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.tintColor = [UIColor colorWithHexString:COLOR_MAIN_TITLE];
    barButtonItem.title = title;
    
    [barButtonItem setTitleTextAttributes:@{
                                            NSFontAttributeName:[UIFont systemFontOfSize:SIZE_BAR_TEXT]
                                            } forState:UIControlStateNormal];
    
    return barButtonItem;
}

+ (UIImage *)nopicImage
{
    UIImage *image = [UIImage imageNamed:@"nopic"];
    return image;
}

@end
