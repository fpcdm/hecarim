//
//  AppUIUtil.m
//  LttCustomer
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppUIUtil.h"
#import "Config.h"
#import "AppUserViewController.h"
#import "AppStorageUtil.h"
#import "LoginViewController.h"

@implementation AppUIUtil

+ (UIBarButtonItem *) makeBarButtonItem: (NSString *) title
{
    return [self makeBarButtonItem:title highlighted:NO];
}

+ (UIBarButtonItem *) makeBarButtonItem: (NSString *) title highlighted:(BOOL) highlighted
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    
    if (highlighted) {
        barButtonItem.tintColor = [UIColor colorWithHexString:COLOR_INDEX_TITLE];
        barButtonItem.title = title;
    } else {
        barButtonItem.tintColor = [UIColor colorWithHexString:COLOR_MAIN_TITLE];
        barButtonItem.title = title;
    }
    
    [barButtonItem setTitleTextAttributes:@{
                                            NSFontAttributeName:[UIFont systemFontOfSize:SIZE_BAR_TEXT]
                                            } forState:UIControlStateNormal];
    
    return barButtonItem;
}

+ (UIButton *)makeButton:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:3.0];
    button.titleLabel.font = [UIFont systemFontOfSize:SIZE_BUTTON_TEXT];
    button.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BUTTON_BG];
    return button;
}

+ (UIImage *)nopicImage
{
    UIImage *image = [UIImage imageNamed:@"nopic"];
    return image;
}

@end
