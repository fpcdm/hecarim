//
//  IntentionListViewController.m
//  LttCustomer
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
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的服务单";
    
    //默认值
    intentionList = [[NSMutableArray alloc] initWithObjects:nil];
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
            //没有详情取备注
            if ((!intention.details || [intention.details count] < 1) && intention.remark) {
                intention.details = @[@{@"title": intention.remark}];
            }
            
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
- (void)actionLoad
{
    //加载数据
    [self loadData:^(id object){
        [listView setData:@"intentionList" value:intentionList];
        [listView setData:@"noMoreData" value:(hasMore ? @0 : @1)];
        [listView renderData];
    } failure:^(ErrorEntity *error){
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
