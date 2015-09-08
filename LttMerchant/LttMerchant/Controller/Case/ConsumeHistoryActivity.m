//
//  ConsumeHistoryActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/9/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ConsumeHistoryActivity.h"
#import "ConsumeHistoryView.h"
#import "UserHandler.h"

@interface ConsumeHistoryActivity () <ConsumeHistoryViewDelegate>

@end

@implementation ConsumeHistoryActivity
{
    ConsumeHistoryView *historyView;
    NSMutableArray *historyList;
    
    //当前页数
    int page;
    BOOL hasMore;
}

@synthesize intention;

- (void)loadView
{
    historyView = [[ConsumeHistoryView alloc] init];
    historyView.delegate = self;
    self.view = historyView;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"消费记录";
}

//自动刷新服务单
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //还原数据
    historyList = [[NSMutableArray alloc] initWithObjects:nil];
    page = 0;
    hasMore = YES;
    
    //加载数据
    [historyView.tableView setRefreshLoadingState:RefreshLoadingStateMoreData];
    [historyView.tableView startLoading];
}

- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //分页加载
    page++;
    
    UserHandler *userHandler = [[UserHandler alloc] init];
    NSDictionary *param = @{@"page":[NSNumber numberWithInt:page],
                            @"pagesize":[NSNumber numberWithInt:LTT_PAGESIZE_DEFAULT]
                            };
    UserEntity *userEntity = [[UserEntity alloc] init];
    userEntity.id = intention.userId;
    
    [userHandler queryConsumeHistory:userEntity param:param success:^(NSArray *result){
        for (ConsumeEntity *consume in result) {
            [historyList addObject:consume];
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
    [historyView setData:@"intention" value:intention];
    [historyView setData:@"historyList" value:historyList];
    [historyView renderData];
    
    //根据数据切换刷新状态
    if (hasMore) {
        [historyView.tableView setRefreshLoadingState:RefreshLoadingStateMoreData];
    } else if ([historyList count] < 1) {
        [historyView.tableView setRefreshLoadingState:RefreshLoadingStateNoData];
    } else {
        [historyView.tableView setRefreshLoadingState:RefreshLoadingStateNoMoreData];
    }
}

#pragma mark - Action
//加载更多
- (void)actionLoadMore
{
    [self loadData:^(id object){
        [historyView.tableView stopRefreshLoading];
        
        [self reloadData];
    } failure:^(ErrorEntity *error){
        [historyView.tableView stopRefreshLoading];
        
        [self showError:error.message];
    }];
}

//联系下单人
- (void)actionContact
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", intention.userMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

@end
