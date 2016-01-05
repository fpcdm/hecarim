//
//  ServiceListViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ServiceListViewController.h"
#import "ServiceFormViewController.h"
#import "DLRadioButton.h"
#import "ServiceView.h"

@interface ServiceListViewController ()<ServiceViewDelegate>

@end

@implementation ServiceListViewController
{
    //返回页面是否需要刷新
    BOOL needRefresh;
    
    //服务数据
    NSMutableArray *services;
    
    //服务列表
    ServiceView *serviceView;
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
    
    serviceView = [[ServiceView alloc] init];
    serviceView.delegate = self;
    self.view = serviceView;
    self.view.backgroundColor = COLOR_MAIN_BG;
    
    self.navigationItem.rightBarButtonItem = editButtonItem;
    self.navigationItem.title = @"服务列表";
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


#pragma mark - reloadData
- (void) reloadData
{
    //刷新表格
    [self refreshTable];
    
    //切换按钮
    [self toggleButton];
    
    //设置头部信息
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.no = self.intention.no;
    caseEntity.status = self.intention.status;
    [serviceView setData:@"caseEntity" value:caseEntity];
    [serviceView setCaseNo];
}

//刷新表格
- (void) refreshTable
{
    [serviceView setData:@"services" value:services];
    [serviceView renderData];
}

//切换按钮
- (void) toggleButton
{
    //切换控件
    if (serviceView.listView.tableView.editing == YES) {
        [serviceView setButtonAndButtomShowHide:YES];
    } else {
        [serviceView setButtonAndButtomShowHide:NO];
    }
}

#pragma mark - Action
//编辑表格
- (void) actionEditTable: (UIBarButtonItem *) barButtonItem
{
    //编辑
    if (serviceView.listView.tableView.editing == NO) {
        serviceView.listView.tableView.editing = YES;
        
        [barButtonItem setTitle:@"完成"];
        
        [self toggleButton];
    } else {
        CallbackBlock callback = ^(id object){
            serviceView.listView.tableView.editing = NO;
            
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
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler editCaseServices:postCase success:^(NSArray *result){
        [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
            //通知重新加载，解决单元格减少问题
            if (self.callbackBlock) {
                self.callbackBlock(@2);
            }
            
            //切换按钮
            callback(nil);
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void) actionAddService
{
    ServiceFormViewController *activity = [[ServiceFormViewController alloc] init];
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

- (void) actionChooseAll:(DLRadioButton *)radio
{
    NSArray *selectedRows = [serviceView.listView.tableView indexPathsForSelectedRows];
    NSInteger selectedCount = selectedRows ? [selectedRows count] : 0;
    
    //已经全选
    if (selectedCount >= [services count]) {
        radio.selected = NO;
        //获取所有单元格(indexPathsForVisibleRows只含有可见行，不含有滚动后可见的)
        for (int section = 0; section < [services count]; section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [serviceView.listView.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    //未全选
    } else {
        radio.selected = YES;
        //获取所有单元格(indexPathsForVisibleRows只含有可见行，不含有滚动后可见的)
        for (int section = 0; section < [services count]; section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [serviceView.listView.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void) actionDeleteServices: (DLRadioButton *) radio
{
    //检查选中
    NSArray *selectedRows = [serviceView.listView.tableView indexPathsForSelectedRows];
    NSInteger selectedCount = selectedRows ? [selectedRows count] : 0;
    
    if (selectedCount < 1) {
        [self showError:[LocaleUtil error:@"DeletedServices.Required"]];
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
    radio.selected = NO;
}

@end
