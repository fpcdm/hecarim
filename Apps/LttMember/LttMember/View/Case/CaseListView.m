//
//  IntentionListView.m
//  LttMember
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListView.h"

@implementation CaseListView

@synthesize delegate;

- (BOOL)hasTabBar
{
    return YES;
}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    [self.tableView setRefreshingHeader:self action:@selector(actionRefresh)];
    [self.tableView setLoadingFooter:self action:@selector(actionLoad)];
    [self.tableView startLoading];
    
    return self;
}

#pragma mark - RenderData
- (void)display
{
    //显示数据
    NSMutableArray *intentionList = [self fetch:@"intentionList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    if (intentionList != nil) {
        for (CaseEntity *intention in intentionList) {
            //计算高度
            NSUInteger detailCount = [[intention details] count];
            NSNumber *height = [NSNumber numberWithFloat:(65 + detailCount * 25)];
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
    
    //编号
    UILabel *noTitleLabel = [self makeCellLabel:@"编号："];
    [cell addSubview:noTitleLabel];
    
    [noTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@20);
    }];
    
    UILabel *noLabel = [self makeCellLabel:intention.no];
    noLabel.font = FONT_MAIN_BOLD;
    [cell addSubview:noLabel];
    
    [noLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(noTitleLabel.mas_right);
        
        make.width.equalTo(@180);
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
    
    //时间
    UILabel *timeLabel = [self makeCellLabel:intention.createTime];
    timeLabel.textColor = [UIColor grayColor];
    [cell addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(noTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@20);
    }];
    
    //详情
    NSArray *details = [intention details];
    UIView *relateview = timeLabel;
    
    if (details) {
        for (NSString *detail in details) {
            UILabel *detailLabel = [self makeCellLabel:detail];
            detailLabel.textColor = COLOR_MAIN_BLACK;
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

//让分割线左侧不留空白
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//绘制cell中的label
- (UILabel *) makeCellLabel: (NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_MAIN;
    return label;
}

#pragma mark - Action
- (void)actionRefresh
{
    [self.delegate actionRefresh:self.tableView];
}

- (void)actionLoad
{
    [self.delegate actionLoad:self.tableView];
}

- (void)actionDetail:(NSDictionary *)cellData
{
    CaseEntity *intention = [cellData objectForKey:@"data"];
    
    [self.delegate actionDetail:intention];
}

@end
