//
//  IntentionListViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "IntentionListViewController.h"
#import "IntentionListView.h"
#import "IntentionEntity.h"
#import "IntentionViewController.h"
#import "OrderViewController.h"

@interface IntentionListViewController () <IntentionListViewDelegate>

@end

@implementation IntentionListViewController
{
    IntentionListView *listView;
    NSMutableArray *intentionList;
}

- (void)loadView
{
    listView = [[IntentionListView alloc] init];
    listView.delegate = self;
    self.view = listView;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"服务单";
    
    [self loadData];
}

- (void) loadData
{
    //初始化数据
    intentionList = [[NSMutableArray alloc] initWithObjects:nil];
    
    IntentionEntity *intention = [[IntentionEntity alloc] init];
    intention.id = @1;
    intention.createTime = @"2015-06-23 12:12:12";
    intention.status = INTENTION_STATUS_LOCKED;
    intention.details = @[@"购买iPhone6 Plus等商品", @"手机上门服务"];
    [intentionList addObject:intention];
    
    IntentionEntity *intention2 = [[IntentionEntity alloc] init];
    intention2.id = @2;
    intention2.createTime = @"2015-06-23 12:12:12";
    intention2.status = INTENTION_STATUS_SUCCESS;
    intention2.orderNo = @"2";
    intention2.details = @[@"购买iPhone6 Plus等商品"];
    [intentionList addObject:intention2];
    
    [listView setData:@"intentionList" value:intentionList];
    [listView renderData];
}

#pragma mark - Action
- (void)actionDetail:(IntentionEntity *)intention
{
    //是否有订单
    if (intention.orderNo && [intention.orderNo floatValue] > 0.0) {
        OrderViewController *viewController = [[OrderViewController alloc] init];
        viewController.orderNo = intention.orderNo;
        [self pushViewController:viewController animated:YES];
    } else {
        IntentionViewController *viewController = [[IntentionViewController alloc] init];
        viewController.intentionId = intention.id;
        [self pushViewController:viewController animated:YES];
    }
}

@end
