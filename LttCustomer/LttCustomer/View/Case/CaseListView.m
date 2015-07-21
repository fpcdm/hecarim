//
//  IntentionListView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListView.h"

@implementation CaseListView

//开启下拉加载更多
- (BOOL) dropToRefresh
{
    return YES;
}

#pragma mark - RenderData
- (void)renderData
{
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
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont boldSystemFontOfSize:18];
    [cell addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@20);
    }];
    
    //状态
    UILabel *statusLabel = [self makeCellLabel:[intention statusName]];
    statusLabel.backgroundColor = [UIColor clearColor];
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
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    return label;
}

#pragma mark - Refresh
- (void) dropRefresh:(RefreshCompletionHandler)completionHandler
{
    [self.delegate actionLoad:completionHandler];
}

#pragma mark - Action
- (void)actionDetail:(NSDictionary *)cellData
{
    CaseEntity *intention = [cellData objectForKey:@"data"];
    
    [self.delegate actionDetail:intention];
}

@end
