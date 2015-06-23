//
//  IntentionListView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "IntentionListView.h"

@implementation IntentionListView

#pragma mark - RenderData
- (void)renderData
{
    NSMutableArray *intentionList = [self getData:@"intentionList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    
    if (intentionList != nil) {
        for (IntentionEntity *intention in intentionList) {
            //计算高度
            long detailCount = intention.details ? [intention.details count] : 0;
            NSNumber *height = [NSNumber numberWithFloat:(50 + detailCount * 20)];
            [tableData addObject:@{@"id" : @"intention", @"type" : @"custom", @"action": @"actionDetail:", @"height": height, @"data": intention}];
        }
    }
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData, nil];
    
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    IntentionEntity *intention = [cellData objectForKey:@"data"];
    
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
        for (NSString *detail in details) {
            UILabel *detailLabel = [self makeCellLabel:detail];
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
- (void)actionDetail:(NSDictionary *)cellData
{
    IntentionEntity *intention = [cellData objectForKey:@"data"];
    
    [self.delegate actionDetail:intention];
}

@end
