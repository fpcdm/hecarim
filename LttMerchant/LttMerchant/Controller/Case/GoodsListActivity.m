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

@interface GoodsListActivity ()

@property (nonatomic, strong) UITableView *listTable;

@end

@implementation GoodsListActivity
{
    //返回页面是否需要刷新
    BOOL needRefresh;
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
    [self domCss:@"#listTable" name:@"height" value:[NSString stringWithFormat:@"%lfpx", tableHeight]];
}

#pragma mark - reloadData
- (void) reloadData
{
    [super reloadData];
    
    NSInteger goodsCount = intention.goods ? [intention.goods count] : 0;
    self.scope[@"list"] = @{
                                   
                                   @"goods":({
                                       NSMutableArray *goodsList = [NSMutableArray array];
                                       
                                       if (goodsCount > 0) {
                                           for (GoodsEntity *goods in intention.goods) {
                                               [goodsList addObject:@{
                                                                      @"name": goods.name,
                                                                      @"number": [NSString stringWithFormat:@"x%@", goods.number],
                                                                      @"price": [NSString stringWithFormat:@"￥%@", goods.price],
                                                                      @"specName": goods.specName
                                                                      }];
                                           }
                                       }
                                       
                                       goodsList;
                                       
                                   })};
    
    [self.listTable reloadData];
    
    //重新布局
    [self relayout];
}

#pragma mark - Action
- (void) actionEditTable
{
    //self.listTable.allowsMultipleSelectionDuringEditing = YES;
    //[self.listTable setEditing:YES animated:YES];
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

@end
