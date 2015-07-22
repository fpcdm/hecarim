//
//  UIView+Loading.m
//  LttCustomer
//
//  Created by wuyong on 15/5/5.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "UIView+Loading.h"
#import "MBProgressHUD.h"
#import "FrameworkConfig.h"

@implementation UIView (Loading)

- (void) showLoading
{
    [self showLoading: MESSAGE_VIEW_LOADING];
}

- (void) showLoading: (NSString *) message
{
    MBProgressHUD *loading = [MBProgressHUD showHUDAddedTo:self animated:YES];
    loading.labelText = message;
}

- (void) hideLoading
{
    [MBProgressHUD hideHUDForView:self animated:NO];
}

@end
