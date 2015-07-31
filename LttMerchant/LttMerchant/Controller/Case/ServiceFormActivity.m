//
//  ServiceFormActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ServiceFormActivity.h"

@interface ServiceFormActivity ()

@end

@implementation ServiceFormActivity

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
}

- (NSString *)templateName
{
    return @"serviceForm.html";
}

#pragma mark - Action
- (void) actionSave: (SamuraiSignal *) signal
{
    //todo 保存
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
