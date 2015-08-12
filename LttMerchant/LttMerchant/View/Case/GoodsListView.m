//
//  GoodsListView.m
//  LttMerchant
//
//  Created by wuyong on 15/8/12.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsListView.h"
#import "GoodsEntity.h"

@implementation GoodsListView

@synthesize delegate;

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    //显示数据
    NSArray *goodsList = [self getData:@"goodsList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    for (GoodsEntity *goods in goodsList) {
        [tableData addObject:@[@{
                                   @"id" : @"goods",
                                   @"type" : @"custom",
                                   @"text": goods.name ? goods.name : @"",
                                   @"height": @50,
                                   @"style": @"value1",
                                   @"detail": goods.price ? [NSString stringWithFormat:@"￥%@", goods.price] : @"",
                                   @"data": goods
                                   }]];
    }
    
    self.tableData = tableData;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    
    //选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
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

#pragma mark - TableView
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section >= [self.tableData count] - 1 ? HEIGHT_TABLE_MARGIN_ZERO : HEIGHT_TABLE_MARGIN_DEFAULT;
}

#pragma mark - Action

@end
