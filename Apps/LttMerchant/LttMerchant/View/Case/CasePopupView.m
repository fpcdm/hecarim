//
//  CasePopupView.m
//  LttMember
//
//  Created by wuyong on 15/8/13.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CasePopupView.h"
#import "CaseEntity.h"

@implementation CasePopupView
{
    NSString *title;
    CaseEntity *intention;
    
    UIButton *competeButton;
}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    
    UIView *superview = self;
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(superview).with.insets(UIEdgeInsetsMake(0, 0, 120, 0));
    }];
    
    //抢单按钮
    competeButton = [[UIButton alloc] init];
    competeButton.backgroundColor = COLOR_MAIN_BLUE;
    competeButton.layer.cornerRadius = 50;
    competeButton.clipsToBounds = YES;
    competeButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [competeButton setTitle:@"抢单" forState:UIControlStateNormal];
    [competeButton setTitleColor:COLOR_MAIN_WHITE forState:UIControlStateNormal];
    [competeButton addTarget:self action:@selector(actionCompeteCase) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:competeButton];
    
    [competeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superview.mas_centerX);
        make.bottom.equalTo(superview.mas_bottom).offset(-10);
        make.width.equalTo(@100);
        make.height.equalTo(@100);
    }];
    
    //关闭按钮
    UIButton *closeButton = [[UIButton alloc] init];
    closeButton.backgroundColor = COLOR_MAIN_WHITE;
    closeButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    closeButton.layer.borderWidth = 0.5f;
    closeButton.layer.cornerRadius = 25;
    closeButton.clipsToBounds = YES;
    closeButton.titleLabel.font = FONT_MAIN;
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(actionClose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(competeButton.mas_centerX).offset(SCREEN_WIDTH / 4 + 25);
        make.bottom.equalTo(superview.mas_bottom).offset(-35);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    return self;
}

- (void) startCompete
{
    competeButton.enabled = NO;
    [competeButton setTitle:@"抢单中" forState:UIControlStateNormal];
}

- (void) finishCompete
{
    [competeButton setTitle:@"抢单成功" forState:UIControlStateNormal];
}

#pragma mark - RenderData
- (void)display
{
    //获取数据
    title = [self fetch:@"title"];
    intention = [self fetch:@"intention"];
    
    //添加数据
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    
    //需求信息
    [tableData addObject:@[
                           @{@"id": @"info", @"type": @"custom", @"view": @"cellTitle:", @"height": @40},
                           @{@"id": @"info", @"type": @"custom", @"view": @"cellInfo:", @"height": @255}
                           ]];
    
    self.tableData = tableData;
    [self.tableView reloadData];
}

- (UITableViewCell *) cellTitle:(UITableViewCell *)cell
{
    cell.layer.borderColor = CGCOLOR_MAIN_BORDER;
    cell.layer.borderWidth = 0.5f;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = COLOR_MAIN_BLUE;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [cell addSubview:titleLabel];
    
    UIView *superview = cell;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    return cell;
}

