//
//  SafetyView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SafetyView.h"

@implementation SafetyView

#pragma mark - RenderData
- (void) renderData
{
    UserEntity *user = [self getData:@"user"];
    NSString *mobile = user.mobile ? user.mobile : @"";
    if ([mobile length] > 0) {
        mobile = [NSString stringWithFormat:@"%@****%@", [mobile substringToIndex:3], [mobile substringFromIndex:7]];
    }
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"mobile", @"type" : @"custom", @"action": @"", @"image": @"", @"text" : @"手机号码", @"style" : @"value1", @"detail" : mobile},
                        ],
                      @[
                        @{@"id" : @"password", @"type" : @"action", @"action": @"", @"image": @"", @"text" : @"修改登陆密码"},
                        ],
                      nil];
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? HEIGHT_TABLE_MARGIN_DEFAULT : HEIGHT_TABLE_MARGIN_ZERO;
}

@end
