//
//  BusinessListView.m
//  LttMember
//
//  Created by wuyong on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessListView.h"

@implementation BusinessListView

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
- (CGFloat) adjustTextHeight:(NSString *)content
{
    if (!content || content.length < 1) return 0;
    
    CGSize size = [content boundingSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) withFont:FONT_MAIN];
    return size.height;
}

- (void)display
{
    //显示数据
    NSMutableArray *businessList = [self fetch:@"businessList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    if (businessList != nil) {
        for (BusinessEntity *business in businessList) {
            //计算高度
            CGFloat textHeight = [self adjustTextHeight:business.content];
            CGFloat cellHeight = 50 + textHeight;
            
            [tableData addObject:@{@"type" : @"custom", @"action": @"actionDetail:", @"height": @(cellHeight), @"data": business}];
        }
    }
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData, nil];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    BusinessEntity *business = [cellData objectForKey:@"data"];
    
    //公司名称
    UILabel *merchantLabel = [[UILabel alloc] init];
    merchantLabel.font = FONT_MAIN;
    merchantLabel.textColor = [UIColor colorWithHex:@"#0099CC"];
    merchantLabel.text = business.merchantName;
    [cell addSubview:merchantLabel];
    
    UIView *superview = cell;
    [merchantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@16);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = FONT_MAIN;
    contentLabel.textColor = COLOR_MAIN_BLACK;
    contentLabel.numberOfLines = 0;
    contentLabel.text = business.content;
    [cell addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(merchantLabel.mas_bottom).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.bottom.equalTo(superview.mas_bottom).offset(-10);
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
    BusinessEntity *business = [cellData objectForKey:@"data"];
    
    [self.delegate actionDetail:business];
}

@end
