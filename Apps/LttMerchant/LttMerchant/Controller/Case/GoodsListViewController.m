//
//  GoodsListViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsFormViewController.h"
#import "AppUIUtil.h"
#import "DLRadioButton.h"
#import "GoodsView.h"

@interface GoodsListViewController ()<GoodsViewDelegate>

@end

@implementation GoodsListViewController
{
    //返回页面是否需要刷新
    BOOL needRefresh;
    
    //商品列表
    GoodsView *goodsView;
    
    //服务数据
    NSMutableArray *goodsList;
}

@synthesize intention;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    //第一次需要刷新
    needRefresh = YES;
    
    goodsView = [[GoodsView alloc] init];
    goodsView.delegate = self;
    self.view = goodsView;
    self.view.backgroundColor= COLOR_MAIN_BG;
    
    //编辑按钮
    UIBarButtonItem *editButtonItem = [AppUIUtil makeBarButtonItem:@"编辑" highlighted:YES];
    editButtonItem.target = self;
    editButtonItem.action = @selector(actionEditTable:);
    self.navigationItem.rightBarButtonItem = editButtonItem;
    self.navigationItem.title = @"商品列表";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (needRefresh) {
        needRefresh = NO;
        [self loadCase:^(id object){
            //初始化商品列表
            goodsList = [[NSMutableArray alloc] init];
            if (intention.goods) {
                for (GoodsEntity *goods in intention.goods) {
                    [goodsList addObject:goods];
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
    
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.no = self.intention.no;
    caseEntity.status = self.intention.status;
    [goodsView assign:@"caseEntity" value:caseEntity];
    [goodsView setCaseNo];
    
    //切换按钮
    [self toggleButton];
}

//刷新表格
- (void) refreshTable
{
    [goodsView assign:@"goodsList" value:goodsList];
    [goodsView display];
}

//切换按钮
- (void) toggleButton
{
    //切换控件
    if (goodsView.listView.editing == YES) {
        [goodsView setButtonAndButtomShowHide:YES];
    } else {
        [goodsView setButtonAndButtomShowHide:NO];
    }
}

#pragma mark - Action
//编辑表格
- (void) actionEditTable: (UIBarButtonItem *) barButtonItem
{
    //编辑
    if (goodsView.listView.editing == NO) {
        goodsView.listView.editing = YES;
        
        [barButtonItem setTitle:@"完成"];
        
        [self toggleButton];
    } else {
        CallbackBlock callback = ^(id object){
            goodsView.listView.editing = NO;
            
            [barButtonItem setTitle:@"编辑"];
            
            [self toggleButton];
        };
        
        //是否含有商品，有则保存
        if (intention.goods && [intention.goods count] > 0) {
            [self saveGoods: callback];
        } else {
            callback(nil);
        }
    }
}

//保存商品
- (void) saveGoods: (CallbackBlock) callback
{
    //获取服务列表
    CaseEntity *postCase = [[CaseEntity alloc] init];
    postCase.id = self.caseId;
    
    //当前服务列表
    NSMutableArray *postGoods = [[NSMutableArray alloc] init];
    for (GoodsEntity *entity in goodsList) {
        [postGoods addObject:entity];
    }
    
    //转换数据
    postCase.goods = postGoods;
    postCase.goodsParam = [postCase formatFormGoods];
    postCase.goods = nil;
    
    //提交数据
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler editCaseGoods:postCase success:^(NSArray *result){
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

- (void) actionAddGoods
{
    GoodsFormViewController *activity = [[GoodsFormViewController alloc] init];
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

- (void) actionChooseAll: (DLRadioButton *) radio
{
    NSArray *selectedRows = [goodsView.listView.tableView indexPathsForSelectedRows];
    NSInteger selectedCount = selectedRows ? [selectedRows count] : 0;
    
    //已经全选
    if (selectedCount >= [goodsList count]) {
        radio.selected = NO;
        //获取所有单元格(indexPathsForVisibleRows只含有可见行，不含有滚动后可见的)
        for (int section = 0; section < [goodsList count]; section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [goodsView.listView.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        //未全选
    } else {
        radio.selected = YES;
        //获取所有单元格(indexPathsForVisibleRows只含有可见行，不含有滚动后可见的)
        for (int section = 0; section < [goodsList count]; section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [goodsView.listView.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void) actionDeleteGoods: (DLRadioButton *) radio
{
    //检查选中
    NSArray *selectedRows = [goodsView.listView.tableView indexPathsForSelectedRows];
    NSInteger selectedCount = selectedRows ? [selectedRows count] : 0;
    
    if (selectedCount < 1) {
        [self showError:[LocaleUtil error:@"DeletedGoods.Required"]];
        return;
    }
    
    //批量删除数据
    NSMutableIndexSet *deleteIndexs = [NSMutableIndexSet new];
    for (NSIndexPath *indexPath in selectedRows) {
        [deleteIndexs addIndex:indexPath.section];
    }
    [goodsList removeObjectsAtIndexes:deleteIndexs];
    
    //刷新表格
    [self refreshTable];
    
    //取消全选
    radio.selected = NO;
}

- (void)actionBackList
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
