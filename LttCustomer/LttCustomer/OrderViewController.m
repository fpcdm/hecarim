//
//  OrderViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderNewView.h"
#import "OrderReceivedView.h"
#import "OrderSuccessView.h"
#import "OrderEntity.h"

@interface OrderViewController () <OrderNewViewDelegate, OrderReceivedViewDelegate, OrderSuccessViewDelegate>

@end

@implementation OrderViewController
{
    UIView *orderView;
    OrderEntity *order;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    hideBackButton = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"账单确认并支付";
    
    [self loadOrder];
}

- (void)loadOrder
{
    //@todo 查询订单
    
    order = [[OrderEntity alloc] init];
    order.no = self.orderNo;
    order.amount = @9993;
    order.buyerMobile = @"18875001455";
    order.buyerName = @"吴勇";
    order.sellerMobile = @"13345673333";
    order.sellerName = @"刘亚卓";
    order.status = ORDER_STATUS_NEW;
    order.commentLevel = @0;
    
    //订单商品
    GoodsEntity *goods = [[GoodsEntity alloc] init];
    goods.id = @1;
    goods.name = @"iPhone6 Plus";
    goods.number = @1;
    goods.price = @5696;
    goods.specName = @"香槟金 64G 国行";
    
    GoodsEntity *goods2 = [[GoodsEntity alloc] init];
    goods2.id = @2;
    goods2.name = @"iPhone5S";
    goods2.number = @1;
    goods2.price = @4200;
    goods2.specName = @"土豪金 16G 国行";
    
    order.goods = @[goods, goods2];
    
    //订单服务
    ServiceEntity *service = [[ServiceEntity alloc] init];
    service.id = @1;
    service.name = @"贴膜";
    service.number = @1;
    service.price = @48;
    service.typeId = @3;
    service.typeName = @"手机上门服务";
    
    ServiceEntity *service2 = [[ServiceEntity alloc] init];
    service2.id = @2;
    service2.name = @"刷系统";
    service2.number = @1;
    service2.price = @49;
    service2.typeId = @3;
    service2.typeName = @"手机上门服务";
    NSArray *services = @[service, service2];
    //服务分组
    order.services = @[services];
    
    //根据订单加载view
    [self orderView];
}

- (void)orderView
{
    if ([order.status isEqualToString:ORDER_STATUS_NEW]) {
        OrderNewView *newView = [[OrderNewView alloc] init];
        newView.delegate = self;
        orderView = newView;
        self.view = newView;
        
        self.navigationItem.title = @"账单确认并支付";
        
        //显示数据
        [newView setData:@"order" value:order];
        [newView renderData];
    } else if ([order.status isEqualToString:ORDER_STATUS_RECEIVED]) {
        OrderReceivedView *receivedView = [[OrderReceivedView alloc] init];
        receivedView.delegate = self;
        orderView = receivedView;
        self.view = receivedView;
        
        self.navigationItem.title = @"服务完成";
        
        //显示数据
        [receivedView setData:@"order" value:order];
        [receivedView renderData];
    } else if ([order.status isEqualToString:ORDER_STATUS_SUCCESS]) {
        OrderSuccessView *successView = [[OrderSuccessView alloc] init];
        successView.delegate = self;
        orderView = successView;
        self.view = successView;
        
        self.navigationItem.title = @"感谢评价";
        
        //显示数据
        [successView setData:@"order" value:order];
        [successView renderData];
    }
}

#pragma mark - Action

@end
