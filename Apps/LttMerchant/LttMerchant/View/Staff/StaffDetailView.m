//
//  StaffDetailView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/29.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "StaffDetailView.h"
#import "StaffEntity.h"

@implementation StaffDetailView
{
    UIImageView *avatarImage;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    
    avatarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nopic"]];
    avatarImage.backgroundColor = COLOR_MAIN_WHITE;
    UIButton *BtnView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 154.0f)];
    [BtnView addTarget:self action:@selector(actionUploadAvatar) forControlEvents:UIControlEventTouchUpInside];
    avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 100, 100)];
    avatarImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    avatarImage.image = [UIImage imageNamed:@"nopic"];
    avatarImage.layer.masksToBounds = YES;
    avatarImage.layer.cornerRadius = 50.0;
    avatarImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    avatarImage.layer.shouldRasterize = YES;
    avatarImage.clipsToBounds = YES;
    [BtnView addSubview:avatarImage];
    self.tableView.tableHeaderView = BtnView;
    self.tableView.tableHeaderView.backgroundColor = COLOR_MAIN_WHITE;
    
    //底部
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 100)];
    footerView.backgroundColor = COLOR_MAIN_BG;
    self.tableView.tableFooterView = footerView;
    
    UIButton *button = [AppUIUtil makeButton:@"重置密码"];
    [button addTarget:self action:@selector(actionRestPassword) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    UIView *superView = footerView;
    int padding = 10;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithFloat:HEIGHT_MAIN_BUTTON]);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"密码默认重置为：888888";
    tipLabel.textColor = COLOR_MAIN_BLACK;
    tipLabel.font = FONT_MIDDLE;
    [footerView addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@20);
    }];
    
    return self;
}

- (void)display
{
    StaffEntity *staff = [self fetch:@"staff"];
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"no", @"type" : @"custom", @"text" : @"编号:", @"data" : (staff.no ? staff.no : @"")},
                        @{@"id" : @"name", @"type" : @"custom", @"text" : @"姓名:", @"data" : (staff.name ? staff.name : @"")},
                        @{@"id" : @"nickname", @"type" : @"custom", @"text" : @"昵称:", @"data" : (staff.nickname ? staff.nickname : @"")},
                        @{@"id" : @"mobile", @"type" : @"custom", @"text" : @"电话:", @"data" : (staff.mobile ? staff.mobile : @"")},
                        ],
                      nil];
        
    [self.tableView reloadData];
    
    [staff staffAvatarView:avatarImage];
}

- (void)setUploadAvatar
{
    StaffEntity *avatar = [self fetch:@"avatar"];
    [avatar staffAvatarView:avatarImage];
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = [cellData objectForKey:@"data"];
    label.font = FONT_MAIN;
    [cell addSubview:label];
    
    UIView *superview = cell;
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(60);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.centerY.equalTo(cell.textLabel.mas_centerY);
    }];
    
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

//上传头像
- (void)actionUploadAvatar
{
    [self.delegate actionUploadAvatar];
}

//重置密码
- (void)actionRestPassword
{
    [self.delegate actionRestPassword];
}
@end
