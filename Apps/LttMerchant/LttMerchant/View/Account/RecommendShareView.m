//
//  RecommendShareView.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/2/18.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "RecommendShareView.h"

@implementation RecommendShareView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = COLOR_MAIN_BG;
    
    
    return self;
    
}

- (void)display
{
    NSNumber *is_admin = [self fetch:@"is_admin"];
    NSMutableArray *tableArray = [NSMutableArray array];
    if ([@1 isEqualToNumber:is_admin]) {
        tableArray = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"recommend", @"type" : @"action", @"action": @"actionRecommend", @"image": @"", @"text" : @"我的推荐人"},
                        @{@"id" : @"merchant", @"type" : @"action", @"action": @"actionMerchant", @"image": @"", @"text" : @"我推荐的商户"},
                        ],
                      @[
                        @{@"id" : @"invite", @"type" : @"action", @"action": @"actionInvite", @"image": @"", @"text" : @"要请好友使用生意宝"},
                        ],
                      nil];
    } else {
        tableArray = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"merchant", @"type" : @"action", @"action": @"actionMerchant", @"image": @"", @"text" : @"我推荐的商户"},
                        ],
                      @[
                        @{@"id" : @"invite", @"type" : @"action", @"action": @"actionInvite", @"image": @"", @"text" : @"要请好友使用生意宝"},
                        ],
                      nil];
    }
    
    //初始化header
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = COLOR_MAIN_BG;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_TABLE_MARGIN_DEFAULT);
    self.tableView.tableHeaderView = headerView;
    
    self.tableData = tableArray;
    
    //解决iOS7按钮移动
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];

}

- (void)actionRecommend
{
    [self.delegate actionRecommend];
}

- (void)actionMerchant
{
    [self.delegate actionMerchant];
}

- (void)actionInvite
{
    [self.delegate actionInvite];
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

@end
