//
//  OrderNewView.m
//  LttMember
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseTopayView.h"
#import "CaseEntity.h"

@implementation CaseTopayView
{
    UILabel *titleLabel;
    UIView *orderView;
    UIButton *payButton;
    CaseEntity *intention;
    //分隔视图
    UIView *orderSeparator;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请您确认并支付";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = COLOR_MAIN_HIGHLIGHT;
    titleLabel.font = [UIFont boldSystemFontOfSize:26];
    [self addSubview:titleLabel];
    
    UIView *superview = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(40);
        make.centerX.equalTo(superview.mas_centerX);
        
    }];
    
    //支付按钮
    payButton = [AppUIUtil makeButton:@"" font:FONT_MAIN_BOLD];
    [payButton addTarget:self action:@selector(actionPay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:payButton];
    
    [payButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_bottom).offset(-5);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MAIN_BUTTON]);
    }];
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    intention = [self getData:@"intention"];
    
    //总高度计算
    long goodsCount = intention.goods ? [intention.goods count] : 0;
    long servicesCount = intention.services ? [intention.services count] : 0;
    
    float totalHeight = 0.0;
    if (goodsCount > 0) {
        totalHeight += 30 + 25 + (goodsCount * 40);
    }
    if (servicesCount > 0) {
        totalHeight += 30 + 25 + (servicesCount * 20);
    }
    totalHeight += 5 + 30;
    
    //无数据高度计算
    if (goodsCount < 1 && servicesCount < 1) {
        totalHeight = 70;
    }
    
    //滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = COLOR_MAIN_BG;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    [self addSubview:scrollView];
    
    UIView *superview = self;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.bottom.equalTo(superview.mas_bottom).offset(-60);
    }];
    
    //详情容器
    orderView = [[UIView alloc] init];
    orderView.layer.cornerRadius = 3.0f;
    orderView.backgroundColor = COLOR_MAIN_WHITE;
    orderView.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, totalHeight - 30);
    [scrollView addSubview:orderView];
    
    //是否显示滚动条
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 20, totalHeight);
    
    //无商品和服务
    if (goodsCount < 1 && servicesCount < 1) {
        UILabel *emptyTitle = [UILabel new];
        emptyTitle.backgroundColor = [UIColor clearColor];
        emptyTitle.text = @"没有商品和服务";
        emptyTitle.textColor = COLOR_MAIN_BLACK;
        emptyTitle.font = FONT_MAIN;
        [orderView addSubview:emptyTitle];
        
        [emptyTitle mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(orderView.mas_top);
            make.left.equalTo(orderView.mas_left).offset(10);
            
            make.height.equalTo(@40);
        }];
    }
    
    //商品
    if (goodsCount > 0) {
        [self renderGoods];
    }
    
    //服务
    if (servicesCount > 0) {
        [self renderServices:intention.services];
    }
    
    //合计
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.backgroundColor = COLOR_MAIN_BG;
    totalLabel.text = [NSString stringWithFormat:@"合计：￥%.2f", [intention.totalAmount floatValue]];
    totalLabel.textColor = COLOR_MAIN_DARK;
    totalLabel.font = [UIFont boldSystemFontOfSize:20];
    //自动计算宽度
    [totalLabel sizeToFit];
    CGSize labelSize = totalLabel.frame.size;
    totalLabel.frame = CGRectMake(SCREEN_WIDTH - 10 - labelSize.width, totalHeight - 30, labelSize.width, 30);
    [scrollView addSubview:totalLabel];
    
    //按钮
    [payButton setTitle:[NSString stringWithFormat:@"确认并支付%.2f元", [intention.totalAmount floatValue]] forState:UIControlStateNormal];
}

