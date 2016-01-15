//
//  RecommendShareView.m
//  LttMember
//
//  Created by wuyong on 15/12/1.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "RecommendShareView.h"

@implementation RecommendShareView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"recommend", @"type" : @"action", @"action": @"actionRecommend", @"image": @"", @"text" : @"我的推荐人"},
                        ],
                      @[
                        @{@"id" : @"share", @"type" : @"action", @"action": @"actionShare", @"image": @"", @"text" : @"邀请好友使用两条腿"},
                        ],
                      nil];
    [self.tableView reloadData];
    
    return self;
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? HEIGHT_TABLE_MARGIN_DEFAULT : HEIGHT_TABLE_MARGIN_ZERO;
}

#pragma mark - Action
- (void)actionRecommend
{
    [self.delegate actionRecommend];
}

- (void)actionShare
{
    [self.delegate actionShare];
}

@end
