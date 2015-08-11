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
                               @"text": service.typeName ? service.typeName : @"",
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
