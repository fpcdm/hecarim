//
//  CaseCashierView.m
//  LttMember
//
//  Created by wuyong on 15/11/3.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CaseCashierView.h"
#import "CaseEntity.h"
#import "ResultEntity.h"
#import "DLRadioButton.h"

@implementation CaseCashierView
{
    DLRadioButton *balanceButton;
    
    DLRadioButton *weixinQrcodeButton;
    DLRadioButton *alipayQrcodeButton;
    DLRadioButton *moneyButton;
    
    UILabel *totalLabel;
    UILabel *balanceLabel;
    UILabel *amountLabel;
    
    float totalAmount;
    float balanceAmount;
    
    //是否使用余额
    BOOL useBalance;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    
    //尾部区域
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 55)];
    footerView.backgroundColor = COLOR_MAIN_BG;
    self.tableView.tableFooterView = footerView;
    
    //支付按钮
    UIButton *button = [AppUIUtil makeButton:@"确认支付"];
    [button addTarget:self action:@selector(actionPayUseWay) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    UIView *superview = footerView;
    int padding = 10;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    return self;
}

- (void)renderData
{
    //获取数据
    CaseEntity *intention = [self getData:@"intention"];
    totalAmount = [intention.totalAmount floatValue];
    balanceAmount = 100;
    
    //支付数据
    NSMutableArray *paymentsData = [[NSMutableArray alloc] init];
    [paymentsData addObject:@{@"id" : @"amount", @"type" : @"custom", @"view": @"cellAmount:"}];
    
    //判断支付方式
    NSArray *payments = [self getData:@"payments"];
    for (ResultEntity* payment in payments) {
        //判断支付方式
        if ([PAY_WAY_WEIXIN isEqualToString:payment.data]) {
            weixinQrcodeButton = [[DLRadioButton alloc] init];
            [weixinQrcodeButton addTarget:self action:@selector(actionRadioClicked:) forControlEvents:UIControlEventTouchUpInside];
            weixinQrcodeButton.tag = 1;
            [paymentsData addObject:@{@"id" : @"alipay", @"type" : @"custom", @"view": @"cellWeixinQrcode:", @"height": @60}];
        } else if ([PAY_WAY_ALIPAY isEqualToString:payment.data]) {
            alipayQrcodeButton = [[DLRadioButton alloc] init];
            [alipayQrcodeButton addTarget:self action:@selector(actionRadioClicked:) forControlEvents:UIControlEventTouchUpInside];
            alipayQrcodeButton.tag = 2;
            [paymentsData addObject:@{@"id" : @"weixin", @"type" : @"custom", @"view": @"cellAlipayQrcode:", @"height": @60}];
        } else if ([PAY_WAY_CASH isEqualToString:payment.data]) {
            moneyButton = [[DLRadioButton alloc] init];
            [moneyButton addTarget:self action:@selector(actionRadioClicked:) forControlEvents:UIControlEventTouchUpInside];
            moneyButton.tag = 3;
            [paymentsData addObject:@{@"id" : @"money", @"type" : @"custom", @"view": @"cellMoney:", @"height": @60}];
        }
    }
    
    //表格数据
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"total", @"type" : @"custom", @"view": @"cellTotal:"},
                        ],
                      @[
                        @{@"id" : @"balance", @"type" : @"custom", @"view": @"cellBalance:"},
                        ],
                      paymentsData,
                      nil];
    [self.tableView reloadData];
}

- (UITableViewCell *)cellTotal:(UITableViewCell *)cell
{
    //支付金额
    totalLabel = [[UILabel alloc] init];
    totalLabel.textColor = COLOR_MAIN_HIGHLIGHT;
    totalLabel.font = [UIFont boldSystemFontOfSize:20];
    totalLabel.text = [NSString stringWithFormat:@"您需要支付%.2f元", totalAmount];
    [cell addSubview:totalLabel];
    
    UIView *superview = cell;
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.centerX.equalTo(superview.mas_centerX);
        make.height.equalTo(@20);
    }];
    
    return cell;
}

- (UITableViewCell *)cellBalance:(UITableViewCell *)cell
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"美团余额：";
    titleLabel.font = FONT_MAIN;
    [cell addSubview:titleLabel];
    
    UIView *superview = cell;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(superview.mas_left).offset(10);
        make.width.equalTo(@80);
    }];
    
    balanceLabel = [[UILabel alloc] init];
    balanceLabel.text = [NSString stringWithFormat:@"￥%.2f", balanceAmount];
    balanceLabel.font = FONT_MAIN;
    [cell addSubview:balanceLabel];
    
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(titleLabel.mas_right);
    }];
    
    //单选框
    balanceButton = [[DLRadioButton alloc] init];
    [balanceButton addTarget:self action:@selector(actionRadioClicked:) forControlEvents:UIControlEventTouchUpInside];
    balanceButton.tag = -1;
    balanceButton.iconColor = [UIColor grayColor];
    balanceButton.iconStrokeWidth = 1;
    balanceButton.indicatorColor = [UIColor blackColor];
    balanceButton.indicatorSize = 5;
    balanceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    balanceButton.isIconSquare = YES;
    [cell addSubview:balanceButton];
    
    [balanceButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(superview.mas_centerY);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    return cell;
}

- (UITableViewCell *)cellAmount:(UITableViewCell *)cell
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"还需支付：";
    titleLabel.font = FONT_MAIN;
    [cell addSubview:titleLabel];
    
    UIView *superview = cell;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(superview.mas_left).offset(10);
        make.width.equalTo(@80);
    }];
    
    amountLabel = [[UILabel alloc] init];
    amountLabel.text = [NSString stringWithFormat:@"￥%.2f", totalAmount];
    amountLabel.textColor = [UIColor redColor];
    amountLabel.font = FONT_MAIN;
    [cell addSubview:amountLabel];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(titleLabel.mas_right);
    }];
    
    //默认选中账户余额
    [self actionRadioClicked:balanceButton];
    
    return cell;
}

