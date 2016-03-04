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
    
    NSString *cityCode;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //检查城市是否改变
    BOOL isCityChanged = NO;
    NSString *newCityCode = [[StorageUtil sharedStorage] getCityCode];
    if (cityCode && newCityCode && ![newCityCode isEqualToString:cityCode]) {
        isCityChanged = YES;
        cityCode = newCityCode;
    } else {
        cityCode = newCityCode;
    }
    
    //城市改变重新加载
    if (isCityChanged) {
        [self refreshData];
    }
}

- (void)refreshData
{
    //清空之前的数据
    if (businessList && [businessList count] > 0) {
        businessList = [[NSMutableArray alloc] init];
        [listView assign:@"businessList" value:businessList];
        [listView display];
    }
    
    //还原数据
    businessList = [[NSMutableArray alloc] init];
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
