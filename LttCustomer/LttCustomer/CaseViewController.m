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
#import "HomeViewController.h"

@interface CaseViewController () <CaseNewViewDelegate, CaseLockedViewDelegate, CaseTopayViewDelegate, CasePayedViewDelegate, CaseSuccessViewDelegate>

@end

@implementation CaseViewController
{
    OrderEntity *order;
    TimerUtil *timerUtil;
    long timer;
}

@synthesize intention;

- (void)viewDidLoad {
    hideBackButton = YES;
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    //修正闪烁
    self.view.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    
    self.navigationItem.title = TIP_LOADING_MESSAGE;
    
    //获取需求状态
    [self intentionView];
    //[self loadIntention];
}

//关闭计时器
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (timerUtil) {
        [timerUtil invalidate];
    }
}

- (void)loadIntention
{
    //查询需求
    NSLog(@"intentionId: %@", self.caseId);
    
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = self.caseId;
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //调用接口
    CaseHandler *intentionHandler = [[CaseHandler alloc] init];
    [intentionHandler queryIntention:intentionEntity success:^(NSArray *result){
        [self hideLoading];
        
        intention = [result firstObject];
        
        NSLog(@"需求数据：%@", [intention toDictionary]);
        
        //是否需要查询订单
        if ([intention hasOrder]) {
            [self loadOrder];
        } else {
            //根据需求加载view
            [self intentionView];
        }
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        
        [self showError:error.message];
    }];
}

- (void)loadOrder
{
    //@todo 查询订单
    
    order = [[OrderEntity alloc] init];
    order.no = intention.orderNo;
    order.amount = @9993;
    order.buyerMobile = @"18875001455";
    order.buyerName = @"吴勇";
    order.sellerMobile = @"13345673333";
    order.sellerName = @"刘亚卓";
    order.status = CASE_STATUS_TOPAY;
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
    [self intentionView];
}

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
    
    CaseHandler *intentionHandler = [[CaseHandler alloc] init];
    [intentionHandler cancelIntention:intentionEntity success:^(NSArray *result){
        //取消成功
        [self.navigationController popViewControllerAnimated:YES];
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
    order.status = CASE_STATUS_PAYED;
    [self intentionView];
}

- (void)actionComment:(int)value
{
    //todo: 评分
    
    order.commentLevel = [NSNumber numberWithInt:value];
    order.status = CASE_STATUS_SUCCESS;
    [self intentionView];
}

- (void)actionHome
{
    HomeViewController *viewController = [[HomeViewController alloc] init];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
}

@end
