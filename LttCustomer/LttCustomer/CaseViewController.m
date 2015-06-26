//
//  IntentionViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseViewController.h"
#import "CaseEntity.h"
#import "OrderEntity.h"
#import "CaseNewView.h"
#import "CaseLockedView.h"
#import "CaseTopayView.h"
#import "CasePayedView.h"
#import "CaseSuccessView.h"
#import "TimerUtil.h"
#import "CaseHandler.h"
#import "OrderHandler.h"
#import "HomeViewController.h"
#import "AppLoadingView.h"

@interface CaseViewController () <CaseNewViewDelegate, CaseLockedViewDelegate, CaseTopayViewDelegate, CasePayedViewDelegate, CaseSuccessViewDelegate>

@end

@implementation CaseViewController
{
    CaseEntity *intention;
    CaseEntity *newIntention;
    OrderEntity *order;
    OrderEntity *newOrder;
    TimerUtil *timerUtil;
    long timer;
    TimerUtil *refreshUtil;
}

- (void)loadView
{
    showLoadingView = YES;
    [super loadView];
}

- (void)viewDidLoad {
    hideBackButton = YES;
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = TIP_LOADING_MESSAGE;
}

//查询订单状态切换视图
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadData:^(id object){
        //显示视图
        intention = newIntention;
        order = newOrder;
        [self intentionView];
        
        //初始化定时器
        if ([intention needRefresh]) {
            refreshUtil = [TimerUtil repeatTimer:5.0 block:^{
                [self loadData:^(id object){
                    //状态发生改变
                    if (![newIntention.status isEqualToString:intention.status]) {
                        intention = newIntention;
                        order = newOrder;
                        
                        //是否清除定时器
                        if (![intention needRefresh]) {
                            [refreshUtil invalidate];
                            refreshUtil = nil;
                        }
                        
                        //修改视图
                        [self intentionView];
                    }
                } failure:^(id object){
                }];
            } queue:dispatch_get_main_queue()];
        }
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

//关闭计时器
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (timerUtil) {
        [timerUtil invalidate];
    }
    if (refreshUtil) {
        [refreshUtil invalidate];
    }
}

