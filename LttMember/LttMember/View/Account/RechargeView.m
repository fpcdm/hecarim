//
//  RechargeView.m
//  LttMember
//
//  Created by wuyong on 15/12/14.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "RechargeView.h"
#import "DLRadioButton.h"

@implementation RechargeView
{
    UITextField *amountField;
    DLRadioButton *alipayButton;
    DLRadioButton *weixinButton;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"amount", @"type" : @"custom", @"view": @"cellAmount:"},
                        ],
                      @[
                        @{@"id" : @"alipay", @"type" : @"custom", @"view": @"cellAlipay:", @"action":@"actionSelected:", @"data":@1, @"height": @54},
                        @{@"id" : @"weixin", @"type" : @"custom", @"view": @"cellWeixin:", @"action":@"actionSelected:", @"data":@2, @"height": @54},
                        ],
                      nil];
    
    //尾部区域
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 55)];
    footerView.backgroundColor = COLOR_MAIN_BG;
    self.tableView.tableFooterView = footerView;
    
    //支付按钮
    UIButton *button = [AppUIUtil makeButton:@"确认支付"];
    [button addTarget:self action:@selector(actionRecharge) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    UIView *superview = footerView;
    int padding = 10;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    //金额输入框
    amountField = [[UITextField alloc] init];
    alipayButton = [[DLRadioButton alloc] init];
    weixinButton = [[DLRadioButton alloc] init];
    
    [self.tableView reloadData];
    return self;
}

- (UITableViewCell *)cellAmount:(UITableViewCell *)cell
{
    UILabel *amountTitle = [[UILabel alloc] init];
    amountTitle.text = @"金额";
    amountTitle.font = FONT_MAIN;
    [cell addSubview:amountTitle];
    
    UIView *superview = cell;
    [amountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(superview.mas_left).offset(10);
        make.width.equalTo(@32);
    }];
    
    amountField.placeholder = @"请输入充值金额";
    amountField.font = FONT_MAIN;
    amountField.keyboardType = UIKeyboardTypeDecimalPad;
    [cell addSubview:amountField];
    
    [amountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amountTitle.mas_right).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.centerY.equalTo(superview.mas_centerY);
    }];
    
    return cell;
}

- (UITableViewCell *)cellAlipay:(UITableViewCell *)cell
{
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"methodAlipay"];
    [cell addSubview:iconView];
    
    UIView *superview = cell;
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(superview.mas_left).offset(10);
        make.width.equalTo(@34);
        make.height.equalTo(@34);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"支付宝支付";
    titleLabel.font = FONT_MAIN;
    [cell addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(iconView.mas_right).offset(10);
        make.height.equalTo(@16);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"推荐有支付宝账号的用户使用";
    detailLabel.textColor = COLOR_MAIN_GRAY;
    detailLabel.font = FONT_SMALL;
    [cell addSubview:detailLabel];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10);
        make.bottom.equalTo(superview.mas_bottom).offset(-10);
        make.height.equalTo(@12);
    }];
    
    //单选框
    alipayButton.iconColor = [UIColor grayColor];
    alipayButton.iconStrokeWidth = 1;
    alipayButton.indicatorColor = [UIColor blackColor];
    alipayButton.indicatorSize = 5;
    alipayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    alipayButton.isIconSquare = NO;
    alipayButton.otherButtons = @[weixinButton];
    alipayButton.selected = YES;
    [cell addSubview:alipayButton];
    
    [alipayButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(superview.mas_centerY);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    return cell;
}

- (UITableViewCell *)cellWeixin:(UITableViewCell *)cell
{
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"methodWeixin"];
    [cell addSubview:iconView];
    
    UIView *superview = cell;
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(superview.mas_left).offset(10);
        make.width.equalTo(@34);
        make.height.equalTo(@34);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"微信支付";
    titleLabel.font = FONT_MAIN;
    [cell addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(iconView.mas_right).offset(10);
        make.height.equalTo(@16);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"推荐安装微信5.0以上版本的用户使用";
    detailLabel.textColor = COLOR_MAIN_GRAY;
    detailLabel.font = FONT_SMALL;
    [cell addSubview:detailLabel];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10);
        make.bottom.equalTo(superview.mas_bottom).offset(-10);
        make.height.equalTo(@12);
    }];
    
    //单选框
    weixinButton.iconColor = [UIColor grayColor];
    weixinButton.iconStrokeWidth = 1;
    weixinButton.indicatorColor = [UIColor blackColor];
    weixinButton.indicatorSize = 5;
    weixinButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    weixinButton.isIconSquare = NO;
    weixinButton.otherButtons = @[alipayButton];
    [cell addSubview:weixinButton];
    
    [weixinButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(superview.mas_centerY);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    return cell;
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? HEIGHT_TABLE_MARGIN_DEFAULT : HEIGHT_TABLE_MARGIN_ZERO;
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

#pragma mark - Action
- (void)actionSelected:(NSDictionary *)cellData
{
    NSNumber *type = [cellData objectForKey:@"data"];
    if ([@1 isEqualToNumber:type]) {
        alipayButton.selected = YES;
    } else {
        weixinButton.selected = YES;
    }
}

- (void)actionRecharge
{
    NSString *payWay = nil;
    if (alipayButton.selected) {
        payWay = PAY_WAY_ALIPAY;
    } else if (weixinButton.selected) {
        payWay = PAY_WAY_WEIXIN;
    }
    
    [self.delegate actionRecharge:amountField.text payWay:payWay];
}

@end
