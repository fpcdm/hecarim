//
//  BusinessServicesListView.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessServicesListView.h"

@implementation BusinessServicesListView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    [self.tableView startLoading];
    
    return self;
}

- (void)display
{
    //显示数据
    NSMutableArray *servicesList = [self fetch:@"servicesList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    NSLog(@"数据是：\n");
    [FWDebug dump:servicesList];
    if (servicesList != nil) {
        for (NSDictionary *param in servicesList) {
            [tableData addObject:@{@"id" : @"services", @"type" : @"custom", @"action": @"actionServices:", @"height": @"", @"data": param, @"text":[param objectForKey:@"type_name"]}];
        }
    }
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData, nil];
    [self.tableView reloadData];
}

- (void)actionServices:(NSDictionary *)cellData
{
    NSDictionary *services = [cellData objectForKey:@"data"];
    [self.delegate actionSelectServices:services];
    
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
