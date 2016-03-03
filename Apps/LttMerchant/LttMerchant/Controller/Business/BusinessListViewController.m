//
//  BusinessListViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessListViewController.h"
#import "BusinessListView.h"
#import "BusinessAddViewController.h"
#import "BusinessHandler.h"
#import "BusinessEntity.h"
#import "BusinessAddViewController.h"
#import "BusinessDetailViewController.h"

@interface BusinessListViewController ()<BusinessListViewDelegate>

@end

@implementation BusinessListViewController
{
    //返回页面是否需要刷新
    BOOL needRefresh;
    BusinessListView *listView;
    NSMutableArray *businessList;
    BusinessEntity *businessEntity;
    
    //当前页数
    int page;
    BOOL hasMore;
}
- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    //第一次需要刷新
    needRefresh = YES;
    
    listView = [[BusinessListView alloc] init];
    listView.delegate = self;
    self.view = listView;
    
    self.navigationItem.title = @"生意圈管理";
    
    UIBarButtonItem *sendMsgButton = [AppUIUtil makeBarButtonItem:@"发信息" highlighted:isIndexNavBar];
    sendMsgButton.target = self;
    sendMsgButton.action = @selector(actionSendMsg);
    self.navigationItem.rightBarButtonItem = sendMsgButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    businessList = [NSMutableArray array];
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
    
    BusinessHandler *businessHandler = [[BusinessHandler alloc] init];
    NSDictionary *param = @{@"page":[NSNumber numberWithInt:page],
                            @"page_size":[NSNumber numberWithInt:LTT_PAGESIZE_DEFAULT]
                            };
    NSLog(@"request param: %@", param);
    
    [businessHandler getBusinessList:businessEntity param:param success:^(NSArray *result) {
        for (BusinessEntity *business in result) {
            [businessList addObject:business];
        }
        [listView assign:@"businessList" value:businessList];
        [listView display];
        
        //是否还有更多
        hasMore = [result count] >= LTT_PAGESIZE_DEFAULT ? YES : NO;
        
        success(nil);
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)reloadData
{
    [listView assign:@"businessList" value:businessList];
    [listView display];
    
    //根据数据切换刷新状态
    if (hasMore) {
        [listView.tableView setRefreshLoadingState:RefreshLoadingStateMoreData];
    } else if ([businessList count] < 1) {
        [listView.tableView setRefreshLoadingState:RefreshLoadingStateNoData];
    } else {
        [listView.tableView setRefreshLoadingState:RefreshLoadingStateNoMoreData];
    }
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

- (void)actionDetail:(BusinessEntity *)business
{
    BusinessDetailViewController *viewController = [[BusinessDetailViewController alloc] init];
    viewController.newsId = business.newsId;
    [self pushViewController:viewController animated:YES];
}

- (void)actionSendMsg
{
    BusinessAddViewController *addViewController = [[BusinessAddViewController alloc] init];
    addViewController.callbackBlock = ^(id object){
        //标记可刷新
        if (object && [@1 isEqualToNumber:object]) {
            needRefresh = YES;
        }
    };
    [self pushViewController:addViewController animated:YES];
}

@end
