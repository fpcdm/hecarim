//
//  IntentionViewController.m
//  LttMember
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseViewController.h"
#import "CaseEntity.h"
#import "CaseNewView.h"
#import "CaseLockedView.h"
#import "CaseConfirmedView.h"
#import "CaseGoodsView.h"
#import "CaseCashierView.h"
#import "CasePayedView.h"
#import "CaseCommentView.h"
#import "CaseSuccessView.h"
#import "CaseDetailView.h"
#import "TimerUtil.h"
#import "CaseHandler.h"
#import "HomeViewController.h"
#import "UIView+Loading.h"
#import "LttAppDelegate.h"

@interface CaseViewController () <CaseNewViewDelegate, CaseLockedViewDelegate, CaseConfirmedViewDelegate, CaseGoodsViewDelegate, CaseCashierViewDelegate, CasePayedViewDelegate, CaseCommentViewDelegate, CaseSuccessViewDelegate, CaseDetailViewDelegate>

@end

@implementation CaseViewController
{
    CaseEntity *intention;
    TimerUtil *timerUtil;
    long timer;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = COLOR_MAIN_BG;
    [self.view showLoading];
}

- (void)viewDidLoad {
    hideBackButton = YES;
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = TIP_LOADING_MESSAGE;
}

//查询状态切换视图
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadData:^(id object){
        [self intentionView];
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
    
    //停止地图
    [self stopMap];
}

//停止地图
- (void) stopMap
{
    if ([self.view isMemberOfClass:[CaseConfirmedView class]]) {
        [(CaseConfirmedView *)self.view stopMap];
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
        intention = [result firstObject];
        
        NSLog(@"需求数据：%@", [intention toDictionary]);
        
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
    } else if ([intention.status isEqualToString:CASE_STATUS_LOCKED]) {
        CaseLockedView *lockedView = [[CaseLockedView alloc] init];
        lockedView.delegate = self;
        self.view = lockedView;
        
        self.navigationItem.title = @"客服已收到";
        
        //显示数据
        [lockedView setData:@"intention" value:intention];
        [lockedView renderData];
    } else if ([intention.status isEqualToString:CASE_STATUS_CONFIRMED]) {
        CaseConfirmedView *confirmedView = [[CaseConfirmedView alloc] init];
        confirmedView.delegate = self;
        self.view = confirmedView;
        
        self.navigationItem.title = @"服务开始了";
        
        //显示数据
        [confirmedView setData:@"intention" value:intention];
        [confirmedView renderData];
    } else if ([intention.status isEqualToString:CASE_STATUS_TOPAY]) {
        //停止地图
        [self stopMap];
        
        CaseGoodsView *topayView = [[CaseGoodsView alloc] init];
        topayView.delegate = self;
        self.view = topayView;
        
        self.navigationItem.title = @"订单确认";
        
        //显示数据
        [topayView setData:@"intention" value:intention];
        [topayView renderData];
    } else if ([intention.status isEqualToString:CASE_STATUS_PAYED]) {
        CaseCommentView *receivedView = [[CaseCommentView alloc] init];
        receivedView.delegate = self;
        self.view = receivedView;
        
        self.navigationItem.title = @"服务完成";
        
        //显示数据
        [receivedView setData:@"intention" value:intention];
        [receivedView renderData];
        
    } else if ([intention.status isEqualToString:CASE_STATUS_SUCCESS]) {
        CaseDetailView *detailView = [[CaseDetailView alloc] init];
        detailView.delegate = self;
        self.view = detailView;
        
        self.navigationItem.title = @"服务单详情";
        
        //显示数据
        [detailView setData:@"intention" value:intention];
        [detailView renderData];
    } else {
        NSString *statusName = [intention statusName];
        self.navigationItem.title = statusName;
        
        [self performSelector:@selector(actionHome) withObject:nil afterDelay:DIALOG_SHOW_TIME];
    }
}

- (void)cashierView
{
    CaseCashierView *cashierView = [[CaseCashierView alloc] init];
    cashierView.delegate = self;
    self.view = cashierView;
    
    self.navigationItem.title = @"两条腿收银台";
    
    //显示数据
    [cashierView setData:@"intention" value:intention];
    [cashierView renderData];
}

