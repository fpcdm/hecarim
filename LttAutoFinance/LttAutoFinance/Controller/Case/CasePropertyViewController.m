//
//  CasePropertyViewController.m
//  LttAutoFinance
//
//  Created by wuyong on 15/9/28.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CasePropertyViewController.h"
#import "CasePropertyView.h"

@interface CasePropertyViewController () <CasePropertyViewDelegate>

@end

@implementation CasePropertyViewController
{
    CasePropertyView *propertyView;
}

- (void)loadView
{
    propertyView = [[CasePropertyView alloc] init];
    propertyView.delegate = self;
    self.view = propertyView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"汽车品牌选择";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [propertyView setData:@"properties" value:self.properties];
    [propertyView renderData];
}

#pragma mark - Action
- (void)actionSelected:(PropertyEntity *)property
{
    if (!property) {
        [self showError:@"请先选择汽车品牌哦~亲！"];
        return;
    }
    
    if (self.callbackBlock) {
        self.callbackBlock(property);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
