//
//  OrderNewView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "OrderNewView.h"
#import "OrderEntity.h"

@implementation OrderNewView
{
    UILabel *titleLabel;
    UIView *orderView;
    UIButton *payButton;
    OrderEntity *order;
    //分隔视图
    UIView *orderSeparator;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请您确认并支付";
    titleLabel.textColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_HIGHLIGHTED];
    titleLabel.font = [UIFont boldSystemFontOfSize:26];
    [self addSubview:titleLabel];
    
    UIView *superview = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(40);
        make.centerX.equalTo(superview.mas_centerX);
        
    }];
    
    //支付按钮
    payButton = [AppUIUtil makeButton:@"" font:[UIFont boldSystemFontOfSize:SIZE_BUTTON_TEXT]];
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
    order = [self getData:@"order"];
    
    //详情容器
    orderView = [[UIView alloc] init];
    orderView.layer.cornerRadius = 3.0f;
    orderView.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG];
    [self addSubview:orderView];
    
    //总高度计算
    long goodsCount = order.goods ? [order.goods count] : 0;
    long servicesCount = order.services ? [order.services count] : 0;
    
    float totalHeight = 0.0;
    if (goodsCount > 0) {
        totalHeight += 30 + 25 + (goodsCount * 40);
    }
    if (servicesCount > 0) {
        for (NSArray *services in order.services) {
            totalHeight += 30 + 25 + ([services count] * 20);
        }
    }
    totalHeight += 5;
    
    UIView *superview = self;
    [orderView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo([NSNumber numberWithFloat:totalHeight]);
    }];
    
    //商品
    if (goodsCount > 0) {
        [self renderGoods];
    }
    
    //服务
    if (servicesCount > 0) {
        for (NSArray *services in order.services) {
            [self renderServices:services];
        }
    }
    
    //合计
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.text = [NSString stringWithFormat:@"合计：￥%.2f", [order.amount floatValue]];
    totalLabel.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
    totalLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:totalLabel];
    
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(orderView.mas_bottom).offset(5);
        make.right.equalTo(orderView.mas_right).offset(-5);
    }];
    
    //按钮
    [payButton setTitle:[NSString stringWithFormat:@"确认并支付%.2f元", [order.amount floatValue]] forState:UIControlStateNormal];
    
}

- (void)renderGoods
{
    //商品标题
    UILabel *goodsTitle = [UILabel new];
    goodsTitle.text = @"商品";
    goodsTitle.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
    goodsTitle.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
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
    float goodsTotal = 0.0f;
    for (GoodsEntity *goods in order.goods) {
        goodsTotal += [[goods total] floatValue];
        //名称
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = goods.name;
        nameLabel.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
        nameLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
        [orderView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(relateview.mas_bottom).offset(textpadding);
            make.left.equalTo(superview.mas_left).offset(padding);
            make.height.equalTo(@17);
        }];
        
        //单价
        UILabel *priceLabel = [UILabel new];
        priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [goods.price floatValue]];
        priceLabel.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
        priceLabel.font = [UIFont boldSystemFontOfSize:SIZE_MIDDLE_TEXT];
        [orderView addSubview:priceLabel];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(relateview.mas_bottom).offset(textpadding);
            make.right.equalTo(superview.mas_right).offset(-padding);
            make.height.equalTo(@17);
            
        }];
        
        //规格
        UILabel *specLabel = [UILabel new];
        specLabel.text = goods.specName;
        specLabel.textColor = [UIColor colorWithHexString:COLOR_GRAY_TEXT];
        specLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
        [orderView addSubview:specLabel];
        
        [specLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(nameLabel.mas_bottom).offset(textpadding);
            make.left.equalTo(superview.mas_left).offset(padding);
            make.height.equalTo(@17);
            
        }];
        
        //数量
        UILabel *numberLabel = [UILabel new];
        numberLabel.text = [NSString stringWithFormat:@"x%@", goods.number];
        numberLabel.textColor = [UIColor grayColor];
        numberLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
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
    totalLabel.text = [NSString stringWithFormat:@"￥%.2f", goodsTotal];
    totalLabel.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
    totalLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
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
    //获取服务分类
    ServiceEntity *service = [services objectAtIndex:0];
    
    //服务标题
    UILabel *servicesTitle = [UILabel new];
    servicesTitle.text = service.typeName;
    servicesTitle.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
    servicesTitle.font = [UIFont systemFontOfSize:SIZE_MAIN_TEXT];
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
    float serviceTotal = 0.0f;
    for (ServiceEntity *service in services) {
        serviceTotal += [[service total] floatValue];
        //名称
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = service.name;
        nameLabel.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
        nameLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
        [orderView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(relateview.mas_bottom).offset(textpadding);
            make.left.equalTo(superview.mas_left).offset(padding);
            make.height.equalTo(@17);
        }];
        
        //价格
        UILabel *priceLabel = [UILabel new];
        priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [[service total] floatValue]];
        priceLabel.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
        priceLabel.font = [UIFont boldSystemFontOfSize:SIZE_MIDDLE_TEXT];
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
    totalLabel.text = [NSString stringWithFormat:@"￥%.2f", serviceTotal];
    totalLabel.textColor = [UIColor colorWithHexString:COLOR_DARK_TEXT];
    totalLabel.font = [UIFont systemFontOfSize:SIZE_MIDDLE_TEXT];
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
