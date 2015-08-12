//
//  ServiceListActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ServiceListActivity.h"
#import "ServiceFormActivity.h"
#import "ServiceListView.h"
#import "DLRadioButton.h"

@interface ServiceListActivity ()

@end

@implementation ServiceListActivity
{
    //返回页面是否需要刷新
    BOOL needRefresh;
    
    //表格视图
    ServiceListView *listView;
    
    //服务数据
    NSMutableArray *services;
    
    //全选按钮
    DLRadioButton *radioButton;
}

@synthesize intention;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    //第一次需要刷新
    needRefresh = YES;
    
    //编辑按钮
    UIBarButtonItem *editButtonItem = [AppUIUtil makeBarButtonItem:@"编辑" highlighted:YES];
    editButtonItem.target = self;
    editButtonItem.action = @selector(actionEditTable:);
    self.navigationItem.rightBarButtonItem = editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (needRefresh) {
        needRefresh = NO;
        [self loadCase:^(id object){
            //初始化服务列表
            services = [[NSMutableArray alloc] init];
            if (intention.services) {
                for (ServiceEntity *service in intention.services) {
                    [services addObject:service];
                }
            }
            
            //刷新数据
            [self reloadData];
        }];
    }
}

- (NSString *)templateName
{
    return @"serviceList.html";
}

#pragma mark - Template
- (void) onTemplateLoaded
{
    //动态计算表格容器高度
    float containerHeight = SCREEN_AVAILABLE_HEIGHT - 120;
    $(@"#tableContainer").ATTR(@"height", [NSString stringWithFormat:@"%lfpx", containerHeight]);
    
    //显示添加按钮
    $(@"#addButton").ATTR(@"visibility", @"visbile");
    
    //全选按钮样式
    radioButton = (DLRadioButton *) $(@"#radioButton").firstView;
    radioButton.iconColor = [UIColor colorWithHexString:@"CBCBCB"];
    radioButton.iconSize = 18;
    radioButton.iconStrokeWidth = 1.0f;
    
    //初始化表格
    listView = [[ServiceListView alloc] init];
    listView.frame = CGRectMake(0, 0, SCREEN_WIDTH, containerHeight);
    [$(@"#tableContainer").firstView addSubview:listView];
}

#pragma mark - reloadData
- (void) reloadData
{
    [super reloadData];
    
    //刷新表格
    [self refreshTable];
    
    //切换按钮
    [self toggleButton];
    
    //重新布局
    [self relayout];
}

//刷新表格
- (void) refreshTable
{
    [listView setData:@"services" value:services];
    [listView renderData];
}

//切换按钮
- (void) toggleButton
{
    //切换控件
    if (listView.tableView.editing == YES) {
        $(@"#addButton").ATTR(@"visibility", @"hidden");
        $(@"#editButton").ATTR(@"visibility", @"visbile");
    } else {
        $(@"#addButton").ATTR(@"visibility", @"visible");
        $(@"#editButton").ATTR(@"visibility", @"hidden");
    }
}

#pragma mark - Action
//编辑表格
- (void) actionEditTable: (UIBarButtonItem *) barButtonItem
{
    //编辑
    if (listView.tableView.editing == NO) {
        listView.tableView.editing = YES;
        
        [barButtonItem setTitle:@"完成"];
        
        [self toggleButton];
    } else {
        CallbackBlock callback = ^(id object){
            listView.tableView.editing = NO;
            
            [barButtonItem setTitle:@"编辑"];
            
            [self toggleButton];
        };
        
        //是否含有服务，有则保存
        if (intention.services && [intention.services count] > 0) {
            [self saveServices: callback];
        } else {
            callback(nil);
        }
    }
}

//保存服务
- (void) saveServices: (CallbackBlock) callback
{
    //获取服务列表
    CaseEntity *postCase = [[CaseEntity alloc] init];
    postCase.id = self.caseId;
    
    //当前服务列表
    NSMutableArray *postServices = [[NSMutableArray alloc] init];
    for (ServiceEntity *entity in services) {
        [postServices addObject:entity];
    }
    
    //转换数据
    postCase.services = postServices;
    postCase.servicesParam = [postCase formatFormServices];
    postCase.services = nil;
    
    //提交数据
    [self showLoading:TIP_REQUEST_MESSAGE];
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler editCaseServices:postCase success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            //通知刷新
            if (self.callbackBlock) {
                self.callbackBlock(@1);
            }
            
            //切换按钮
            callback(nil);
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void) actionAddService: (SamuraiSignal *) signal
{
    ServiceFormActivity *activity = [[ServiceFormActivity alloc] init];
    activity.caseId = self.caseId;
    activity.callbackBlock = ^(id object){
        //标记可刷新
        if (object && [@1 isEqualToNumber:object]) {
            needRefresh = YES;
            
            //标记父级可刷新
            if (self.callbackBlock) {
                self.callbackBlock(object);
            }
        }
    };
    [self pushViewController:activity animated:YES];
}

- (void) actionChooseAll: (SamuraiSignal *) signal
{
    NSArray *selectedRows = [listView.tableView indexPathsForSelectedRows];
    NSInteger selectedCount = selectedRows ? [selectedRows count] : 0;
    
    //已经全选
    if (selectedCount >= [services count]) {
        radioButton.selected = NO;
        //获取所有单元格(indexPathsForVisibleRows只含有可见行，不含有滚动后可见的)
        for (int section = 0; section < [services count]; section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [listView.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    //未全选
    } else {
        radioButton.selected = YES;
        //获取所有单元格(indexPathsForVisibleRows只含有可见行，不含有滚动后可见的)
        for (int section = 0; section < [services count]; section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [listView.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void) actionDeleteServices: (SamuraiSignal *) signal
{
    //检查选中
    NSArray *selectedRows = [listView.tableView indexPathsForSelectedRows];
    NSInteger selectedCount = selectedRows ? [selectedRows count] : 0;
    
    if (selectedCount < 1) {
        [self showError:@"请选择要删除的服务哦~亲！"];
        return;
    }
    
    //批量删除数据
    NSMutableIndexSet *deleteIndexs = [NSMutableIndexSet new];
    for (NSIndexPath *indexPath in selectedRows) {
        [deleteIndexs addIndex:indexPath.section];
    }
    [services removeObjectsAtIndexes:deleteIndexs];
    
    //刷新表格
    [self refreshTable];
    
    //取消全选
    radioButton.selected = NO;
}

@end
