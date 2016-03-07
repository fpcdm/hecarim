//
//  IntentionListViewController.m
//  LttMember
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListViewController.h"
#import "CaseListView.h"
#import "CaseEntity.h"
#import "CaseViewController.h"
#import "CaseHandler.h"

@interface CaseListViewController () <CaseListViewDelegate>

@end

@implementation CaseListViewController
{
    CaseListView *listView;
    NSMutableArray *intentionList;
    
    //当前页数
    int page;
    BOOL hasMore;
}

- (void)loadView
{
    listView = [[CaseListView alloc] init];
    listView.delegate = self;
    self.view = listView;
}

- (void)viewDidLoad {
    showTabBar = YES;
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的服务单";
    
    //默认值
    intentionList = [NSMutableArray array];
    page = 0;
    hasMore = YES;
}

- (void)handleUserChanged
{
    //切换用户重新加载
    [self refreshData];
}

- (void)refreshData
{
    //清空之前的数据
    if (intentionList && [intentionList count] > 0) {
        intentionList = [[NSMutableArray alloc] init];
        [listView assign:@"intentionList" value:intentionList];
        [listView display];
    }
    
    //还原数据
    intentionList = [[NSMutableArray alloc] init];
    page = 0;
    hasMore = YES;
    
    //加载数据
    [listView.tableView setRefreshLoadingState:RefreshLoadingStateMoreData];
    [listView.tableView startLoading];
}

- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //分页加载
    page++;
    
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    NSDictionary *param = @{@"page":[NSNumber numberWithInt:page], @"pagesize":[NSNumber numberWithInt:LTT_PAGESIZE_DEFAULT]};
    [caseHandler queryIntentions:param success:^(NSArray *result){
        for (CaseEntity *intention in result) {
            [intentionList addObject:intention];
        }
        
        //是否还有更多
        hasMore = [result count] >= LTT_PAGESIZE_DEFAULT ? YES : NO;
        
        success(nil);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

#pragma mark - Action
- (void)actionLoad:(UITableView *)tableView
{
    //加载数据
    [self loadData:^(id object){
        [tableView stopRefreshLoading];
        if (!hasMore) {
            [tableView setRefreshLoadingState:RefreshLoadingStateNoMoreData];
        }
        
        [listView assign:@"intentionList" value:intentionList];
        [listView display];
    } failure:^(ErrorEntity *error){
        [tableView stopRefreshLoading];
        
        [self showError:error.message];
    }];
}

- (void)actionDetail:(CaseEntity *)intention
{
    //失败不让跳转
    if ([intention isFail]) return;
    
    CaseViewController *viewController = [[CaseViewController alloc] init];
    viewController.caseId = intention.id;
    [self pushViewController:viewController animated:YES];
}

@end