- (UITableViewCell *) cellInfo:(UITableViewCell *)cell
{
    //需求基本数据
    UIView *caseView = [[UIView alloc] init];
    caseView.backgroundColor = [UIColor colorWithHexString:@"#8ED1F3"];
    [cell addSubview:caseView];
    
    UIView *superview = cell;
    [caseView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.height.equalTo(@80);
    }];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.backgroundColor = [UIColor clearColor];
    iconView.image = [UIImage imageNamed:@"detail_icon_white"];
    iconView.layer.cornerRadius = 3.0f;
    [caseView addSubview:iconView];
    
    superview = caseView;
    [iconView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    UILabel *noTitle = [self makeLabel:@"编号："];
    noTitle.textColor = [UIColor whiteColor];
    [caseView addSubview:noTitle];
    
    [noTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(iconView.mas_right).offset(10);
        
        make.width.equalTo(@48);
        make.height.equalTo(@20);
    }];
    
    UILabel *noLabel = [self makeLabel:intention.no];
    noLabel.font = FONT_MAIN_BOLD;
    noLabel.textColor = [UIColor whiteColor];
    [caseView addSubview:noLabel];
    
    [noLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(noTitle.mas_right);
        
        make.width.equalTo(@160);
        make.height.equalTo(@20);
    }];
    
    UILabel *statusLabel = [self makeLabel:[intention statusName]];
    statusLabel.textColor = [UIColor whiteColor];
    [caseView addSubview:statusLabel];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@20);
    }];
    
    UILabel *timeLabel = [self makeLabel:intention.createTime];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = FONT_MIDDLE;
    [caseView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(noTitle.mas_bottom);
        make.left.equalTo(iconView.mas_right).offset(10);
        
        make.height.equalTo(@15);
    }];
    
    UILabel *amountLabel = [self makeLabel:nil];
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.text = @"总金额：-";
    [caseView addSubview:amountLabel];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_bottom).offset(-10);
        make.left.equalTo(iconView.mas_right).offset(10);
    }];
    
    //需求服务数据
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = COLOR_MAIN_WHITE;
    [cell addSubview:infoView];
    
    superview = cell;
    [infoView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(caseView.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.height.equalTo(@175);
    }];
    
    UIImageView *infoIconView = [[UIImageView alloc] init];
    infoIconView.backgroundColor = [UIColor clearColor];
    infoIconView.image = [UIImage imageNamed:@"detail_icon"];
    [infoView addSubview:infoIconView];
    
    superview = infoView;
    [infoIconView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    //下单人
    UILabel *userTitle = [self makeLabel:@"下单人："];
    [infoView addSubview:userTitle];
    
    [userTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(iconView.mas_right).offset(10);
        
        make.width.equalTo(@64);
        make.height.equalTo(@16);
    }];
    
    //称谓
    UILabel *userLabel = [self makeLabel:intention.userAppellation ? intention.userAppellation : @"-"];
    [infoView addSubview:userLabel];
    
    [userLabel sizeToFit];
    CGFloat userWidth = userLabel.frame.size.width;
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(userTitle.mas_right);
        
        make.width.equalTo([NSNumber numberWithFloat:userWidth]);
        make.height.equalTo(@16);
    }];
    
    //下单人信息
    UIButton *userButton = [[UIButton alloc] init];
    userButton.backgroundColor = [UIColor clearColor];
    userButton.titleLabel.font = FONT_MIDDLE;
    [userButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(actionContactUser) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:userButton];
    
    //下单人电话数字
    NSString *userName = intention.userName ? intention.userName : @"-";
    NSString *userMobile = [NSString stringWithFormat:@"(%@%@)", userName, intention.userMobile ? intention.userMobile : @"-"];
    NSMutableAttributedString *userStr = [[NSMutableAttributedString alloc]initWithString:userMobile];
    NSRange userRange = {1 + [userName length],[userStr length] - 2 - [userName length]};
    [userStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:userRange];
    [userButton setAttributedTitle:userStr forState:UIControlStateNormal];
    
    [userButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(userLabel.mas_right).offset(2);
        
        make.height.equalTo(@16);
    }];
    
    //联系人
    UILabel *nameTitle = [self makeLabel:@"服务联系人："];
    [infoView addSubview:nameTitle];
    
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(userTitle.mas_bottom).offset(9);
        make.left.equalTo(iconView.mas_right).offset(10);
        
        make.width.equalTo(@96);
        make.height.equalTo(@16);
    }];
    
    //姓名
    UILabel *nameLabel = [self makeLabel:intention.buyerName ? intention.buyerName : @"-"];
    [infoView addSubview:nameLabel];
    
    [nameLabel sizeToFit];
    CGFloat nameWidth = nameLabel.frame.size.width;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(userTitle.mas_bottom).offset(9);
        make.left.equalTo(nameTitle.mas_right);
        
        make.width.equalTo([NSNumber numberWithFloat:nameWidth]);
        make.height.equalTo(@16);
    }];
    
    //电话
    UIButton *mobileButton = [[UIButton alloc] init];
    mobileButton.backgroundColor = [UIColor clearColor];
    mobileButton.titleLabel.font = FONT_MIDDLE;
    [mobileButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mobileButton addTarget:self action:@selector(actionContactBuyer) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:mobileButton];
    
    //电话号码数字
    NSString *buyerMobile = [NSString stringWithFormat:@"(%@)", intention.buyerMobile ? intention.buyerMobile : @"-"];
    NSMutableAttributedString *mobileStr = [[NSMutableAttributedString alloc]initWithString:buyerMobile];
    NSRange contentRange = {1,[mobileStr length] - 2};
    [mobileStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [mobileButton setAttributedTitle:mobileStr forState:UIControlStateNormal];
    
    [mobileButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(userTitle.mas_bottom).offset(9);
        make.left.equalTo(nameLabel.mas_right).offset(2);
        
        make.height.equalTo(@16);
    }];
    
    //服务地址
    UILabel *addressLabel = [self makeLabel:@"服务地址：-"];
    addressLabel.text = [NSString stringWithFormat:@"服务地址：%@", intention.buyerAddress ? intention.buyerAddress : @"-"];
    addressLabel.textColor = [UIColor colorWithHexString:@"585858"];
    addressLabel.font = FONT_MIDDLE;
    addressLabel.numberOfLines = 0;
    [infoView addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(nameTitle.mas_bottom);
        make.left.equalTo(iconView.mas_right).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@40);
    }];
    
    //需求
    UILabel *remarkTitle = [self makeLabel:@"需求："];
    [infoView addSubview:remarkTitle];
    
    [remarkTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(addressLabel.mas_bottom).offset(5);
        make.left.equalTo(iconView.mas_right).offset(10);
        
        make.height.equalTo(@16);
    }];
    
    //需求备注
    UITextView *remarkTextView = [[UITextView alloc] init];
    remarkTextView.textColor = [UIColor colorWithHexString:@"585858"];
    remarkTextView.font = FONT_MIDDLE;
    remarkTextView.editable = NO;
    //内边距为0
    if (IS_IOS7_PLUS) {
        remarkTextView.textContainerInset = UIEdgeInsetsZero;
    }
    [infoView addSubview:remarkTextView];
    
    NSString *customerRemark = [NSString stringWithFormat:@"%@ (%@%@)",
                                intention.customerRemark ? intention.customerRemark : @"",
                                intention.typeName ? intention.typeName : @"",
                                intention.propertyName && [intention.propertyName length] > 0 ? [NSString stringWithFormat:@"-%@", intention.propertyName] : @""
                                ];
    remarkTextView.text = customerRemark ? customerRemark : @"-";
    
    [remarkTextView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(remarkTitle.mas_bottom).offset(5);
        make.left.equalTo(iconView.mas_right).offset(5);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@50);
    }];
    
    return cell;
}

//文本
- (UILabel *) makeLabel: (NSString *) text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = FONT_MAIN;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark - Action
- (void) actionContactUser
{
    [self.delegate actionPopupMobile:intention.userMobile];
}

- (void) actionContactBuyer
{
    [self.delegate actionPopupMobile:intention.buyerMobile];
}

- (void) actionClose
{
    [self.delegate actionPopupClose];
}

- (void) actionCompeteCase
{
    [self.delegate actionPopupCompete:intention.id];
}

@end
