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
                        @{@"id" : @"info", @"index" : @0, @"type" : @"custom", @"image": @"", @"text" : @"TODO", @"data" : @"", @"height": @0},
                        ],
                      @[
                        @{@"id" : @"address", @"index" : @1, @"type" : @"action", @"image": @"", @"text" : @"管理我的地址", @"data" : @"", @"height": @0},
                        @{@"id" : @"profile", @"index" : @2, @"type" : @"action", @"image": @"", @"text" : @"个人资料", @"data" : @"", @"height": @0},
                        @{@"id" : @"safety", @"index" : @3, @"type" : @"action", @"image": @"", @"text" : @"账户与安全", @"data" : @"", @"height": @0},
                        ],
                      @[
                        @{@"id" : @"feedback", @"index" : @4, @"type" : @"action", @"image": @"", @"text" : @"意见反馈", @"data" : @"", @"height": @0},
                        @{@"id" : @"contact", @"index" : @5, @"type" : @"custom", @"image": @"", @"text" : @"客服电话", @"data" : @"400-820-5555", @"height": @0},
                        ],
                      nil];
    
    //退出按钮
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"退出当前账号" forState:UIControlStateNormal];
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
    return cell;
}

#pragma mark - Action
- (void)actionAddress
{
    
}

@end
