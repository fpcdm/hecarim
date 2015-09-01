//
//  HomeViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeActivity.h"
#import "CaseListActivity.h"
#import "LocationUtil.h"

@interface HomeActivity ()

@end

@implementation HomeActivity

- (void)viewDidLoad
{
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    //刷新gps
    [[LocationUtil sharedInstance] restartUpdate];
}

- (NSString *) templateName
{
    return @"home.html";
}

#pragma mark - 
- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
}

- (void)onTemplateFailed
{
    
}

- (void)onTemplateCancelled
{
    
}

#pragma mark - Action
- (void)actionCaseList: (SamuraiSignal *) signal
{
    CaseListActivity *viewController = [[CaseListActivity alloc] init];
    [self pushViewController:viewController animated:YES];
}

@end
