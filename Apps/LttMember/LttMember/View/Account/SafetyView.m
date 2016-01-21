//
//  SafetyView.m
//  LttMember
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SafetyView.h"
#import "ResultEntity.h"

@implementation SafetyView

#pragma mark - RenderData
- (void)display
{
    UserEntity *user = [self fetch:@"user"];
    NSNumber *res = [self fetch:@"payRes"];
    NSString *payString = [NSString stringWithFormat:@"%@支付密码",(([@1 isEqualToNumber:res]) ? @"修改" : @"设置")];
    NSString *mobile = user.mobile ? user.mobile : @"";
    if ([mobile length] > 0) {
        mobile = [NSString stringWithFormat:@"%@****%@", [mobile substringToIndex:3], [mobile substringFromIndex:7]];
    }
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"mobile", @"type" : @"custom", @"action": @"", @"image": @"", @"text" : @"手机号码", @"style" : @"value1", @"detail" : mobile},
                        ],
                      @[
                        @{@"id" : @"payPassword", @"type" : @"action", @"action": @"actionPayPassword", @"image": @"", @"text" : payString},
                        @{@"id" : @"password", @"type" : @"action", @"action": @"actionPassword", @"image": @"", @"text" : @"修改登陆密码"},
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
- (void)actionPassword
{
    [self.delegate actionPassword];
}

- (void)actionPayPassword
{
    [self.delegate actionPayPassword];
}
@end
