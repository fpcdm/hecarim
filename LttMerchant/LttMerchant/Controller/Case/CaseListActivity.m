//
//  CaseListActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListActivity.h"
#import "RefreshCollectionView.h"
#import "IntentionEntity.h"
#import "IntentionHandler.h"
#import "ApplyDetailViewController.h"
#import "OrderDetailViewController.h"

@interface CaseListActivity ()

@property (nonatomic, strong) RefreshCollectionView *list;

@end

@implementation CaseListActivity
{
    NSMutableArray *caseList;
    
    //当前页数
    int page;
    BOOL hasMore;
    NSString *status;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    //默认值
    caseList = [[NSMutableArray alloc] initWithObjects:nil];
    page = 0;
    hasMore = YES;
    
    self.onSignal( RefreshCollectionView.eventLoadMore, ^{
        [self loadMore];
    });
}

- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //分页加载
    page++;
    
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    NSDictionary *param = @{@"page":[NSNumber numberWithInt:page], @"pagesize":[NSNumber numberWithInt:LTT_PAGESIZE_DEFAULT]};
    [intentionHandler queryUserIntentions:param success:^(NSArray *result){
        for (IntentionEntity *intention in result) {
            //没有详情取备注
            if ((!intention.details || [intention.details count] < 1) && intention.remark) {
                intention.details = @[@{@"title": intention.remark}];
            }
            
            [caseList addObject:intention];
        }
        
        //是否还有更多
        hasMore = [result count] >= LTT_PAGESIZE_DEFAULT ? YES : NO;
        
        success(nil);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

- (NSString *)templateName
{
    return @"caseList.html";
}

- (void)viewDidLayoutSubviews
{
    [self relayout];
}

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
    [self refresh];
}

- (void)onTemplateFailed
{
    
}

- (void)onTemplateCancelled
{
    
}

#pragma mark -

//刷新
- (void)refresh
{
    caseList = [[NSMutableArray alloc] initWithObjects:nil];
    page = 0;
    hasMore = YES;
    
    [self loadData:^(id object){
        [self reloadData];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

//重新加载
- (void)loadMore
{
    [self loadData:^(id object){
        [self reloadData];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void)reloadData
{
    self.viewStorage[@"list" ] = @{
                                   
                                   @"cases" : ({
                                       NSMutableArray *cases = [NSMutableArray array];
                                       
                                       for (IntentionEntity *intention in caseList) {
                                           [cases addObject: @{
                                                               @"no": @"123435",
                                                               @"status": [intention statusName],
                                                               @"time": @"2015-06-30",
                                                               @"name": @"姓名",
                                                               @"mobile": @"18875001455"
                                                               }];
                                           
                                       }
                                       
                                       cases;
                                   })
                                   
                                   };
    
    [_list reloadData];
    
    if (hasMore) {
        
    } else {
        [_list stopLoading];
    }
}

#pragma mark -

- (void)actionCaseDetail: (SamuraiSignal *)signal
{
    //获取数据
    IntentionEntity *intention = [caseList objectAtIndex:signal.sourceIndexPath.row];
    
    //失败不让跳转
    if ([intention isFail]) return;
    
    //显示需求
    if (![intention hasOrder]) {
        ApplyDetailViewController *viewController = [[ApplyDetailViewController alloc] init];
        viewController.intentionId = intention.id;
        [self.navigationController pushViewController:viewController animated:YES];
    //显示订单
    } else {
        OrderDetailViewController *viewController = [[OrderDetailViewController alloc] init];
        viewController.orderNo = intention.orderNo;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

@end
