//
//  AppView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@implementation AppView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //修正闪烁
    self.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    
    return self;
}

@end
