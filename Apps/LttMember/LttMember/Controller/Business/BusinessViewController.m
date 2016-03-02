//
//  BusinessViewController.m
//  LttMember
//
//  Created by wuyong on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessViewController.h"
#import "BusinessView.h"
#import "BusinessEntity.h"
#import "BusinessHandler.h"

@interface BusinessViewController () <BusinessViewDelegate>

@end

@implementation BusinessViewController
{
    BusinessView *businessView;
}

- (void)loadView
{
    businessView = [[BusinessView alloc] init];
    businessView.delegate = self;
    self.view = businessView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"微商";
}

@end
