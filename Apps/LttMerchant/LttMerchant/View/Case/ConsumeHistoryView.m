//
//  ConsumeHistoryView.m
//  LttMerchant
//
//  Created by wuyong on 15/9/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ConsumeHistoryView.h"
#import "CaseEntity.h"
#import "ConsumeEntity.h"

@implementation ConsumeHistoryView
{
    UIView *headerView;
    
    UILabel *lastLabel;
    UIButton *infoButton;
    UILabel *infoLabel;
}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    
    //初始化header
    headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    headerView.backgroundColor = COLOR_MAIN_BG;
    self.tableView.tableHeaderView = headerView;
    
    //初始化空视图
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 20)];
    emptyLabel.font = FONT_MAIN;
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"暂无消费记录";
    self.tableView.emptyView = emptyLabel;
    
    //用户信息
    infoLabel = [[UILabel alloc] init];
    infoLabel.font = FONT_MIDDLE;
    [headerView addSubview:infoLabel];
    
    UIView *superview = headerView;
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left).offset(10);
        make.height.equalTo(superview.mas_height);
    }];
    
    infoButton = [[UIButton alloc] init];
    infoButton.titleLabel.font = FONT_MIDDLE;
    [infoButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(actionContact) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:infoButton];
    
    [infoButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(infoLabel.mas_right).offset(5);
        make.height.equalTo(superview.mas_height);
    }];
    
    lastLabel = [[UILabel alloc] init];
    lastLabel.font = FONT_MIDDLE;
    [headerView addSubview:lastLabel];
    
    [lastLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(infoButton.mas_right);
        make.height.equalTo(superview.mas_height);
    }];
    
    [self.tableView setLoadingFooter:self action:@selector(actionLoadMore)];
    
    return self;
}

#pragma mark - RenderData
- (void)display
{
    CaseEntity *intention = [self fetch:@"intention"];
    infoLabel.text = [NSString stringWithFormat:@"%@（%@",
                      intention.userAppellation ? intention.userAppellation : @"-",
                      intention.userName ? intention.userName : @"-"
                      ];
    
    NSString *mobileStr = intention.userMobile ? intention.userMobile : @"-";
    NSMutableAttributedString *mobileAttrStr = [[NSMutableAttributedString alloc] initWithString:mobileStr];
    NSRange mobileRange = {0, [mobileStr length]};
    [mobileAttrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:mobileRange];
    [infoButton setAttributedTitle:mobileAttrStr forState:UIControlStateNormal];
    
    lastLabel.text = @"）的消费记录";
    
    //显示数据
    NSMutableArray *historyList = [self fetch:@"historyList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    if (historyList != nil) {
        for (ConsumeEntity *consume in historyList) {
            //动态计算高度
            CGFloat height = 35;
            if (consume.consumeContent) {
                NSArray *goods = [consume.consumeContent objectForKey:@"goods"];
                if (goods && [goods count] > 0) height += 30 + [goods count] * 20;
                NSArray *services = [consume.consumeContent objectForKey:@"services"];
                if (services && [services count] > 0) height += 30 + [services count] * 20;
            }
            
            [tableData addObject:@[@{
                                       @"id" : @"consume",
                                       @"type" : @"custom",
                                       @"height": @(height),
                                       @"data": consume
                                       }]];
        }
    }
    self.tableData = tableData;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    ConsumeEntity *consume = [cellData objectForKey:@"data"];
    cell.backgroundColor = [UIColor whiteColor];
    
    //间距配置
    int padding = 10;
    UIView *superview = cell;
    
    //时间
    UILabel *timeLabel = [self makeCellLabel:consume.consumeTime];
    timeLabel.font = FONT_MIDDLE;
    [cell addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.height.equalTo(@35);
    }];
    
    //商品
    UIView *relateView = timeLabel;
    if (consume.consumeContent) {
        NSArray *goods = [consume.consumeContent objectForKey:@"goods"];
        if (goods && [goods count] > 0) {
            UILabel *goodsTitle = [self makeCellLabel:@"商品"];
            goodsTitle.font = [UIFont boldSystemFontOfSize:16];
            [cell addSubview:goodsTitle];
            
            [goodsTitle mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(relateView.mas_bottom);
                make.left.equalTo(superview.mas_left).offset(padding);
                make.height.equalTo(@20);
            }];
            
            relateView = goodsTitle;
            for (NSString *goodsItem in goods) {
                UILabel *goodsLabel = [self makeCellLabel:goodsItem];
                goodsLabel.font = FONT_MIDDLE;
                goodsLabel.textColor = COLOR_MAIN_DARK;
                [cell addSubview:goodsLabel];
                
                [goodsLabel mas_makeConstraints:^(MASConstraintMaker *make){
                    make.top.equalTo(relateView.mas_bottom);
                    make.left.equalTo(superview.mas_left).offset(padding);
                    make.height.equalTo(@20);
                }];
                
                relateView = goodsLabel;
            }
        }
        
        NSArray *services = [consume.consumeContent objectForKey:@"services"];
        if (services && [services count] > 0) {
            UILabel *serviceTitle = [self makeCellLabel:@"服务"];
            serviceTitle.font = [UIFont boldSystemFontOfSize:16];
            [cell addSubview:serviceTitle];
            
            [serviceTitle mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(relateView.mas_bottom).offset(goods && [goods count] > 0 ? 10 : 0);
                make.left.equalTo(superview.mas_left).offset(padding);
                make.height.equalTo(@20);
            }];
            
            relateView = serviceTitle;
            for (NSString *serviceItem in services) {
                UILabel *serviceLabel = [self makeCellLabel:serviceItem];
                serviceLabel.font = FONT_MIDDLE;
                serviceLabel.textColor = COLOR_MAIN_DARK;
                [cell addSubview:serviceLabel];
                
                [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make){
                    make.top.equalTo(relateView.mas_bottom);
                    make.left.equalTo(superview.mas_left).offset(padding);
                    make.height.equalTo(@20);
                }];
                
                relateView = serviceLabel;
            }
        }
    }
    
    return cell;
}

//绘制cell中的label
- (UILabel *) makeCellLabel: (NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_MAIN;
    return label;
}

#pragma mark - Action
- (void)actionContact
{
    [self.delegate actionContact];
}

- (void)actionLoadMore
{
    [self.delegate actionLoadMore];
}

@end
