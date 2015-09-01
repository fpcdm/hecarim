//
//  CaseListActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListActivity.h"
#import "CaseListView.h"
#import "CaseEntity.h"
#import "CaseHandler.h"
#import "CaseDetailActivity.h"
#import "LocationUtil.h"

@interface CaseListActivity () <CaseListViewDelegate>

@end

@implementation CaseListActivity
{
    CaseListView *listView;
    NSMutableArray *caseList;
    
    //当前页数
    int page;
    BOOL hasMore;
    NSString *currentStatus;
    UIButton *currentButton;
    
    //返回页面是否需要刷新
    BOOL needRefresh;
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
    
    self.navigationItem.title = @"服务单管理";
    
    //刷新gps
    [[LocationUtil sharedInstance] restartUpdate];
}

//自动刷新服务单
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (currentStatus && currentButton) {
        //返回时需要刷新
        if (needRefresh) {
            needRefresh = NO;
            [self actionLoadCase:currentButton status:currentStatus];
        }
    //默认加载待接单
    } else {
        [self actionLoadCase:listView.defaultButton status:CASE_STATUS_NEW];
    }
}

- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //分页加载
    page++;
    
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    NSDictionary *param = @{@"page":[NSNumber numberWithInt:page],
                            @"pagesize":[NSNumber numberWithInt:LTT_PAGESIZE_DEFAULT],
                            @"status": currentStatus
                            };
    NSLog(@"request param: %@", param);
    
    [caseHandler queryCases:param success:^(NSArray *result){
        for (CaseEntity *intention in result) {
            [caseList addObject:intention];
        }
        
        //是否还有更多
        hasMore = [result count] >= LTT_PAGESIZE_DEFAULT ? YES : NO;
        
        success(nil);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (void)reloadData
{
    [listView setData:@"intentionList" value:caseList];
    [listView renderData];
    
    //根据数据切换刷新状态
    if (hasMore) {
        [listView.tableView setRefreshLoadingState:RefreshLoadingStateMoreData];
    } else if ([caseList count] < 1) {
        [listView.tableView setRefreshLoadingState:RefreshLoadingStateNoData];
    } else {
        [listView.tableView setRefreshLoadingState:RefreshLoadingStateNoMoreData];
    }
}

#pragma mark - Action
//加载需求
- (void)actionLoadCase:(UIButton *)button status:(NSString *) status
{
    //清空之前的选中
    if (currentButton) {
        [currentButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    }
    
    //新的选中
    [button setTitleColor:COLOR_MAIN_GRAY forState:UIControlStateNormal];
    currentStatus = status;
    currentButton = button;
    
    //清空之前的数据
    if (caseList && [caseList count] > 0) {
        caseList = [[NSMutableArray alloc] init];
        [self reloadData];
    }
    
    //还原数据
    caseList = [[NSMutableArray alloc] initWithObjects:nil];
    page = 0;
    hasMore = YES;
    
    //加载数据
    [listView.tableView setRefreshLoadingState:RefreshLoadingStateMoreData];
    [listView.tableView startLoading];
}

//加载更多
- (void)actionLoadMore
{
    [self loadData:^(id object){
        [listView.tableView stopRefreshLoading];
        
        [self reloadData];
    } failure:^(ErrorEntity *error){
        [listView.tableView stopRefreshLoading];
        
        [self showError:error.message];
    }];
}

//下拉刷新
- (void)actionRefresh
{
    caseList = [[NSMutableArray alloc] initWithObjects:nil];
    page = 0;
    hasMore = YES;
    
    [self loadData:^(id object){
        [listView.tableView stopRefreshLoading];
        
        [self reloadData];
    } failure:^(ErrorEntity *error){
        [listView.tableView stopRefreshLoading];
        
        [self showError:error.message];
    }];
}

- (void)actionDetail:(CaseEntity *)intention
{
    //失败不让跳转
    if ([intention isFail]) return;
    
    //显示需求
    CaseDetailActivity *viewController = [[CaseDetailActivity alloc] init];
    viewController.caseId = intention.id;
    viewController.callbackBlock = ^(id object){
        //标记可刷新
        if (object && [@1 isEqualToNumber:object]) {
            needRefresh = YES;
        }
    };
    [self pushViewController:viewController animated:YES];
}

@end
