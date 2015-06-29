//
//  SettingView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SettingView.h"

@interface SettingView ()

@end

@implementation SettingView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"clear", @"type" : @"normal", @"action": @"actionClear", @"image": @"", @"text" : @"清除本地缓存", @"style":@"value1", @"detail" : @"0.0M"},
                        ],
                      @[
                        @{@"id" : @"about", @"type" : @"action", @"action": @"actionAbout", @"image": @"", @"text" : @"关于手机两条腿"},
                        ],
                      nil];
    
    return self;
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? HEIGHT_TABLE_MARGIN_DEFAULT : HEIGHT_TABLE_MARGIN_ZERO;
}

#pragma mark - Action
- (void)actionClear
{
    [self.delegate actionClear];
}

- (void)actionAbout
{
    [self.delegate actionAbout];
}

@end
