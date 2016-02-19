//
//  RecommendMerchantView.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/2/18.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "RecommendMerchantView.h"

@implementation RecommendMerchantView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = COLOR_MAIN_BG;
    self.tableView.scrollEnabled = YES;
    
    //初始化header
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = COLOR_MAIN_BG;
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_TABLE_MARGIN_ZERO);
    self.tableView.tableHeaderView = headerView;
    
    //初始化空视图
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 20)];
    emptyLabel.font = [UIFont systemFontOfSize:18];
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"你还没有推荐商户";
    self.tableView.emptyView = emptyLabel;
    
    [self.tableView setLoadingFooter:self action:@selector(actionLoadMore)];

    return self;
}

- (void)display
{
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    NSMutableArray *data = [self fetch:@"merchantList"];
    
    for (UserEntity *user in data) {
        [tableData addObject:@{
                               @"id" : @"staff",
                               @"action" : @"",
                               @"text" : user.name,
                               @"type" : @"custom",
                               @"height" : @45,
                               }];
    }
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData, nil];
    [self.tableView reloadData];
}

- (void)actionLoadMore
{
    [self.delegate actionLoadMore];
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
