//
//  BalanceListViewController.m
//  LttMember
//
//  Created by 杨海锋 on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BalanceListViewController.h"
#import "BalanceListView.h"
#import "CaseHandler.h"

@interface BalanceListViewController ()<BalanceListViewDelegate>

@end

@implementation BalanceListViewController
{
    BalanceListView *listView;
    NSMutableArray *intentionList;
    
    //当前页数
    int page;
    BOOL hasMore;

}

- (void)loadView
{
    listView = [[BalanceListView alloc] init];
    listView.delegate = self;
    self.view = listView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"收支明细";
    
    //默认值
    intentionList = [NSMutableArray array];
    page = 0;
    hasMore = YES;
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
        
        [listView setData:@"intentionList" value:intentionList];
        [listView renderData];
    } failure:^(ErrorEntity *error){
        [tableView stopRefreshLoading];
        
        [self showError:error.message];
    }];
}


@end
