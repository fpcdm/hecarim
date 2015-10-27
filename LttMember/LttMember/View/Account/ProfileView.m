//
//  ProfileView.m
//  LttMember
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ProfileView.h"

@interface ProfileView ()

@end

@implementation ProfileView
{
    UserEntity *user;
}

#pragma mark - RenderData
- (void) renderData
{
    user = [self getData:@"user"];
    NSString *userNickname = user.nickname ? user.nickname : @"";
    NSString *userSexName = [user sexName];
    userSexName = userSexName ? userSexName : @"";
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"photo", @"type" : @"custom", @"action": @"actionAvatar", @"image": @"", @"text" : @"头像", @"height" : @60},
                        @{@"id" : @"nickname", @"type" : @"action", @"action": @"actionNickname", @"image": @"", @"text" : @"昵称", @"style" : @"value1", @"detail" : userNickname},
                        @{@"id" : @"sex", @"type" : @"action", @"action": @"actionSex", @"image": @"", @"text" : @"性别", @"style" : @"value1", @"detail":userSexName},
                        ],
                      nil];
    [self.tableView reloadData];
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? HEIGHT_TABLE_MARGIN_DEFAULT : HEIGHT_TABLE_MARGIN_ZERO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    
    NSString *id = [cellData objectForKey:@"id"];
    //photo
    if ([@"photo" isEqualToString:id]) {
        UIImageView *imageView = [UIImageView new];
        imageView.layer.cornerRadius = 20;
        [user avatarView:imageView];
        [cell addSubview:imageView];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(cell.mas_top).offset(10);
            make.bottom.equalTo(cell.mas_bottom).offset(-10);
            make.right.equalTo(cell.mas_right).offset(-30);
            
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
    }
    
    return cell;
}

- (void)actionSex
{
    [self.delegate actionSex];
}

- (void)actionNickname
{
    [self.delegate actionNickname];
}

- (void)actionAvatar
{
    [self.delegate actionAvatar];
}

@end
