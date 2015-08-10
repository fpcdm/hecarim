//
//  CaseListActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListActivity.h"
#import "MJRefreshScrollView.h"
#import "CaseEntity.h"
#import "CaseHandler.h"
#import "CaseDetailActivity.h"

@interface CaseListActivity ()

@property (nonatomic, strong) UITableView *list;
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
    
    //返回页面是否需要刷新
    BOOL needRefresh;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.onSignal( UITableView.eventPullToRefresh, ^{
        [self refresh];
    });
    
    self.onSignal( UITableView.eventLoadMore, ^{
        [self loadMore];
    });
}

//自动刷新服务单
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (currentStatus && currentButton) {
        //返回时需要刷新
        if (needRefresh) {
            needRefresh = NO;
            [self actionCaseList:currentButton status:currentStatus];
        }
    //默认加载待接单
    } else {
        [self actionCaseList:_defaultButton status:CASE_STATUS_NEW];
    }
}

- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //分页加载
    page++;
    
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    NSDictionary *param = @{@"page":[NSNumber numberWithInt:page],
                            @"pagesize":[NSNumber numberWithInt:LTT_PAGESIZE_DEFAULT],
                            @"status": currentStatus
                            };
    NSLog(@"request param: %@", param);
    
    [caseHandler queryCases:param success:^(NSArray *result){
        for (CaseEntity *intention in result) {
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

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
    //设置表格高度
    float availableHeight = SCREEN_AVAILABLE_HEIGHT - 30;
    $(_list).ATTR(@"height", [NSString stringWithFormat:@"%lfpx", availableHeight]);
    
    //下拉刷新
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
    self.scope[@"list" ] = @{
                                   
                                   @"cases" : ({
                                       NSMutableArray *cases = [NSMutableArray array];
                                       
                                       for (CaseEntity *intention in caseList) {
                                           [cases addObject: @{
                                                               @"no": intention.no,
                                                               @"status": intention.status,
                                                               @"statusName": [intention statusName],
                                                               @"statusColor": [intention statusColor],
                                                               @"time": [intention.createTime substringToIndex:16],
                                                               @"name": intention.buyerName ? intention.buyerName : @"-",
                                                               @"mobile": intention.buyerMobile
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
        $(currentButton).ATTR(@"color", @"black");
    }
    
    //新的选中
    $(button).ATTR(@"color", @"gray");
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

#pragma mark - 需求详情
- (void)actionCaseDetail: (SamuraiSignal *)signal
{
    //获取数据
    CaseEntity *intention = [caseList objectAtIndex:signal.sourceIndexPath.row];
    
    //失败不让跳转
    if ([intention isFail]) return;
    
    //显示需求
    CaseDetailActivity *viewController = [[CaseDetailActivity alloc] init];
    viewController.caseId = intention.id;
    viewController.callbackBlock = ^(id object){
        //标记可刷新
        if (object && [@1 isEqualToNumber:object]) {
            needRefresh = YES;
        }
    };
    [self pushViewController:viewController animated:YES];
}

@end
