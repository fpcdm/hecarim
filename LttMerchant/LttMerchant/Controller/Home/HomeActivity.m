//
//  HomeViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeActivity.h"
#import "CaseListViewController.h"

@interface HomeActivity ()

@end

@implementation HomeActivity

- (void)viewDidLoad
{
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
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
    CaseListViewController *viewController = [[CaseListViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

@end