- (void)payedView
{
    CasePayedView *payedView = [[CasePayedView alloc] init];
    payedView.delegate = self;
    self.view = payedView;
    
    self.navigationItem.title = @"支付确认";
    
    //显示数据
    [payedView setData:@"intention" value:intention];
    [payedView renderData];
}

#pragma mark - RemoteNotification
//处理远程通知钩子（当前需求时自动切换页面）
- (void) handleRemoteNotification:(NSString *)message type:(NSString *)type data:(NSString *)data
{
    //仅当当前需求时自动切换页面
    BOOL isCurrentCase = NO;
    if ([@"CASE_LOCKED" isEqualToString:type] ||
        [@"CASE_CONFIRMED" isEqualToString:type] ||
        [@"CASE_WAIT_PAY" isEqualToString:type] ||
        [@"CASE_MERCHANT_CANCEL" isEqualToString:type]) {
        if (data && [self.caseId isEqualToNumber:[NSNumber numberWithInteger:[data integerValue]]]) {
            isCurrentCase = YES;
        }
    }
    
    //非当前需求默认方式
    if (!isCurrentCase) {
        [super handleRemoteNotification:message type:type data:data];
        return;
    }
    
    //显示消息
    [self showMessage:message];
    
    //取消消息
    [NotificationUtil cancelRemoteNotifications];
    //清空服务器数量
    LttAppDelegate *appDelegate = (LttAppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate clearNotifications];
    
    //需求状态变化
    [self loadData:^(id object){
        [self intentionView];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
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
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", intention.staffMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

- (void)actionComplain
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", LTT_CUSTOMER_SERVICE];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

- (void)actionContactBuyer
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", intention.buyerMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

- (void)actionPay
{
    [self cashierView];
}

//微信扫码
- (void)actionWeixinQrcode
{
    //检查微信扫码
    NSURL *url = [NSURL URLWithString:URL_SCHEME_WEIXIN_QRCODE];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        [self payedView];
    } else {
        [self showError:@"请先安装微信再扫码支付哦~亲！"];
    }
}

//支付宝扫码
- (void)actionAlipayQrcode
{
    //检查微信扫码
    NSURL *url = [NSURL URLWithString:URL_SCHEME_ALIPAY_QRCODE];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        [self payedView];
    } else {
        [self showError:@"请先安装支付宝再扫码支付哦~亲！"];
    }
}

//现金支付
- (void)actionUseMoney
{
    [self payedView];
}

//确认付款完成
- (void)actionConfirmPayed
{
    //检测需求状态是否有修改
    [self loadData:^(id object){
        //已经支付完成
        if ([intention.status isEqualToString:CASE_STATUS_PAYED] ||
            [intention.status isEqualToString:CASE_STATUS_SUCCESS]) {
            [self intentionView];
        //还未支付完成
        } else {
            [self showError:@"请等待商户确认收款成功哦~亲！"];
        }
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

//重新选择支付方式
- (void)actionRechooseMethod
{
    [self cashierView];
}

//评价
- (void)actionComment:(int)value
{
    if (value < 1) {
        [self showError:ERROR_COMMENT_REQUIRED];
        return;
    }
    
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = self.caseId;
    intentionEntity.no = intention.no;
    intentionEntity.rateStar = [NSNumber numberWithInt:value];
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler addIntentionEvaluation:intentionEntity success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            intention.rateStar = [NSNumber numberWithInt:value];
            intention.status = CASE_STATUS_SUCCESS;
            
            //显示评价成功页面
            CaseSuccessView *successView = [[CaseSuccessView alloc] init];
            successView.delegate = self;
            self.view = successView;
            
            self.navigationItem.title = @"感谢评价";
            
            //显示数据
            [successView setData:@"intention" value:intention];
            [successView renderData];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void)actionHome
{
    HomeViewController *viewController = [[HomeViewController alloc] init];
    [self toggleViewController:viewController animated:YES];
}

@end
