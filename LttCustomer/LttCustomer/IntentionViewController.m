//
//  IntentionViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "IntentionViewController.h"
#import "IntentionEntity.h"
#import "IntentionNewView.h"
#import "IntentionLockedView.h"
#import "OrderViewController.h"
#import "TimerUtil.h"

@interface IntentionViewController () <IntentionNewViewDelegate, IntentionLockedViewDelegate>

@end

@implementation IntentionViewController
{
    IntentionEntity *intention;
    UIView *intentionView;
    TimerUtil *timerUtil;
    long timer;
}

- (void)viewDidLoad {
    hideBackButton = YES;
    isIndexNavBar = YES;
    isMenuEnabled = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"等待响应";
    
    //获取需求状态
    [self loadIntention];
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
    //@todo 查询需求
    
    intention = [[IntentionEntity alloc] init];
    intention.id = self.intentionId;
    intention.status = INTENTION_STATUS_NEW;
    intention.orderNo = @"111111";
    intention.employeeName = @"刘亚卓";
    intention.employeeMobile = @"13345673333";
    
    //模拟下一步
    UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonItem:@"下一步" highlighted:YES];
    barButtonItem.target = self;
    barButtonItem.action = @selector(actionNext);
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    //根据需求加载view
    [self intentionView];
}

- (void)intentionView
{
    if ([intention.status isEqualToString:INTENTION_STATUS_NEW]) {
        IntentionNewView *newView = [[IntentionNewView alloc] init];
        newView.delegate = self;
        intentionView = newView;
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
        
    } else if ([intention.status isEqualToString:INTENTION_STATUS_LOCKED]) {
        IntentionLockedView *lockedView = [[IntentionLockedView alloc] init];
        lockedView.delegate = self;
        intentionView = lockedView;
        self.view = lockedView;
        
        self.navigationItem.title = @"客服已收到";
        
        //显示数据
        [lockedView setData:@"intention" value:intention];
        [lockedView renderData];
    } else if ([intention.status isEqualToString:INTENTION_STATUS_SUCCESS]) {
        OrderViewController *viewController = [[OrderViewController alloc] init];
        viewController.orderNo = intention.orderNo;
        [self pushViewController:viewController animated:YES];
    }
}

#pragma mark - Action
//模拟下一步
- (void)actionNext
{
    if ([intention.status isEqualToString:INTENTION_STATUS_NEW]) {
        //停止计时器
        if (timerUtil) {
            [timerUtil invalidate];
            timerUtil = nil;
        }
        
        intention.status = INTENTION_STATUS_LOCKED;
        [self intentionView];
    } else if ([intention.status isEqualToString:INTENTION_STATUS_LOCKED]) {
        intention.status = INTENTION_STATUS_SUCCESS;
        [self intentionView];
    }
}

- (void)actionCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionMobile
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", intention.employeeMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

@end
