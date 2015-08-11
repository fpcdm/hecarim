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
    
    //初始化表格
    listView = [[ServiceListView alloc] init];
    listView.frame = CGRectMake(0, 0, SCREEN_WIDTH, containerHeight);
    [$(@"#tableContainer").firstView addSubview:listView];
}

#pragma mark - reloadData
- (void) reloadData
{
    [super reloadData];
    
    [listView setData:@"services" value:services];
    [listView renderData];
    
    //切换控件
    if (listView.tableView.editing == YES) {
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
//编辑表格
- (void) actionEditTable: (UIBarButtonItem *) barButtonItem
{
    //编辑
    if (listView.tableView.editing == NO) {
        listView.tableView.editing = YES;
        
        [barButtonItem setTitle:@"完成"];
        
        [self reloadData];
    } else {
        listView.tableView.editing = NO;
        
        [barButtonItem setTitle:@"编辑"];
        
        [self reloadData];
    }
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

}

- (void) actionDeleteServices: (SamuraiSignal *) signal
{
    //检查选中
    //if ([selectedCells count] < 1) {
        //[self showError:@"请选择要删除的商品哦~亲！"];
        //return;
    //}
    
    //整理删除的行批量删除
    services = [[NSMutableArray alloc] init];
    
    [self reloadData];
}

@end
