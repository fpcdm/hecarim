//
//  ServiceListView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ServiceListView.h"
#import "ServiceEntity.h"

@implementation ServiceListView

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
    NSArray *services = [self getData:@"services"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    for (ServiceEntity *service in services) {
        [tableData addObject:@[@{
                               @"id" : @"service",
                               @"type" : @"custom",
                               @"text": service.name ? service.name : @"",
                               @"height": @40,
                               @"style": @"value1",
                               @"detail": service.price ? [NSString stringWithFormat:@"￥%@", service.price] : @"",
                               @"data": service
                               }]];
    }
    
    self.tableData = tableData;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    //选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
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

@end
