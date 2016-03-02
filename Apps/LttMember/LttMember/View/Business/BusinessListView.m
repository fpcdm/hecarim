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
    [self.tableView setLoadingFooter:self action:@selector(actionLoad)];
    [self.tableView startLoading];
    
    return self;
}

#pragma mark - RenderData
- (void)display
{
    //显示数据
    NSMutableArray *businessList = [self fetch:@"businessList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    if (businessList != nil) {
        for (BusinessEntity *business in businessList) {
            //计算高度
            NSNumber *height = @50;
            [tableData addObject:@{@"type" : @"custom", @"action": @"actionDetail:", @"height": height, @"data": business}];
        }
    }
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData, nil];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    BusinessEntity *business = [cellData objectForKey:@"data"];
    
    UIView *superview = cell;
    
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
