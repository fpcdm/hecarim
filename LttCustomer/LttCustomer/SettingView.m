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
                        @{@"id" : @"clear", @"type" : @"custom", @"action": @"actionClear", @"image": @"", @"text" : @"清除本地缓存", @"data" : @"0.0M"},
                        ],
                      @[
                        @{@"id" : @"about", @"type" : @"action", @"action": @"", @"image": @"", @"text" : @"关于手机两条腿", @"data" : @""},
                        ],
                      nil];
    
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else {
        return 0;
    }
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    
    NSString *id = [cellData objectForKey:@"id"];
    //clear
    if ([@"clear" isEqualToString:id]) {
        UILabel *dataLabel = [[UILabel alloc] init];
        dataLabel.text = [cellData objectForKey:@"data"];
        [cell addSubview:dataLabel];
        
        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(cell.textLabel.mas_top);
            make.bottom.equalTo(cell.textLabel.mas_bottom);
            
            make.right.equalTo(cell.mas_right).offset(-10);
        }];
    }
    
    return cell;
}

#pragma mark - Action
- (void)actionClear
{
    [self.delegate actionClear];
}

@end
