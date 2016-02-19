//
//  RecommendMerchantViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/2/18.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "RecommendMerchantViewController.h"
#import "RecommendMerchantView.h"
#import "UserHandler.h"

@interface RecommendMerchantViewController ()<RecommendMerchantDelegate>

@end

@implementation RecommendMerchantViewController
{
    NSMutableArray *merchantList;
    RecommendMerchantView *listView;
    
    //当前页数
    int page;
    BOOL hasMore;
}

- (void)loadView
{
    listView = [[RecommendMerchantView alloc] init];
    listView.delegate = self;
    self.view = listView;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"我推荐的商户";
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    merchantList = [NSMutableArray array];
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
    
    UserEntity *userEntity = [[UserEntity alloc] init];
    UserHandler *userHandler = [[UserHandler alloc] init];
    NSDictionary *param = @{
                            @"page":[NSNumber numberWithInt:page],
                            @"page_size":[NSNumber numberWithInt:LTT_PAGESIZE_DEFAULT * 2]
                          };
    [FWLog log:@"request param：%@",param];
    
    [userHandler getMyRecommendList:userEntity param:param success:^(NSArray *result) {
        [FWLog log:@"我的推荐人是：%@",result];
        for (UserEntity *user in result) {
            [merchantList addObject:user];
        }
        
        //是否还有更多
        hasMore = [result count] >= LTT_PAGESIZE_DEFAULT * 2 ? YES : NO;
        
        success(nil);
        
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
    
}

- (void)reloadData
{
    [listView assign:@"merchantList" value:merchantList];
    [listView display];
    
    //根据数据切换刷新状态
    if (hasMore) {
        [listView.tableView setRefreshLoadingState:RefreshLoadingStateMoreData];
    } else if ([merchantList count] < 1) {
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

@end
