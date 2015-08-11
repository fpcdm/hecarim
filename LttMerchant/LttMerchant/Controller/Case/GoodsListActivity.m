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
#import "DLRadioButton.h"

@interface GoodsListActivity ()

@property (nonatomic, strong) UITableView *listTable;

@end

@implementation GoodsListActivity
{
    //返回页面是否需要刷新
    BOOL needRefresh;
    
    //右侧按钮
    UIBarButtonItem *editButtonItem;
    
    //商品列表
    NSMutableArray *goodsList;
    
    //选中列表
    NSMutableArray *selectedCells;
}

@synthesize intention;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    //第一次需要刷新
    needRefresh = YES;
    
    //选中列表
    selectedCells = [[NSMutableArray alloc] init];
    
    //编辑按钮
    editButtonItem = [AppUIUtil makeBarButtonItem:@"编辑" highlighted:YES];
    editButtonItem.target = self;
    editButtonItem.action = @selector(actionEditTable);
    self.navigationItem.rightBarButtonItem = editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (needRefresh) {
        needRefresh = NO;
        [self loadCase];
    }
}

- (NSString *)templateName
{
    return @"goodsList.html";
}

#pragma mark - Template
- (void) onTemplateLoaded
{
    //动态计算表格高度
    float tableHeight = SCREEN_AVAILABLE_HEIGHT - 110;
    $(@"#listTable").ATTR(@"height", [NSString stringWithFormat:@"%lfpx", tableHeight]);
    
    //显示添加按钮
    $(@"#addButton").ATTR(@"visibility", @"visbile");
}

#pragma mark - reloadData
- (void) reloadData
{
    //初始化数据
    if (!goodsList) {
        goodsList = [NSMutableArray arrayWithArray:intention.goods ? intention.goods : @[]];
    }
    
    [super reloadData];
    
    BOOL editing = self.listTable.editing ? YES : NO;
    
    NSInteger goodsCount = [goodsList count];
    self.scope[@"list"] = @{
                                   
                                   @"goods":({
                                       NSMutableArray *returnList = [NSMutableArray array];
                                       
                                       if (goodsCount > 0) {
                                           for (GoodsEntity *goods in goodsList) {
                                               [returnList addObject:@{
                                                                      @"editing": editing ? @1 : @0,
                                                                      @"name": goods.name,
                                                                      @"number": goods.number,
                                                                      @"numberStr": [NSString stringWithFormat:@"x%@", goods.number],
                                                                      @"price": [NSString stringWithFormat:@"￥%@", goods.price],
                                                                      @"specName": goods.specName
                                                                      }];
                                           }
                                       }
                                       
                                       returnList;
                                       
                                   })};
    
    [self.listTable reloadData];
    
    //切换控件
    if (editing) {
        $(@"#addButton").ATTR(@"visibility", @"hidden");
        $(@"#editButton").ATTR(@"visibility", @"visbile");
    } else {
        $(@"#addButton").ATTR(@"visibility", @"visible");
        $(@"#editButton").ATTR(@"visibility", @"hidden");
    }
    
    //重新布局
    [self relayout];
}

#pragma mark - Action
//数量操作
- (void) actionGoodsNumberPlus: (SamuraiSignal *) signal
{
    GoodsEntity *goods = [goodsList objectAtIndex:signal.sourceIndexPath.row];
    
    NSInteger number = [goods.number integerValue];
    number++;
    goods.number = [NSNumber numberWithInteger:number];
    
    UILabel *numberLabel = (UILabel *) [$(@"#goodsNumber").views objectAtIndex:signal.sourceIndexPath.row];
    numberLabel.text = [NSString stringWithFormat:@"%ld", number];
}

- (void) actionGoodsNumberMinus: (SamuraiSignal *) signal
{
    GoodsEntity *goods = [goodsList objectAtIndex:signal.sourceIndexPath.row];
    
    NSInteger number = [goods.number integerValue];
    number--;
    if (number < 1) number = 1;
    goods.number = [NSNumber numberWithInteger:number];
    
    UILabel *numberLabel = (UILabel *) [$(@"#goodsNumber").views objectAtIndex:signal.sourceIndexPath.row];
    numberLabel.text = [NSString stringWithFormat:@"%ld", number];
}

//单元格选中操作
- (void) selectTableCell:(UITableViewCell *)cell indexPath: (NSIndexPath *) indexPath selected: (BOOL) selected
{
    if (!cell) {
        cell = [self.listTable cellForRowAtIndexPath:indexPath];
    }
    
    if (selected) {
        cell.selected = YES;
        
        //防止重复添加
        [selectedCells removeObject:indexPath];
        [selectedCells addObject:indexPath];
    } else {
        cell.selected = NO;
        
        [selectedCells removeObject:indexPath];
    }
}

//编辑表格
- (void) actionEditTable
{
    //编辑
    if (self.listTable.editing == NO) {
        self.listTable.editing = YES;
        
        [editButtonItem setTitle:@"完成"];
        
        [self reloadData];
    } else {
        self.listTable.editing = NO;
        
        [editButtonItem setTitle:@"编辑"];
        
        [self reloadData];
    }
}

- (void) actionChooseAll: (SamuraiSignal *) signal
{
    NSArray *indexPaths = [self.listTable indexPathsForVisibleRows];
    DLRadioButton *radioButton = (DLRadioButton *) signal.sourceView;
    
    //是否已经全选
    if ([selectedCells count] == [indexPaths count]) {
        radioButton.selected = NO;
        for (NSIndexPath *indexPath in indexPaths) {
            [self selectTableCell:nil indexPath:indexPath selected:NO];
        }
    } else {
        radioButton.selected = YES;
        for (NSIndexPath *indexPath in indexPaths) {
            [self selectTableCell:nil indexPath:indexPath selected:YES];
        }
    }
}

- (void) actionChooseCell: (SamuraiSignal *) signal
{
    BOOL selected = !signal.sourceTableCell.selected;
    [self selectTableCell:signal.sourceTableCell indexPath:signal.sourceIndexPath selected:selected];
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

- (void) actionDeleteGoods: (SamuraiSignal *) signal
{
    //检查选中
    if ([selectedCells count] < 1) {
        [self showError:@"请选择要删除的商品哦~亲！"];
        return;
    }
    
    //整理删除的行批量删除
    NSMutableArray *deleteGoods = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in selectedCells) {
        GoodsEntity *goods = [goodsList objectAtIndex:indexPath.row];
        [deleteGoods addObject:goods];
    }
    [goodsList removeObjectsInArray:deleteGoods];
    
    //重置选中行
    selectedCells = [[NSMutableArray alloc] init];
    
    [self reloadData];
}

@end