- (void)renderGoods
{
    //商品标题
    UILabel *goodsTitle = [UILabel new];
    goodsTitle.text = @"商品";
    goodsTitle.backgroundColor = [UIColor clearColor];
    goodsTitle.textColor = COLOR_MAIN_DARK;
    goodsTitle.font = FONT_MAIN;
    [orderView addSubview:goodsTitle];
    
    UIView *superview = orderView;
    int padding = 5;
    int textpadding = 3;
    [goodsTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        
        make.height.equalTo(@20);
    }];
    
    //分隔
    UIView *relateview = [self separatorView:goodsTitle];
    
    //商品列表
    for (GoodsEntity *goods in intention.goods) {
        //名称
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = goods.name;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = COLOR_MAIN_DARK;
        nameLabel.font = FONT_MIDDLE;
        [orderView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(relateview.mas_bottom).offset(textpadding);
            make.left.equalTo(superview.mas_left).offset(padding);
            make.height.equalTo(@17);
        }];
        
        //单价
        UILabel *priceLabel = [UILabel new];
        priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [goods.price floatValue]];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textColor = COLOR_MAIN_DARK;
        priceLabel.font = FONT_MIDDLE_BOLD;
        [orderView addSubview:priceLabel];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(relateview.mas_bottom).offset(textpadding);
            make.right.equalTo(superview.mas_right).offset(-padding);
            make.height.equalTo(@17);
            
        }];
        
        //规格
        UILabel *specLabel = [UILabel new];
        specLabel.text = goods.specName;
        specLabel.backgroundColor = [UIColor clearColor];
        specLabel.textColor = COLOR_MAIN_GRAY;
        specLabel.font = FONT_MIDDLE;
        [orderView addSubview:specLabel];
        
        [specLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(nameLabel.mas_bottom).offset(textpadding);
            make.left.equalTo(superview.mas_left).offset(padding);
            make.height.equalTo(@17);
            
        }];
        
        //数量
        UILabel *numberLabel = [UILabel new];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.text = [NSString stringWithFormat:@"x%@", goods.number];
        numberLabel.textColor = [UIColor grayColor];
        numberLabel.font = FONT_MIDDLE;
        [orderView addSubview:numberLabel];
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(priceLabel.mas_bottom).offset(textpadding);
            make.right.equalTo(superview.mas_right).offset(-padding);
            make.height.equalTo(@17);
            
        }];
        
        //分隔
        relateview = numberLabel;
    }
    
    //分隔
    relateview = [self separatorView:relateview];
    
    //总价
    UILabel *totalLabel = [UILabel new];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.text = [NSString stringWithFormat:@"￥%.2f", [intention.goodsAmount floatValue]];
    totalLabel.textColor = COLOR_MAIN_DARK;
    totalLabel.font = FONT_MIDDLE;
    [orderView addSubview:totalLabel];
    
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(relateview.mas_bottom).offset(textpadding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.height.equalTo(@17);
        
    }];
    
    //分隔视图
    orderSeparator = totalLabel;
}

- (void)renderServices:(NSArray *)services
{
    //服务标题
    UILabel *servicesTitle = [UILabel new];
    servicesTitle.backgroundColor = [UIColor clearColor];
    servicesTitle.text = @"上门服务";
    servicesTitle.textColor = COLOR_MAIN_DARK;
    servicesTitle.font = FONT_MAIN;
    [orderView addSubview:servicesTitle];
    
    UIView *superview = orderView;
    int padding = 5;
    int textpadding = 3;
    [servicesTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(orderSeparator ? orderSeparator.mas_bottom : superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.height.equalTo(@20);
    }];
    
    //分隔
    UIView *relateview = [self separatorView:servicesTitle];
    
    //服务列表
    for (ServiceEntity *service in services) {
        //名称
        UILabel *nameLabel = [UILabel new];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.text = service.typeName;
        nameLabel.textColor = COLOR_MAIN_DARK;
        nameLabel.font = FONT_MIDDLE;
        [orderView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(relateview.mas_bottom).offset(textpadding);
            make.left.equalTo(superview.mas_left).offset(padding);
            make.height.equalTo(@17);
        }];
        
        //价格
        UILabel *priceLabel = [UILabel new];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [[service total] floatValue]];
        priceLabel.textColor = COLOR_MAIN_DARK;
        priceLabel.font = FONT_MIDDLE_BOLD;
        [orderView addSubview:priceLabel];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(relateview.mas_bottom).offset(textpadding);
            make.right.equalTo(superview.mas_right).offset(-padding);
            make.height.equalTo(@17);
        }];
        
        //分隔
        relateview = priceLabel;
    }
    
    //分隔
    relateview = [self separatorView:relateview];
    
    //总价
    UILabel *totalLabel = [UILabel new];
    totalLabel.backgroundColor = [UIColor clearColor];
    totalLabel.text = [NSString stringWithFormat:@"￥%.2f", [intention.servicesAmount floatValue]];
    totalLabel.textColor = COLOR_MAIN_DARK;
    totalLabel.font = FONT_MIDDLE;
    [orderView addSubview:totalLabel];
    
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(relateview.mas_bottom).offset(textpadding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        make.height.equalTo(@17);
        
    }];
    
    //分隔视图
    orderSeparator = totalLabel;
}

- (UIView *)separatorView: (UIView *)view
{
    //间隔
    UIView *sepratorView = [[UIView alloc] init];
    sepratorView.backgroundColor = [UIColor colorWithHexString:@"979797"];
    [orderView addSubview:sepratorView];
    
    [sepratorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(view.mas_bottom).offset(4);
        make.left.equalTo(orderView.mas_left).offset(5);
        make.right.equalTo(orderView.mas_right).offset(-5);
        
        make.height.equalTo(@1);
    }];
    
    return sepratorView;
}

#pragma mark - Action
- (void)actionPay
{
    [self.delegate actionPay];
}

@end
