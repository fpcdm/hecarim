//
//  BaseLoadingView.m
//  LttFramework
//
//  Created by wuyong on 15/6/26.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseLoadingView.h"
#import "MBProgressHUD.h"

@implementation BaseLoadingView
{
    MBProgressHUD *loading;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    loading = [MBProgressHUD showHUDAddedTo:self animated:YES];
    loading.labelText = MESSAGE_VIEW_LOADING;
    
    return self;
}

- (void) hide
{
    if (loading) {
        [loading hide:NO];
        loading = nil;
    }
}

- (void)dealloc
{
    [self hide];
}

@end
