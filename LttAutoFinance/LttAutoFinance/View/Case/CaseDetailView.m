//
//  CaseDetailView.m
//  LttAutoFinance
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
    
    //计算高度
    CGFloat goodsHeight = 70;
    NSInteger goodsCount = intention.goods ? [intention.goods count] : 0;
    goodsHeight += goodsCount > 0 ? goodsCount * 50 : 30;
    
    CGFloat serviceHeight = 70;
    NSInteger serviceCount = intention.services ? [intention.services count] : 0;
    serviceHeight += serviceCount > 0 ? serviceCount * 25 : 30;
    
    //添加数据
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    
    //需求信息
    [tableData addObject:@[@{@"id": @"info", @"type": @"custom", @"view": @"cellInfo:", @"height": @230}]];
    
    //商品信息
    [tableData addObject:@[@{@"id": @"goods", @"type": @"custom", @"view": @"cellGoods:", @"height": [NSNumber numberWithFloat:goodsHeight]}]];
    
    //服务信息
    [tableData addObject:@[@{@"id": @"service", @"type": @"custom", @"view": @"cellService:", @"height": [NSNumber numberWithFloat:serviceHeight]}]];
    
    self.tableData = tableData;
    [self.tableView reloadData];
}

- (UITableViewCell *) cellInfo:(UITableViewCell *)cell
{
    //需求基本数据
    UIView *caseView = [[UIView alloc] init];
    caseView.backgroundColor = [UIColor colorWithHexString:@"F38600"];
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
    timeLabel.textColor = [UIColor colorWithHexString:@"CCCCCC"];
    timeLabel.font = FONT_MIDDLE;
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
    infoView.backgroundColor = COLOR_MAIN_WHITE;
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
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(nameLabel.mas_right).offset(10);
        
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
    
    NSString *customerRemark = intention.customerRemark && [intention.customerRemark length] > 0 ? intention.customerRemark : nil;
    if (!customerRemark) customerRemark = (intention.typeName && [intention.typeName length] > 0) ? intention.typeName : @"-";
    remarkTextView.text = customerRemark;
    
    [remarkTextView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(remarkTitle.mas_bottom).offset(5);
        make.left.equalTo(iconView.mas_right).offset(5);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@50);
    }];
    
    return cell;
}

- (UITableViewCell *) cellGoods:(UITableViewCell *)cell
{
    //商品标题
    UILabel *goodsTitle = [UILabel new];
    goodsTitle.text = @"商品";
    goodsTitle.backgroundColor = [UIColor clearColor];
    goodsTitle.textColor = COLOR_MAIN_BLACK;
    goodsTitle.font = [UIFont boldSystemFontOfSize:18];
    [cell addSubview:goodsTitle];
    
    int padding = 10;
    
    UIView *superview = cell;
    [goodsTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(5);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@30);
    }];
    
    //分隔
    UIView *relateview = [self separatorView:goodsTitle];
    
    //有商品
    NSInteger goodsCount = intention.goods ? [intention.goods count] : 0;
    if (goodsCount > 0) {
        //商品列表
        for (GoodsEntity *goods in intention.goods) {
            //名称
            UILabel *nameLabel = [UILabel new];
            nameLabel.text = goods.name;
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textColor = COLOR_MAIN_BLACK;
            nameLabel.font = FONT_MAIN;
            [cell addSubview:nameLabel];
            
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(relateview.mas_bottom);
                make.left.equalTo(superview.mas_left).offset(padding);
                
                make.height.equalTo(@25);
            }];
            
            //单价
            UILabel *priceLabel = [UILabel new];
            priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [goods.price floatValue]];
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.textColor = COLOR_MAIN_BLACK;
            priceLabel.font = FONT_MAIN_BOLD;
            [cell addSubview:priceLabel];
            
            [priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(relateview.mas_bottom);
                make.right.equalTo(superview.mas_right).offset(-padding);
                
                make.height.equalTo(@25);
            }];
            
            //规格
            UILabel *specLabel = [UILabel new];
            specLabel.text = goods.specName;
            specLabel.backgroundColor = [UIColor clearColor];
            specLabel.textColor = COLOR_MAIN_DARK;
            specLabel.font = FONT_MAIN;
            [cell addSubview:specLabel];
            
            [specLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(nameLabel.mas_bottom);
                make.left.equalTo(superview.mas_left).offset(padding);
                
                make.height.equalTo(@25);
            }];
            
            //数量
            UILabel *numberLabel = [UILabel new];
            numberLabel.backgroundColor = [UIColor clearColor];
            numberLabel.text = [NSString stringWithFormat:@"x%@", goods.number];
            numberLabel.textColor = COLOR_MAIN_DARK;
            numberLabel.font = FONT_MAIN;
            [cell addSubview:numberLabel];
            
            [numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(priceLabel.mas_bottom);
                make.right.equalTo(superview.mas_right).offset(-padding);
                
                make.height.equalTo(@25);
            }];
            
            relateview = [self separatorView:numberLabel];
        }
    //没有商品
    } else {
        UILabel *emptyLabel = [UILabel new];
        emptyLabel.text = @"没有商品";
        emptyLabel.backgroundColor = [UIColor clearColor];
        emptyLabel.textColor = COLOR_MAIN_BLACK;
        emptyLabel.font = FONT_MAIN;
        [cell addSubview:emptyLabel];
        
        [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(relateview.mas_bottom);
            make.left.equalTo(superview.mas_left).offset(padding);
            
            make.height.equalTo(@30);
        }];
        
        relateview = [self separatorView:emptyLabel];
    }
    
    //总价
    UILabel *totalLabel = [UILabel new];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.textColor = COLOR_MAIN_BLACK;
    totalLabel.font = FONT_MAIN;
    [cell addSubview:totalLabel];
    
    //小计金额
    NSString *numberStr = [NSString stringWithFormat:@"%ld", goodsCount];
    NSString *amountStr = [NSString stringWithFormat:@"￥%.2f", [intention.goodsAmount floatValue]];
    NSString *totalText = [NSString stringWithFormat:@"共%@件商品 小计金额：%@", numberStr, amountStr];
    
    NSMutableAttributedString *totalAttributedText = [[NSMutableAttributedString alloc] initWithString:totalText];
    //NSRange计数从0开始，第二个参数为长度
    NSRange numberRange = {1, [numberStr length]};
    [totalAttributedText addAttribute:NSFontAttributeName value:FONT_MAIN_BOLD range:numberRange];
    NSRange amountRange = {numberRange.length + 10, [amountStr length]};
    [totalAttributedText addAttribute:NSFontAttributeName value:FONT_MAIN_BOLD range:amountRange];
    totalLabel.attributedText = totalAttributedText;
    
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_bottom);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@35);
    }];
    
    return cell;
}

