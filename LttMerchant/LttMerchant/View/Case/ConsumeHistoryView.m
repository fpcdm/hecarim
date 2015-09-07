//
//  ConsumeHistoryView.m
//  LttMerchant
//
//  Created by wuyong on 15/9/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ConsumeHistoryView.h"
#import "CaseEntity.h"

@implementation ConsumeHistoryView
{
    UIView *headerView;
    UIButton *infoButton;
}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    
    //初始化header
    headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    headerView.backgroundColor = COLOR_MAIN_BG;
    self.tableView.tableHeaderView = headerView;
    
    infoButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 40)];
    infoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [infoButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [headerView addSubview:infoButton];
    
    [self.tableView setLoadingFooter:self action:@selector(actionLoadMore)];
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    CaseEntity *intention = [self getData:@"intention"];
    NSString *infoTitle = [NSString stringWithFormat:@"%@（%@ %@）的消费记录",
                           intention.userAppellation ? intention.userAppellation : @"-",
                           intention.userName ? intention.userName : @"-",
                           intention.userMobile ? intention.userMobile : @"-"
                           ];
    [infoButton setTitle:infoTitle forState:UIControlStateNormal];
    
    //显示数据
    NSMutableArray *historyList = [self getData:@"historyList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    if (historyList != nil) {
        for (CaseEntity *intention in historyList) {
            [tableData addObject:@[@{
                                       @"id" : @"intention",
                                       @"type" : @"custom",
                                       @"action": @"actionDetail:",
                                       @"height": @110,
                                       @"data": intention
                                       }]];
        }
    }
    self.tableData = tableData;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    CaseEntity *intention = [cellData objectForKey:@"data"];
    cell.backgroundColor = [UIColor whiteColor];
    
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
    noLabel.font = [UIFont boldSystemFontOfSize:16];
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
        make.top.equalTo(noTitleLabel.mas_bottom).offset(3);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@20);
    }];
    
    //客户联系方式
    UILabel *contactTitle = [self makeCellLabel:@"客户联系方式："];
    contactTitle.textColor = [UIColor colorWithHexString:@"585858"];
    [cell addSubview:contactTitle];
    
    [contactTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(timeLabel.mas_bottom).offset(4);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@20);
    }];
    
    //联系方式
    NSString *contactStr = [NSString stringWithFormat:@"%@（%@）", intention.buyerName ? intention.buyerName : @"-", intention.buyerMobile ? intention.buyerMobile : @"-"];
    UILabel *contactLabel = [self makeCellLabel:contactStr];
    contactLabel.textColor = [UIColor colorWithHexString:@"585858"];
    [cell addSubview:contactLabel];
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(contactTitle.mas_bottom).offset(3);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@20);
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section > 0 ? HEIGHT_TABLE_MARGIN_ZERO : HEIGHT_TABLE_MARGIN_DEFAULT;
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
- (void)actionLoadMore
{
    [self.delegate actionLoadMore];
}

@end
