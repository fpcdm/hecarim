//
//  MyWalletView.m
//  LttMember
//
//  Created by 杨海锋 on 15/12/8.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "MyWalletView.h"

@implementation MyWalletView
{
    UILabel *acctionLabel;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"balance", @"type" : @"custom", @"action": @"actionBalance", @"image": @"", @"text" : @"账户余额", @"height": @60},
                        @{@"id" : @"recharge", @"type" : @"action", @"action": @"actionRecharge", @"image": @"", @"text" : @"充值", @"height": @""},
                        ],
                      @[
                        @{@"id" : @"bankCard", @"type" : @"action", @"action": @"actionMyBankCard", @"image": @"", @"text" : @"我的银行卡"},
                        ],
                      nil];
    
    //解决iOS7按钮移动
    [self.tableView reloadData];
    return self;
}

#pragma mark - TableView
- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    
    NSString *id = [cellData objectForKey:@"id"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([@"balance" isEqualToString:id]) {
        acctionLabel = [[UILabel alloc] init];
        acctionLabel.text = @"￥520.00";
        acctionLabel.textColor = [UIColor colorWithHexString:@"#F08D00"];
        acctionLabel.font = FONT_MAIN;
        [cell addSubview:acctionLabel];
        
        [acctionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.left.equalTo(cell.mas_left).offset(90);
        }];
        
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
- (void) renderData
{
   
}

- (void)actionBalance
{
    [self.delegate actionBalance];
}

- (void)actionRecharge
{
    [self.delegate actionRecharge];
}

- (void)actionMyBankCard
{
    [self.delegate actionMyBankCard];
}

@end
