//
//  CaseListActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListActivity.h"
#import "MJRefreshScrollView.h"
#import "IntentionEntity.h"
#import "IntentionHandler.h"
#import "ApplyDetailViewController.h"
#import "OrderDetailViewController.h"
#import "AppView.h"

@interface CaseListActivity ()

@property (nonatomic, strong) UICollectionView *list;
@property (nonatomic, strong) UIButton *defaultButton;

@end

@implementation CaseListActivity
{
    NSMutableArray *caseList;
    
    //当前页数
    int page;
    BOOL hasMore;
    NSString *currentStatus;
    UIButton *currentButton;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.onSignal( UICollectionView.eventPullToRefresh, ^{
        [self refresh];
    });
    
    self.onSignal( UICollectionView.eventLoadMore, ^{
        [self loadMore];
    });
}

//自动刷新服务单
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (currentStatus && currentButton) {
        [self actionCaseList:currentButton status:currentStatus];
    //默认加载待接单
    } else {
        [self actionCaseList:_defaultButton status:CASE_STATUS_NEW];
    }
}

- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //分页加载
    page++;
    
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    NSDictionary *param = @{@"page":[NSNumber numberWithInt:page],
                            @"pagesize":[NSNumber numberWithInt:LTT_PAGESIZE_DEFAULT],
                            @"status": currentStatus
                            };
    NSLog(@"request param: %@", param);
    
    [intentionHandler queryCases:param success:^(NSArray *result){
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
    //自动重新布局父视图，解决最后的单元格显示不完全问题
    [self relayout];
}

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
    [_list loadRefreshingHeader];
    [_list loadLoadingFooter];
    
    //初始化空视图
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 20)];
    emptyLabel.font = [UIFont systemFontOfSize:18];
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"你还没有相关订单";
    _list.emptyView = emptyLabel;
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
        [_list stopRefreshLoading];
        
        [self reloadData];
    } failure:^(ErrorEntity *error){
        [_list stopRefreshLoading];
        
        [self showError:error.message];
    }];
}

//重新加载
- (void)loadMore
{
    [self loadData:^(id object){
        [_list stopRefreshLoading];
        
        [self reloadData];
    } failure:^(ErrorEntity *error){
        [_list stopRefreshLoading];
        
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
                                                               @"no": intention.orderNo,
                                                               @"status": intention.status,
                                                               @"statusName": [intention statusName],
                                                               @"statusColor": [intention statusColor],
                                                               @"time": [intention.createTime substringToIndex:16],
                                                               @"name": intention.userName,
                                                               @"mobile": intention.userMobile
                                                               }];
                                           
                                       }
                                       
                                       cases;
                                   })
                                   
                                   };
    
    [_list reloadData];
    
    //根据数据切换刷新状态
    if (hasMore) {
        [_list setRefreshLoadingState:RefreshLoadingStateMoreData];
    } else if ([caseList count] < 1) {
        [_list setRefreshLoadingState:RefreshLoadingStateNoData];
    } else {
        [_list setRefreshLoadingState:RefreshLoadingStateNoMoreData];
    }
}

#pragma mark - 需求列表
- (void)actionCasesNew: (SamuraiSignal *)signal
{
    [self actionCaseList:signal.source status:CASE_STATUS_NEW];
}

- (void)actionCasesLocked: (SamuraiSignal *)signal
{
    [self actionCaseList:signal.source status:CASE_STATUS_LOCKED];
}

- (void)actionCasesInService: (SamuraiSignal *)signal
{
    [self actionCaseList:signal.source status:CASE_STATUS_CONFIRMED];
}

- (void)actionCasesServiced: (SamuraiSignal *)signal
{
    [self actionCaseList:signal.source status:CASE_STATUS_TOPAY];
}

- (void)actionCasesFinished: (SamuraiSignal *)signal
{
    [self actionCaseList:signal.source status:@"finished"];
}

- (void)actionCaseList:(UIButton *)button status: (NSString *) status
{
    //清空之前的选中
    if (currentButton) {
        currentButton.style.color = makeColor(COLOR_MAIN_BLACK);
        [currentButton restyle];
    }
    
    //新的选中
    button.style.color = makeColor(COLOR_MAIN_GRAY);
    [button restyle];
    currentStatus = status;
    currentButton = button;
    
    //清空之前的数据
    if (caseList && [caseList count] > 0) {
        caseList = [[NSMutableArray alloc] initWithObjects:nil];
        [self reloadData];
    }
    
    //还原数据
    caseList = [[NSMutableArray alloc] initWithObjects:nil];
    page = 0;
    hasMore = YES;
    
    //加载数据
    [_list setRefreshLoadingState:RefreshLoadingStateMoreData];
    [_list startLoading];
}

#pragma mark - 需求操作
//抢单
- (void) actionCompeteCase: (SamuraiSignal *)signal
{
    //获取数据
    IntentionEntity *intention = [caseList objectAtIndex:signal.sourceIndexPath.row];
    
    //开始抢单
    [self showLoading:LocalString(@"TIP_CHALLENGE_START")];
    
    //调用接口
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    [intentionHandler competeIntention:intention success:^(NSArray *result){
        [self loadingSuccess:LocalString(@"TIP_CHALLENGE_SUCCESS") callback:^{
            //跳转需求详情
            ApplyDetailViewController *viewController = [[ApplyDetailViewController alloc] init];
            viewController.intentionId = intention.id;
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:LocalString(@"TIP_CHALLENGE_FAIL")];
    }];
}

#pragma mark - 需求详情
- (void)actionCaseDetail: (SamuraiSignal *)signal
{
    //获取数据
    IntentionEntity *intention = [caseList objectAtIndex:signal.sourceIndexPath.row];
    
    //失败不让跳转
    if ([intention isFail]) return;
    
    //抢单没有详情
    if ([CASE_STATUS_NEW isEqualToString:intention.status]) return;
    
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