//加载需求数据
- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //查询需求
    NSLog(@"intentionId: %@", self.caseId);
    
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = self.caseId;
    
    //调用接口
    CaseHandler *intentionHandler = [[CaseHandler alloc] init];
    [intentionHandler queryIntention:intentionEntity success:^(NSArray *result){
        newIntention = [result firstObject];
        
        NSLog(@"需求数据：%@", [newIntention toDictionary]);
        
        //是否需要查询订单
        if ([newIntention hasOrder]) {
            [self loadOrderData:success failure:failure];
        } else {
            success(nil);
        }
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

//加载订单数据
- (void)loadOrderData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //查询订单
    NSLog(@"orderNo: %@", newIntention.orderNo);
    
    OrderEntity *orderEntity = [[OrderEntity alloc] init];
    orderEntity.no = newIntention.orderNo;
    
    //调用接口
    OrderHandler *orderHandler = [[OrderHandler alloc] init];
    [orderHandler queryOrder:orderEntity success:^(NSArray *result){
        newOrder = [result firstObject];
        
        //解析订单商品
        NSMutableArray *goodsArray = [NSMutableArray arrayWithObjects:nil];
        if (newOrder.goodsParam) {
            NSArray *goodsList = [newOrder.goodsParam objectForKey:@"list"];
            if (goodsList && [goodsList count] > 0) {
                for (NSDictionary *goodsItem in goodsList) {
                    GoodsEntity *goods = [[GoodsEntity alloc] init];
                    goods.id = [goodsItem objectForKey:@"goods_id"];
                    goods.name = [goodsItem objectForKey:@"goods_name"];
                    goods.number = [goodsItem objectForKey:@"goods_num"];
                    goods.price = [goodsItem objectForKey:@"goods_price"];
                    goods.specName = [goodsItem objectForKey:@"specs"];
                    
                    [goodsArray addObject:goods];
                }
            }
        }
        newOrder.goods = goodsArray;
        
        //解析服务
        NSMutableArray *servicesArray = [NSMutableArray arrayWithObjects:nil];
        if (newOrder.services && [newOrder.services count] > 0) {
            for (NSDictionary *servicesDict in newOrder.services) {
                NSArray *serviceList = [servicesDict objectForKey:@"list"];
                NSString *typeName = [servicesDict objectForKey:@"remark"];
                NSMutableArray *servicesGroup = [NSMutableArray arrayWithObjects:nil];
                if (serviceList && [serviceList count] > 0) {
                    for (NSDictionary *serviceItem in serviceList) {
                        ServiceEntity *service = [[ServiceEntity alloc] init];
                        service.name = [serviceItem objectForKey:@"detail"];
                        service.number = @1;
                        service.price = [serviceItem objectForKey:@"price"];
                        service.typeName = typeName;
                        
                        [servicesGroup addObject:service];
                    }
                    [servicesArray addObject:servicesGroup];
                }
            }
        }
        newOrder.services = servicesArray;
        
        NSLog(@"订单数据：%@", [newOrder toDictionary]);
        
        success(nil);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

//根据状态切换视图
- (void)intentionView
{
    if ([intention.status isEqualToString:CASE_STATUS_NEW]) {
        CaseNewView *newView = [[CaseNewView alloc] init];
        newView.delegate = self;
        self.view = newView;
        
        self.navigationItem.title = @"等待响应";
        
        //定时器，主线程才能更新UI
        timer = 0;
        timerUtil = [TimerUtil repeatTimer:1 block:^{
            DDLogDebug(@"定时器：%ld", timer);
            long minutes = 0;
            long seconds = 0;
            if (timer >= 60) {
                minutes = timer / 60;
                seconds = timer % 60;
            } else {
                seconds = timer;
            }
            
            NSString *minuteStr = [NSString stringWithFormat:(minutes > 9 ? @"%ld" : @"0%ld"), minutes];
            NSString *secondStr = [NSString stringWithFormat:(seconds > 9 ? @"%ld" : @"0%ld"), seconds];
            newView.timerLabel.text = [NSString stringWithFormat:@"%@:%@", minuteStr, secondStr];
            
            //计时器加1
            timer++;
        } queue:dispatch_get_main_queue()];
    } else if ([intention.status isEqualToString:CASE_STATUS_LOCKED] || [intention.status isEqualToString:CASE_STATUS_CONFIRMED]) {
        CaseLockedView *lockedView = [[CaseLockedView alloc] init];
        lockedView.delegate = self;
        self.view = lockedView;
        
        self.navigationItem.title = @"客服已收到";
        
        //显示数据
        [lockedView setData:@"intention" value:intention];
        [lockedView renderData];
    } else if ([intention.status isEqualToString:CASE_STATUS_TOPAY]) {
        CaseTopayView *topayView = [[CaseTopayView alloc] init];
        topayView.delegate = self;
        self.view = topayView;
        
        self.navigationItem.title = @"账单确认并支付";
        
        //显示数据
        [topayView setData:@"order" value:order];
        [topayView renderData];
    } else if ([intention.status isEqualToString:CASE_STATUS_PAYED]) {
        CasePayedView *receivedView = [[CasePayedView alloc] init];
        receivedView.delegate = self;
        self.view = receivedView;
        
        self.navigationItem.title = @"服务完成";
        
        //显示数据
        [receivedView setData:@"order" value:order];
        [receivedView renderData];
        
    } else if ([intention.status isEqualToString:CASE_STATUS_SUCCESS]) {
        CaseSuccessView *successView = [[CaseSuccessView alloc] init];
        successView.delegate = self;
        self.view = successView;
        
        self.navigationItem.title = @"感谢评价";
        
        //显示数据
        [successView setData:@"order" value:order];
        [successView renderData];
    }
}

#pragma mark - Action
- (void)actionCancel
{
    //取消需求
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = self.caseId;
    
    NSLog(@"取消需求: %@", intentionEntity.id);
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    CaseHandler *intentionHandler = [[CaseHandler alloc] init];
    [intentionHandler cancelIntention:intentionEntity success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            //取消成功
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void)actionMobile
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", intention.employeeMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

- (void)actionPay
{
    OrderEntity *orderModel = [[OrderEntity alloc] init];
    orderModel.no = order.no;
    
    NSDictionary *param = @{@"action": CASE_STATUS_PAYED};
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //调用接口
    OrderHandler *orderHandler = [[OrderHandler alloc] init];
    [orderHandler updateOrderStatus:orderModel param:param success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            intention.status = CASE_STATUS_PAYED;
            [self intentionView];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void)actionComment:(int)value
{
    if (value < 1) {
        [self showError:ERROR_COMMENT_REQUIRED];
        return;
    }
    
    OrderEntity *orderModel = [[OrderEntity alloc] init];
    orderModel.no = order.no;
    
    NSDictionary *param = @{@"action": CASE_STATUS_SUCCESS};
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //调用接口
    OrderHandler *orderHandler = [[OrderHandler alloc] init];
    [orderHandler updateOrderStatus:orderModel param:param success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            order.commentLevel = [NSNumber numberWithInt:value];
            intention.status = CASE_STATUS_SUCCESS;
            [self intentionView];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void)actionHome
{
    HomeViewController *viewController = [[HomeViewController alloc] init];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
}

@end