- (UITableViewCell *)cellWeixinQrcode:(UITableViewCell *)cell
{
    UIButton *button = [self makeButton:@{
                                            @"icon": @"methodWeixinQrcode",
                                            @"text": @"微信扫码支付",
                                            @"detail": @"扫描微信二维码进行安全支付",
                                            @"radio": weixinQrcodeButton
                                            }];
    [cell addSubview:button];
    
    UIView *superview = cell;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview).with.insets(UIEdgeInsetsZero);
    }];
    
    //关联单选框
    NSMutableArray *otherButtons = [[NSMutableArray alloc] init];
    if (alipayQrcodeButton) {
        [otherButtons addObject:alipayQrcodeButton];
    }
    if (moneyButton) {
        [otherButtons addObject:moneyButton];
    }
    weixinQrcodeButton.otherButtons = otherButtons;
    
    return cell;
}

- (UITableViewCell *)cellAlipayQrcode:(UITableViewCell *)cell
{
    UIButton *button = [self makeButton:@{
                                          @"icon": @"methodAlipayQrcode",
                                          @"text": @"支付宝扫码支付",
                                          @"detail": @"扫描支付宝二维码进行安全支付",
                                          @"radio": alipayQrcodeButton
                                          }];
    [cell addSubview:button];
    
    UIView *superview = cell;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview).with.insets(UIEdgeInsetsZero);
    }];
    
    //关联单选框
    NSMutableArray *otherButtons = [[NSMutableArray alloc] init];
    if (weixinQrcodeButton) {
        [otherButtons addObject:weixinQrcodeButton];
    }
    if (moneyButton) {
        [otherButtons addObject:moneyButton];
    }
    alipayQrcodeButton.otherButtons = otherButtons;
    
    return cell;
}

- (UITableViewCell *)cellMoney:(UITableViewCell *)cell
{
    UIButton *button = [self makeButton:@{
                                          @"icon": @"methodMoney",
                                          @"text": @"现金支付",
                                          @"detail": @"支付现金给工作人员",
                                          @"radio": moneyButton
                                          }];
    [cell addSubview:button];
    
    UIView *superview = cell;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview).with.insets(UIEdgeInsetsZero);
    }];
    
    //关联单选框
    NSMutableArray *otherButtons = [[NSMutableArray alloc] init];
    if (weixinQrcodeButton) {
        [otherButtons addObject:weixinQrcodeButton];
    }
    if (alipayQrcodeButton) {
        [otherButtons addObject:alipayQrcodeButton];
    }
    moneyButton.otherButtons = otherButtons;
    
    return cell;
}

- (UIButton *)makeButton:(NSDictionary *)param
{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = COLOR_MAIN_WHITE;
    
    //图标
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:[param objectForKey:@"icon"]];
    [button addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_top).offset(10);
        make.left.equalTo(button.mas_left).offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    //文字
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = [param objectForKey:@"text"];
    textLabel.font = FONT_MAIN;
    textLabel.textColor = COLOR_MAIN_BLACK;
    [button addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_top).offset(10);
        make.left.equalTo(imageView.mas_right).offset(10);
        make.height.equalTo(@20);
    }];
    
    //详情
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = [param objectForKey:@"detail"];
    detailLabel.font = FONT_MIDDLE;
    detailLabel.textColor = COLOR_MAIN_GRAY;
    [button addSubview:detailLabel];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom);
        make.left.equalTo(imageView.mas_right).offset(10);
        make.height.equalTo(@20);
    }];
    
    //单选框
    DLRadioButton *radioButton = [param objectForKey:@"radio"];
    radioButton.iconColor = [UIColor grayColor];
    radioButton.iconStrokeWidth = 1;
    radioButton.indicatorColor = [UIColor blackColor];
    radioButton.indicatorSize = 5;
    radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    radioButton.isIconSquare = NO;
    [button addSubview:radioButton];
    
    [radioButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(button.mas_centerY);
        make.right.equalTo(button.mas_right).offset(-10);
        
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    return button;
}

#pragma mark - TableView
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
- (void)actionRadioClicked:(DLRadioButton *)button
{
    //切换账户余额
    if (button.tag == -1) {
        if (useBalance) {
            useBalance = NO;
            button.selected = NO;
            
            amountLabel.text = [NSString stringWithFormat:@"￥%.2f", totalAmount];
        } else {
            useBalance = YES;
            button.selected = YES;
            
            //余额是否足够
            float payAmount = balanceAmount >= totalAmount ? 0 : totalAmount - balanceAmount;
            amountLabel.text = [NSString stringWithFormat:@"￥%.2f", payAmount];
        }
    }
    
    //如果余额足够且使用余额，则不能勾选其它方式
    if (useBalance && balanceAmount >= totalAmount) {
        if (weixinQrcodeButton) weixinQrcodeButton.selected = NO;
        if (alipayQrcodeButton) alipayQrcodeButton.selected = NO;
        if (moneyButton) moneyButton.selected = NO;
    }
}

- (void)actionPayUseWay
{
    NSString *payWay = nil;
    if (weixinQrcodeButton && weixinQrcodeButton.selected) {
        payWay = PAY_WAY_WEIXIN;
    } else if (alipayQrcodeButton && alipayQrcodeButton.selected) {
        payWay = PAY_WAY_ALIPAY;
    } else if (moneyButton && moneyButton.selected) {
        payWay = PAY_WAY_CASH;
    }
    
    [self.delegate actionPayUseWay:useBalance payWay:payWay];
}

@end
