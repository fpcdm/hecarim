//
//  CaseDetailView.m
//  LttCustomer
//
//  Created by wuyong on 15/8/13.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseDetailView.h"
#import "CaseEntity.h"

@implementation CaseDetailView
{
    CaseEntity *intention;
}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    //获取数据
    intention = [self getData:@"intention"];
    
    //添加数据
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    
    //需求信息
    [tableData addObject:@[@{@"id": @"info", @"type": @"custom", @"view": @"cellInfo:", @"height": @230}]];
    
    //商品信息
    [tableData addObject:@[@{@"id": @"goods", @"type": @"custom", @"view": @"cellGoods:", @"height": @100}]];
    
    //服务信息
    [tableData addObject:@[@{@"id": @"service", @"type": @"custom", @"view": @"cellService:", @"height": @100}]];
    
    self.tableData = tableData;
    [self.tableView reloadData];
}

- (UITableViewCell *) cellInfo:(UITableViewCell *)cell
{
    //需求基本数据
    UIView *caseView = [[UIView alloc] init];
    caseView.backgroundColor = [UIColor colorWithHexString:@"7984B5"];
    [cell addSubview:caseView];
    
    UIView *superview = cell;
    [caseView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.height.equalTo(@80);
    }];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.backgroundColor = [UIColor whiteColor];
    iconView.image = [UIImage imageNamed:@"detailIcon"];
    iconView.layer.cornerRadius = 3.0f;
    [caseView addSubview:iconView];
    
    superview = caseView;
    [iconView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        
        make.width.equalTo(@30);
        make.height.equalTo(@34);
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
    noLabel.font = [UIFont boldSystemFontOfSize:SIZE_MAIN_TEXT];
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
    timeLabel.textColor = [UIColor colorWithHexString:@"CCCCCC"];
    timeLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    [caseView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(noTitle.mas_bottom);
        make.left.equalTo(iconView.mas_right).offset(10);
        
        make.height.equalTo(@15);
    }];
    
    UILabel *amountLabel = [self makeLabel:nil];
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.text = [NSString stringWithFormat:@"实付金额：￥%.2f", intention.totalAmount ? [intention.totalAmount floatValue] : 0.00];
    [caseView addSubview:amountLabel];
    
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_bottom).offset(-10);
        make.left.equalTo(iconView.mas_right).offset(10);
    }];
    
    //需求服务数据
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG];
    [cell addSubview:infoView];
    
    superview = cell;
    [infoView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(caseView.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.height.equalTo(@150);
    }];
    
    UIImageView *infoIconView = [[UIImageView alloc] init];
    infoIconView.backgroundColor = [UIColor whiteColor];
    infoIconView.image = [UIImage imageNamed:@"detailIcon"];
    [infoView addSubview:infoIconView];
    
    superview = infoView;
    [infoIconView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        
        make.width.equalTo(@30);
        make.height.equalTo(@34);
    }];
    
    //联系人
    UILabel *nameTitle = [self makeLabel:@"服务联系人："];
    [infoView addSubview:nameTitle];
    
    [nameTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
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
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(nameTitle.mas_right);
        
        make.width.equalTo([NSNumber numberWithFloat:nameWidth]);
        make.height.equalTo(@16);
    }];
    
    //电话
    UIButton *mobileButton = [[UIButton alloc] init];
    mobileButton.backgroundColor = [UIColor clearColor];
    mobileButton.titleLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
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
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(nameLabel.mas_right).offset(10);
        
        make.height.equalTo(@16);
    }];
    
    //服务地址
    UILabel *addressLabel = [self makeLabel:@"服务地址：-"];
    addressLabel.text = [NSString stringWithFormat:@"服务地址：%@", intention.buyerAddress ? intention.buyerAddress : @"-"];
    addressLabel.textColor = [UIColor colorWithHexString:@"585858"];
    addressLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    addressLabel.numberOfLines = 0;
    [infoView addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(nameTitle.mas_bottom).offset(5);
        make.left.equalTo(iconView.mas_right).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
    }];
    
    //需求
    UILabel *remarkTitle = [self makeLabel:@"需求："];
    [infoView addSubview:remarkTitle];
    
    [remarkTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(addressLabel.mas_bottom).offset(10);
        make.left.equalTo(iconView.mas_right).offset(10);
        
        make.height.equalTo(@16);
    }];
    
    //需求备注
    UILabel *remarkLabel = [self makeLabel:@"-"];
    remarkLabel.textColor = [UIColor colorWithHexString:@"585858"];
    remarkLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
    remarkLabel.numberOfLines = 0;
    [infoView addSubview:remarkLabel];
    
    NSString *customerRemark = intention.customerRemark && [intention.customerRemark length] > 0 ? intention.customerRemark : nil;
    if (!customerRemark) customerRemark = (intention.typeName && [intention.typeName length] > 0) ? intention.typeName : @"-";
    remarkLabel.text = customerRemark;
    
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(remarkTitle.mas_bottom).offset(5);
        make.left.equalTo(iconView.mas_right).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
    }];
    
    return cell;
}

- (UITableViewCell *) cellGoods:(UITableViewCell *)cell
{
    return cell;
}

- (UITableViewCell *) cellService:(UITableViewCell *)cell
{
    return cell;
}

- (UILabel *) makeLabel: (NSString *) text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark - TableView
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? HEIGHT_TABLE_MARGIN_DEFAULT : HEIGHT_TABLE_MARGIN_ZERO;
}

#pragma mark - Action
- (void) actionContactBuyer
{
    [self.delegate actionContactBuyer];
}

@end
