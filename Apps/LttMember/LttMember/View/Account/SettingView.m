//
//  SettingView.m
//  LttMember
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SettingView.h"

@interface SettingView ()

@end

@implementation SettingView

- (void)display
{
    NSNumber *cacheSize = [self fetch:@"cacheSize"];
    float tmpSize = cacheSize ? [cacheSize floatValue] : 0;
    
    NSString *sizeText = nil;
    float fileSize = tmpSize / 1024.0;
    if (fileSize > 1024.0) {
        sizeText = [NSString stringWithFormat:@"%.2fM", fileSize / 1024.0];
    } else {
        sizeText = [NSString stringWithFormat:@"%.2fK", fileSize];
    }
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"clear", @"type" : @"normal", @"action": @"actionClear", @"image": @"", @"text" : @"清除本地缓存", @"style":@"value1", @"detail" : sizeText},
                        ],
                      @[
                        @{@"id" : @"about", @"type" : @"action", @"action": @"actionAbout", @"image": @"", @"text" : @"关于手机两条腿"},
                        ],
                      nil];
    [self.tableView reloadData];
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
