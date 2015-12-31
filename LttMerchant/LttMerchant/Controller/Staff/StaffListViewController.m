//
//  StaffListViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/29.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "StaffListViewController.h"
#import "StaffListView.h"
#import "StaffEntity.h"
#import "StaffHandler.h"
#import "StaffFormViewController.h"
#import "StaffDetailViewController.h"

@interface StaffListViewController ()<StaffListViewDelegate>

@end

@implementation StaffListViewController
{
    NSMutableArray *staffList;
    StaffListView *listView;
    
    //当前页数
    int page;
    BOOL hasMore;
}

- (void)loadView
{
    listView = [[StaffListView alloc] init];
    listView.delegate = self;
    self.view = listView;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"员工管理";
    
    UIBarButtonItem *addButton = [AppUIUtil makeBarButtonItem:@"添加" highlighted:isIndexNavBar];
    addButton.target = self;
    addButton.action = @selector(actionAdd);
    self.navigationItem.rightBarButtonItem = addButton;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    staffList = [NSMutableArray array];
    [self reloadData];
    
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
    hasMore = YES;
    
    StaffHandler *staffHandler = [[StaffHandler alloc] init];
    NSDictionary *param = @{@"page":[NSNumber numberWithInt:page],
                            @"offset":[NSNumber numberWithInt:LTT_PAGESIZE_DEFAULT * 2]
                            };
    NSLog(@"request param: %@", param);
    
    [staffHandler getStaffList:param success:^(NSArray *result) {
        for (StaffEntity *staff in result) {
            [staffList addObject:staff];
        }
        
        //是否还有更多
        hasMore = [result count] >= LTT_PAGESIZE_DEFAULT ? YES : NO;
        
        success(nil);

    } failure:^(ErrorEntity *error) {
        failure(error);
    }];
    
}

- (void)reloadData
{
    [listView setData:@"staffList" value:staffList];
    [listView renderData];
    
    //根据数据切换刷新状态
    if (hasMore) {
        [listView.tableView setRefreshLoadingState:RefreshLoadingStateMoreData];
    } else if ([staffList count] < 1) {
        [listView.tableView setRefreshLoadingState:RefreshLoadingStateNoData];
    } else {
        [listView.tableView setRefreshLoadingState:RefreshLoadingStateNoMoreData];
    }
}

//加载更多
- (void)actionLoadMore
{
    [self reloadData];
    
    [self loadData:^(id object){
        [listView.tableView stopRefreshLoading];
        
        [self reloadData];
    } failure:^(ErrorEntity *error){
        [listView.tableView stopRefreshLoading];
        
        [self showError:error.message];
    }];
}

- (void)actionDetail:(StaffEntity *)staffEntity
{
    StaffDetailViewController *detailViewController = [[StaffDetailViewController alloc] init];
    detailViewController.staffId = staffEntity.id;
    [self pushViewController:detailViewController animated:YES];
}


- (void)actionAdd
{
    StaffFormViewController *formViewController = [[StaffFormViewController alloc] init];
    [self pushViewController:formViewController animated:YES];
}

@end
