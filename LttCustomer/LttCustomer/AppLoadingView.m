//
//  AppLoadingView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/26.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppLoadingView.h"

@implementation AppLoadingView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //修正闪烁
    self.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    
    return self;
}

@end
