//
//  IntentionListView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseListView.h"

@implementation CaseListView
{
    UIView *headerView;
    
    NSArray *buttonList;
}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    
    //初始化header
    headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    headerView.layer.borderWidth = 0.5f;
    self.tableView.tableHeaderView = headerView;
    
    //初始化按钮
    buttonList = @[
                  @{@"name": @"待接单", @"tag": @1, @"status": CASE_STATUS_NEW},
                  @{@"name": @"已接单", @"tag": @2, @"status": CASE_STATUS_LOCKED},
                  @{@"name": @"服务中", @"tag": @3, @"status": CASE_STATUS_CONFIRMED},
                  @{@"name": @"服务完成", @"tag": @4, @"status": CASE_STATUS_TOPAY},
                  @{@"name": @"已结束", @"tag": @5, @"status": @"finished"}
                  ];
    
    CGFloat buttonWidth = SCREEN_WIDTH / 5.0;
    CGFloat x = 0.0;
    for (NSDictionary *buttonDict in buttonList) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, buttonWidth, 30)];
        NSNumber *tag = [buttonDict objectForKey:@"tag"];
        button.tag = [tag integerValue];
        [button setTitle:[buttonDict objectForKey:@"name"] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionLoadCase:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = FONT_MAIN;
        [headerView addSubview:button];
        
        x += buttonWidth;
        
        //默认按钮
        if (!self.defaultButton) {
            self.defaultButton = button;
        }
    }
    
    //初始化空视图
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 20)];
    emptyLabel.font = [UIFont systemFontOfSize:18];
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"你还没有相关订单";
    self.tableView.emptyView = emptyLabel;
    
    [self.tableView setRefreshingHeader:self action:@selector(actionRefresh)];
    [self.tableView setLoadingFooter:self action:@selector(actionLoadMore)];
    
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
- (void)actionLoadCase:(UIButton *)sender
{
    //获取按钮对应状态
    NSString *status = nil;
    for (NSDictionary *buttonDict in buttonList) {
        NSNumber *tag = [buttonDict objectForKey:@"tag"];
        if ([tag isEqualToNumber:[NSNumber numberWithInteger:sender.tag]]) {
            status = [buttonDict objectForKey:@"status"];
            break;
        }
    }
    
    [self.delegate actionLoadCase:sender status:status];
}

- (void)actionLoadMore
{
    [self.delegate actionLoadMore];
}

- (void)actionRefresh
{
    [self.delegate actionRefresh];
}

- (void)actionDetail:(NSDictionary *)cellData
{
    CaseEntity *intention = [cellData objectForKey:@"data"];
    
    [self.delegate actionDetail:intention];
}

@end
