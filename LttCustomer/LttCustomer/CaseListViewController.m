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
}

- (void)preload:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //初始化数据
    intentionList = [[NSMutableArray alloc] initWithObjects:nil];
    
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    NSDictionary *param = @{};
    [caseHandler queryIntentions:param success:^(NSArray *result){
        for (CaseEntity *intention in result) {
            //没有详情取备注
            if ((!intention.details || [intention.details count] < 1) && intention.remark) {
                intention.details = @[@{@"title": intention.remark}];
            }
            
            [intentionList addObject:intention];
        }
        
        success(nil);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
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
    
    [listView setData:@"intentionList" value:intentionList];
    [listView renderData];
}

#pragma mark - Action
- (void)actionDetail:(CaseEntity *)intention
{
    //失败不让跳转
    if ([intention isFail]) return;
    
    CaseViewController *viewController = [[CaseViewController alloc] init];
    viewController.caseId = intention.id;
    [viewController preload:^(id object){
        [self pushViewController:viewController animated:YES];
    } failure:^(id object){}];
}

@end
