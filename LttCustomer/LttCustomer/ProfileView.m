//
//  ProfileView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ProfileView.h"

@interface ProfileView ()

@end

@implementation ProfileView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"photo", @"type" : @"custom", @"action": @"", @"image": @"", @"text" : @"头像", @"data" : @""},
                        @{@"id" : @"nickname", @"type" : @"action", @"action": @"", @"image": @"", @"text" : @"昵称", @"data" : @""},
                        @{@"id" : @"sex", @"type" : @"action", @"action": @"", @"image": @"", @"text" : @"性别", @"data" : @""},
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
    //photo
    if ([@"photo" isEqualToString:id]) {
    }
    
    return cell;
}

@end
