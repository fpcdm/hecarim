//
//  GoodsListActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsListActivity.h"
#import "GoodsFormActivity.h"
#import "AppUIUtil.h"
#import "GoodsListView.h"
#import "DLRadioButton.h"

@interface GoodsListActivity ()

@property (nonatomic, strong) UITableView *listTable;

@end

@implementation GoodsListActivity
{
    //返回页面是否需要刷新
    BOOL needRefresh;
    
    //表格视图
    GoodsListView *listView;
    
    //服务数据
    NSMutableArray *goodsList;
    
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

- (NSString *)templateName
{
    return @"goodsList.html";
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
    listView = [[GoodsListView alloc] init];
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
    [listView setData:@"goodsList" value:goodsList];
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
    [self showLoading:TIP_REQUEST_MESSAGE];
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler editCaseGoods:postCase success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
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

- (void) actionAddGoods: (SamuraiSignal *) signal
{
    GoodsFormActivity *activity = [[GoodsFormActivity alloc] init];
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
    if (selectedCount >= [goodsList count]) {
        radioButton.selected = NO;
        //获取所有单元格(indexPathsForVisibleRows只含有可见行，不含有滚动后可见的)
        for (int section = 0; section < [goodsList count]; section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [listView.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        //未全选
    } else {
        radioButton.selected = YES;
        //获取所有单元格(indexPathsForVisibleRows只含有可见行，不含有滚动后可见的)
        for (int section = 0; section < [goodsList count]; section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [listView.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void) actionDeleteGoods: (SamuraiSignal *) signal
{
    //检查选中
    NSArray *selectedRows = [listView.tableView indexPathsForSelectedRows];
    NSInteger selectedCount = selectedRows ? [selectedRows count] : 0;
    
    if (selectedCount < 1) {
        [self showError:@"请选择要删除的商品哦~亲！"];
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
    radioButton.selected = NO;
}

@end
