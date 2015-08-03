//
//  ServiceListActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ServiceListActivity.h"
#import "ServiceFormActivity.h"

@interface ServiceListActivity ()

@end

@implementation ServiceListActivity

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
    return @"serviceList.html";
}

#pragma mark - reloadData
- (void) reloadData
{
    [super reloadData];
    
    //重新布局
    [self relayout];
}

#pragma mark - Action
- (void) actionAddService: (SamuraiSignal *) signal
{
    ServiceFormActivity *activity = [[ServiceFormActivity alloc] init];
    activity.caseId = self.caseId;
    [self pushViewController:activity animated:YES];
}

@end
