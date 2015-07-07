//
//  IntentionListView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListView.h"
#import "MJRefresh.h"

@implementation CaseListView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //允许滚动
    self.tableView.scrollEnabled = YES;
    
    // 上拉加载更多
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(actionLoad)];
    [footer setTitle:@"加载更多服务单" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"暂无更多服务单" forState:MJRefreshStateNoMoreData];
    self.tableView.footer = footer;
    //开始加载
    [footer beginRefreshing];
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    //结束加载
    [self.tableView.footer endRefreshing];
    
    //显示数据
    NSMutableArray *intentionList = [self getData:@"intentionList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    if (intentionList != nil) {
        for (CaseEntity *intention in intentionList) {
            //计算高度
            long detailCount = intention.details ? [intention.details count] : 0;
            NSNumber *height = [NSNumber numberWithFloat:(50 + detailCount * 20)];
            [tableData addObject:@{@"id" : @"intention", @"type" : @"custom", @"action": @"actionDetail:", @"height": height, @"data": intention}];
        }
    }
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData, nil];
    [self.tableView reloadData];
    
    //无更多数据
    NSNumber *noMoreData = [self getData:@"noMoreData"];
    if (noMoreData && [@1 isEqualToNumber:noMoreData]) {
        [self.tableView.footer noticeNoMoreData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    CaseEntity *intention = [cellData objectForKey:@"data"];
    
    //间距配置
    int padding = 10;
    UIView *superview = cell;
    
    //时间
    UILabel *timeLabel = [self makeCellLabel:intention.createTime];
    timeLabel.font = [UIFont boldSystemFontOfSize:18];
    [cell addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@20);
    }];
    
    //状态
    UILabel *statusLabel = [self makeCellLabel:[intention statusName]];
    statusLabel.textColor = [intention statusColor];
    [cell addSubview:statusLabel];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
    }];
    
    //详情
    NSArray *details = intention.details;
    UIView *relateview = timeLabel;
    
    if (details) {
        for (NSDictionary *detail in details) {
            UILabel *detailLabel = [self makeCellLabel:[detail objectForKey:@"title"]];
            detailLabel.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
            [cell addSubview:detailLabel];
            
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(relateview.mas_bottom).offset(5);
                make.left.equalTo(superview.mas_left).offset(padding);
                
                make.height.equalTo(@20);
            }];
            
            relateview = detailLabel;
        }
    }
    
    return cell;
}

//绘制cell中的label
- (UILabel *) makeCellLabel: (NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    return label;
}

#pragma mark - Action
- (void)actionLoad
{
    [self.delegate actionLoad];
}

- (void)actionDetail:(NSDictionary *)cellData
{
    CaseEntity *intention = [cellData objectForKey:@"data"];
    
    [self.delegate actionDetail:intention];
}

@end
