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

@synthesize intention;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadCase];
}

- (NSString *)templateName
{
    return @"serviceForm.html";
}

#pragma mark - reloadData
- (void) reloadData
{
    [super reloadData];
    
    //重新布局
    [self relayout];
}

#pragma mark - Action
- (void) actionSave: (SamuraiSignal *) signal
{
    //todo 保存
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
