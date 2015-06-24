//
//  IntentionListViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListViewController.h"
#import "CaseListView.h"
#import "CaseEntity.h"
#import "CaseViewController.h"

@interface CaseListViewController () <CaseListViewDelegate>

@end

@implementation CaseListViewController
{
    CaseListView *listView;
    NSMutableArray *intentionList;
}

- (void)loadView
{
    listView = [[CaseListView alloc] init];
    listView.delegate = self;
    self.view = listView;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的服务单";
    
    [self loadData];
}

- (void) loadData
{
    //初始化数据
    intentionList = [[NSMutableArray alloc] initWithObjects:nil];
    
    CaseEntity *intention = [[CaseEntity alloc] init];
    intention.id = @1;
    intention.createTime = @"2015-06-23 12:12:12";
    intention.status = CASE_STATUS_LOCKED;
    intention.details = @[@"购买iPhone6 Plus等商品", @"手机上门服务"];
    [intentionList addObject:intention];
    
    CaseEntity *intention2 = [[CaseEntity alloc] init];
    intention2.id = @2;
    intention2.createTime = @"2015-06-23 12:12:12";
    intention2.status = CASE_STATUS_SUCCESS;
    intention2.orderNo = @"2";
    intention2.details = @[@"购买iPhone6 Plus等商品"];
    [intentionList addObject:intention2];
    
    [listView setData:@"intentionList" value:intentionList];
    [listView renderData];
}

#pragma mark - Action
- (void)actionDetail:(CaseEntity *)intention
{
    //失败不让跳转
    if ([intention isFail]) return;
    
    CaseViewController *viewController = [[CaseViewController alloc] init];
    viewController.caseId = intention.id;
    [self pushViewController:viewController animated:YES];
}

@end
