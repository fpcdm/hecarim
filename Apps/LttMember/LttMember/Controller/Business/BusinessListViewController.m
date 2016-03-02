//
//  BusinessListViewController.m
//  LttMember
//
//  Created by wuyong on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessListViewController.h"
#import "BusinessListView.h"
#import "BusinessEntity.h"
#import "BusinessHandler.h"
#import "BusinessViewController.h"

@interface BusinessListViewController () <BusinessListViewDelegate>

@end

@implementation BusinessListViewController
{
    BusinessListView *listView;
    NSMutableArray *businessList;
    
    //当前页数
    int page;
    BOOL hasMore;
}

- (void)loadView
{
    listView = [[BusinessListView alloc] init];
    listView.delegate = self;
    self.view = listView;
}

- (void)viewDidLoad {
    showTabBar = YES;
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"微商";
    
    //默认值
    businessList = [NSMutableArray array];
    page = 0;
    hasMore = YES;
}

- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //分页加载
    page++;
    
    BusinessHandler *businessHandler = [[BusinessHandler alloc] init];
    NSDictionary *param = @{@"page":[NSNumber numberWithInt:page], @"pagesize":[NSNumber numberWithInt:LTT_PAGESIZE_DEFAULT]};
    [businessHandler queryBusinessList:param success:^(NSArray *result) {
        for (BusinessEntity *business in result) {
            [businessList addObject:business];
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
        
        [listView assign:@"businessList" value:businessList];
        [listView display];
    } failure:^(ErrorEntity *error){
        [tableView stopRefreshLoading];
        
        [self showError:error.message];
    }];
}

- (void)actionDetail:(BusinessEntity *)business
{
    BusinessViewController *viewController = [[BusinessViewController alloc] init];
    viewController.businessId = business.id;
    [self pushViewController:viewController animated:YES];
}

@end
