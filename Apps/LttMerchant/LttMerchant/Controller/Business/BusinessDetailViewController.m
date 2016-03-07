//
//  BusinessDetailViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessDetailViewController.h"
#import "BusinessDetailView.h"
#import "BusinessAddViewController.h"
#import "BusinessEntity.h"
#import "BusinessHandler.h"

@interface BusinessDetailViewController ()<BusinessDetailViewDelegate>

@end

@implementation BusinessDetailViewController
{
    BusinessDetailView *detailView;
    BusinessEntity *businessEntity;
}

@synthesize newsId;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"生意圈信息";
    
    UIBarButtonItem *sendMsgButton = [AppUIUtil makeBarButtonItem:@"发信息" highlighted:isIndexNavBar];
    sendMsgButton.target = self;
    sendMsgButton.action = @selector(actionSendMsg);
    self.navigationItem.rightBarButtonItem = sendMsgButton;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    detailView = [[BusinessDetailView alloc] init];
    detailView.delegate = self;
    self.view = detailView;
    
    businessEntity = [[BusinessEntity alloc] init];
    businessEntity.id = newsId;
    
    [self showLoading:[FWLocale system:@"Loading.Start"]];
    
    BusinessHandler *businessHandler = [[BusinessHandler alloc] init];
    [businessHandler getBusinessDetail:businessEntity param:nil success:^(NSArray *result) {
        [self hideLoading];
        businessEntity = [result firstObject];
        FWDUMP(@"detail: %@", businessEntity);
        [detailView assign:@"businessDetail" value:businessEntity];
        [detailView display];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)actionSendMsg
{
    BusinessAddViewController *viewController = [[BusinessAddViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)deleteBusiness:(BusinessEntity *)business
{
    [self showLoading:[FWLocale system:@"Request.Start"]];
    
    BusinessHandler *businessHandler = [[BusinessHandler alloc] init];
    [businessHandler deleteBusiness:business param:nil success:^(NSArray *result) {
        [self hideLoading];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

@end
