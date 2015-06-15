//
//  AccountView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AccountView.h"

@interface AccountView ()

@end

@implementation AccountView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"info", @"type" : @"custom", @"action": @"", @"image": @"", @"text" : @"", @"height": @60},
                        ],
                      @[
                        @{@"id" : @"address", @"type" : @"action", @"action": @"", @"image": @"", @"text" : @"管理我的地址"},
                        @{@"id" : @"profile", @"type" : @"action", @"action": @"actionProfile", @"image": @"", @"text" : @"个人资料"},
                        @{@"id" : @"safety", @"type" : @"action", @"action": @"", @"image": @"", @"text" : @"账户与安全"},
                        ],
                      @[
                        @{@"id" : @"feedback", @"type" : @"action", @"action": @"", @"image": @"", @"text" : @"意见反馈"},
                        @{@"id" : @"contact", @"type" : @"custom", @"action": @"actionContact:", @"image": @"", @"text" : @"客服电话", @"style": @"value1", @"detail": @"400-820-5555"},
                        ],
                      nil];
    
    //退出按钮
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:3.0];
    [button addTarget:self action:@selector(actionLogout) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:SIZE_BUTTON_TEXT];
    button.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BUTTON_BG];
    [self addSubview:button];
    
    UIView *superview = self;
    int padding = 10;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.tableView.tableFooterView.mas_bottom);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_BIG_BUTTON]);
    }];
    
    return self;
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    
    NSString *id = [cellData objectForKey:@"id"];
    //info
    if ([@"info" isEqualToString:id]) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [AppUtil nopicImage];
        [cell addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(cell.mas_top).offset(10);
            make.left.equalTo(cell.mas_left).offset(10);
            
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = @"未填写";
        nameLabel.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
        [cell addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(imageView.mas_right).offset(10);
        }];
    //contact
    } else {
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_HIGHLIGHTED];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - Action
- (void)actionContact:(NSDictionary *)cellData
{
    NSString *tel = [cellData objectForKey:@"detail"];
    [self.delegate actionContact:tel];
}

- (void)actionProfile
{
    [self.delegate actionProfile];
}

- (void)actionLogout
{
    [self.delegate actionLogout];
}

@end
