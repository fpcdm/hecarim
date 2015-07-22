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
#import "Masonry.h"

@interface CaseListActivity ()

@property (nonatomic, strong) MJRefreshCollectionView *list;
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
    [super viewDidLoad];
    
    self.onSignal( MJRefreshCollectionView.eventPullToRefresh, ^{
        [self refresh];
    });
    
    self.onSignal( MJRefreshCollectionView.eventLoadMore, ^{
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

#pragma mark -

- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
    [_list loadRefreshingHeader];
    [_list loadLoadingFooter];
    
    //空视图
    [self initEmptyView];
    
    //默认加载待接单
    [self actionCaseList:_defaultButton status:CASE_STATUS_NEW];
}

- (void) initEmptyView
{
    UIView *emptyView = [[UIView alloc] init];
    emptyView.backgroundColor = COLOR_MAIN_WHITE;
    _list.emptyView = emptyView;
    
    UIView *superview = _list;
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(100);
        make.centerX.equalTo(superview.mas_centerX);
        
        make.width.equalTo(@80);
        make.height.equalTo(@80);
    }];
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
        
        //测试
        if ([currentStatus isEqualToString:CASE_STATUS_NEW]) {
            caseList = [NSMutableArray array];
            hasMore = NO;
        } else if ([currentStatus isEqualToString:CASE_STATUS_LOCKED]) {
            IntentionEntity *intention = [caseList objectAtIndex:0];
            caseList = [[NSMutableArray alloc] initWithObjects:intention, nil];
            hasMore = NO;
        }
        
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
        
        //测试
        if ([currentStatus isEqualToString:CASE_STATUS_NEW]) {
            caseList = [NSMutableArray array];
            hasMore = NO;
        } else if ([currentStatus isEqualToString:CASE_STATUS_LOCKED]) {
            IntentionEntity *intention = [caseList objectAtIndex:0];
            caseList = [[NSMutableArray alloc] initWithObjects:intention, nil];
            hasMore = NO;
        }
        
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

#pragma mark - 需求详情
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
