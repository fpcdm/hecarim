//
//  BalanceListView.m
//  LttMember
//
//  Created by 杨海锋 on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BalanceListView.h"
#import "CaseEntity.h"

@implementation BalanceListView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    [self.tableView setLoadingFooter:self action:@selector(actionLoad)];
    [self.tableView startLoading];
    
    return self;
}

- (void)renderData
{
    //显示数据
    NSMutableArray *intentionList = [self getData:@"intentionList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    if (intentionList != nil) {
        for (CaseEntity *intention in intentionList) {
            [tableData addObject:@{@"id" : @"intention", @"type" : @"custom", @"action": @"", @"height": @65, @"data": intention}];
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
    
    //消费类型
    UILabel *typeLabel = [self makeCellLabel:@"消费"];
    typeLabel.textColor = COLOR_MAIN_BLACK;
    [cell addSubview:typeLabel];
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.height.equalTo(@20);
    }];
    
    //时间
    UILabel *timeLabel = [self makeCellLabel:@"2015-12-08"];
    timeLabel.textColor = COLOR_MAIN_GRAY;
    [cell addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.height.equalTo(@20);
    }];
    
    //状态
    UILabel *balanceLabel = [self makeCellLabel:[NSString stringWithFormat:@"余额：%f",52.00]];
    balanceLabel.textColor = COLOR_MAIN_GRAY;
    [cell addSubview:balanceLabel];
    
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(padding);
        make.bottom.equalTo(superview.mas_bottom).offset(-padding);
    }];
    
    //充值或消费金额
    UILabel *moneyLabel = [self makeCellLabel:@"52.00"];
    moneyLabel.textColor = COLOR_MAIN_BLACK;
    [cell addSubview:moneyLabel];
    
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.mas_bottom).offset(-padding);
        make.right.equalTo(cell.mas_right).offset(-padding);
    }];
    
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
- (void)actionLoad
{
    [self.delegate actionLoad:self.tableView];
}
@end
