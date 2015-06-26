//
//  IntentionListViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListViewController.h"
#import "CaseListView.h"
#import "IntentionEntity.h"
#import "IntentionHandler.h"
#import "ApplyDetailViewController.h"
#import "OrderDetailViewController.h"

@interface CaseListViewController () <CaseListViewDelegate>

@end

@implementation CaseListViewController
{
    CaseListView *listView;
    NSMutableArray *intentionList;
}

- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //初始化数据
    intentionList = [[NSMutableArray alloc] initWithObjects:nil];
    
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    NSDictionary *param = @{};
    [intentionHandler queryUserIntentions:param success:^(NSArray *result){
        for (IntentionEntity *intention in result) {
            //没有详情取备注
            if ((!intention.details || [intention.details count] < 1) && intention.remark) {
                intention.details = @[@{@"title": intention.remark}];
            }
            
            [intentionList addObject:intention];
        }
        
        success(nil);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void)loadView
{
    listView = [[CaseListView alloc] init];
    listView.delegate = self;
    self.view = listView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的服务单";
    
    //加载数据
    [self loadData:^(id object){
        [listView setData:@"intentionList" value:intentionList];
        [listView renderData];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

#pragma mark - Action
- (void)actionDetail:(IntentionEntity *)intention
{
    //失败不让跳转
    if ([intention isFail]) return;
    
    //显示需求
    if (![intention hasOrder]) {
        ApplyDetailViewController *viewController = [[ApplyDetailViewController alloc] init];
        viewController.intentionId = intention.id;
        [self.navigationController pushViewController:viewController animated:YES];
    //显示订单
    } else {
        OrderDetailViewController *viewController = [[OrderDetailViewController alloc] init];
        viewController.orderNo = intention.orderNo;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

@end
