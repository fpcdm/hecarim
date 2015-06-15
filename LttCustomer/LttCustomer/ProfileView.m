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
                        @{@"id" : @"photo", @"type" : @"custom", @"action": @"", @"image": @"", @"text" : @"头像", @"height" : @60},
                        @{@"id" : @"nickname", @"type" : @"action", @"action": @"", @"image": @"", @"text" : @"昵称", @"style" : @"value1", @"detail" : @"未填写"},
                        @{@"id" : @"sex", @"type" : @"action", @"action": @"", @"image": @"", @"text" : @"性别", @"style" : @"value1", @"detail":@"未选择"},
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
        UIImageView *imageView = [UIImageView new];
        imageView.image = [AppUIUtil nopicImage];
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

@end