- (UITableViewCell *) cellService:(UITableViewCell *)cell
{
    //服务标题
    UILabel *servicesTitle = [UILabel new];
    servicesTitle.backgroundColor = [UIColor clearColor];
    servicesTitle.text = @"上门服务";
    servicesTitle.textColor = COLOR_MAIN_BLACK;
    servicesTitle.font = [UIFont boldSystemFontOfSize:18];
    [cell addSubview:servicesTitle];
    
    int padding = 10;
    
    UIView *superview = cell;
    [servicesTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(5);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@30);
    }];
    
    //分隔
    UIView *relateview = [self separatorView:servicesTitle];
    
    NSInteger serviceCount = intention.services ? [intention.services count] : 0;
    //有服务
    if (serviceCount > 0) {
        for (ServiceEntity *service in intention.services) {
            //名称
            UILabel *nameLabel = [UILabel new];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = service.name;
            nameLabel.textColor = COLOR_MAIN_BLACK;
            nameLabel.font = FONT_MAIN;
            [cell addSubview:nameLabel];
            
            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(relateview.mas_bottom);
                make.left.equalTo(superview.mas_left).offset(padding);
                
                make.height.equalTo(@25);
            }];
            
            //价格
            UILabel *priceLabel = [UILabel new];
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [[service total] floatValue]];
            priceLabel.textColor = COLOR_MAIN_BLACK;
            priceLabel.font = FONT_MAIN_BOLD;
            [cell addSubview:priceLabel];
            
            [priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(relateview.mas_bottom);
                make.right.equalTo(superview.mas_right).offset(-padding);
                
                make.height.equalTo(@25);
            }];
            
            relateview = priceLabel;
        }
        
        relateview = [self separatorView:relateview];
    //没有服务
    } else {
        UILabel *emptyLabel = [UILabel new];
        emptyLabel.text = @"没有服务";
        emptyLabel.backgroundColor = [UIColor clearColor];
        emptyLabel.textColor = COLOR_MAIN_BLACK;
        emptyLabel.font = FONT_MAIN;
        [cell addSubview:emptyLabel];
        
        [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(relateview.mas_bottom);
            make.left.equalTo(superview.mas_left).offset(padding);
            make.height.equalTo(@30);
        }];
        
        relateview = [self separatorView:emptyLabel];
    }
    
    //总价
    UILabel *totalLabel = [UILabel new];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.textColor = COLOR_MAIN_BLACK;
    totalLabel.font = FONT_MAIN;
    [cell addSubview:totalLabel];
    
    //小计金额
    NSString *totalText = [NSString stringWithFormat:@"小计金额：￥%.2f", [intention.servicesAmount floatValue]];
    NSMutableAttributedString *totalAttributedText = [[NSMutableAttributedString alloc] initWithString:totalText];
    //NSRange计数从0开始，第二个参数为长度
    NSRange boldRange = {5, [totalText length] - 5};
    [totalAttributedText addAttribute:NSFontAttributeName value:FONT_MAIN_BOLD range:boldRange];
    totalLabel.attributedText = totalAttributedText;
    
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_bottom);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@35);
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

//分割线
- (UIView *)separatorView: (UIView *)view
{
    UIView *sepratorView = [[UIView alloc] init];
    sepratorView.backgroundColor = [UIColor blackColor];
    [view.superview addSubview:sepratorView];
    
    [sepratorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(view.mas_bottom);
        make.left.equalTo(view.superview.mas_left).offset(10);
        make.right.equalTo(view.superview.mas_right);
        
        make.height.equalTo(@0.5);
    }];
    
    return sepratorView;
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
