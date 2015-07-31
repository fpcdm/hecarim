//
//  ServiceListActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ServiceListActivity.h"

@interface ServiceListActivity ()

@end

@implementation ServiceListActivity

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
}

- (NSString *)templateName
{
    return @"serviceList.html";
}

@end
