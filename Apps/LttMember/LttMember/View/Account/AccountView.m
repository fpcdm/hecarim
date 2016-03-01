//
//  AccountView.m
//  LttMember
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AccountView.h"

@interface AccountView ()

@end

@implementation AccountView
{
    UIImageView *imageView;
    UILabel *nameLabel;
}

- (BOOL)hasTabBar
{
    return YES;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"info", @"type" : @"custom", @"action": @"actionProfile", @"image": @"", @"text" : @"", @"height": @60},
                        ],
                      @[
                        @{@"id" : @"wallet", @"type" : @"action", @"action": @"actionMyWallet", @"image": @"", @"text" : @"我的钱包"},
                        ],
                      @[
                        @{@"id" : @"address", @"type" : @"action", @"action": @"actionAddress", @"image": @"", @"text" : @"我的地址"},
                        @{@"id" : @"safety", @"type" : @"action", @"action": @"actionSafety", @"image": @"", @"text" : @"账户与安全"},
                        ],
                      @[
                        @{@"id" : @"recommend", @"type" : @"action", @"action": @"actionRecommendShare", @"image": @"", @"text" : @"推荐与分享"},
                        ],
                      @[
                        @{@"id" : @"feedback", @"type" : @"action", @"action": @"actionSuggestion", @"image": @"", @"text" : @"意见反馈"},
                        @{@"id" : @"contact", @"type" : @"custom", @"action": @"actionContact:", @"image": @"", @"text" : @"客服电话", @"style": @"value1", @"detail": LTT_CUSTOMER_SERVICE},
                        ],
                      nil];
    
    //退出区域
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 55)];
    footerView.backgroundColor = COLOR_MAIN_BG;
    self.tableView.tableFooterView = footerView;
    
    //退出按钮
    UIButton *button = [AppUIUtil makeButton:@"退出当前账号"];
    [button addTarget:self action:@selector(actionLogout) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    UIView *superview = footerView;
    int padding = 10;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    //初始化数据视图
    imageView = [[UIImageView alloc] init];
    nameLabel = [[UILabel alloc] init];
    
    //解决iOS7按钮移动
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];
    
    return self;
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    
    NSString *id = [cellData objectForKey:@"id"];
    //info
    if ([@"info" isEqualToString:id]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        imageView.layer.cornerRadius = 20;
        imageView.clipsToBounds = YES;
        [cell addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(cell.mas_top).offset(10);
            make.left.equalTo(cell.mas_left).offset(10);
            
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        
        nameLabel.font = FONT_MAIN;
        nameLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(imageView.mas_right).offset(10);
        }];
    //contact
    } else {
        cell.detailTextLabel.textColor = COLOR_MAIN_HIGHLIGHT;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
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

#pragma mark - RenderData
- (void)display
{
    UserEntity *user = [self fetch:@"user"];
    
    [user avatarView:imageView];
    nameLabel.text = [user displayName];
}

#pragma mark - Action
- (void)actionContact:(NSDictionary *)cellData
{
    [self.delegate actionContact:LTT_CUSTOMER_SERVICE];
}

- (void)actionProfile
{
    [self.delegate actionProfile];
}

- (void)actionSafety
{
    [self.delegate actionSafety];
}

- (void)actionLogout
{
    [self.delegate actionLogout];
}

- (void)actionAddress
{
    [self.delegate actionAddress];
}

- (void)actionSuggestion
{
    [self.delegate actionSuggestion];
}

- (void)actionRecommendShare
{
    [self.delegate actionRecommendShare];
}

- (void)actionMyWallet
{
    [self.delegate actionMyWallet];
}

@end
