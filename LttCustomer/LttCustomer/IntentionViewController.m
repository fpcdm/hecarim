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

@interface IntentionViewController () <IntentionNewViewDelegate, IntentionLockedViewDelegate>

@end

@implementation IntentionViewController
{
    IntentionEntity *intention;
    UIView *intentionView;
}

- (void)viewDidLoad {
    hideBackButton = YES;
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    //解决闪烁
    self.view.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    
    self.navigationItem.title = @"等待响应";
    
    //获取需求状态
    [self loadIntention];
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
    } else if ([intention.status isEqualToString:INTENTION_STATUS_LOCKED]) {
        IntentionLockedView *lockedView = [[IntentionLockedView alloc] init];
        lockedView.delegate = self;
        intentionView = lockedView;
        self.view = lockedView;
        
        self.navigationItem.title = @"客服已收到";
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
        intention.status = INTENTION_STATUS_LOCKED;
        [self intentionView];
    } else if ([intention.status isEqualToString:INTENTION_STATUS_LOCKED]) {
        intention.status = INTENTION_STATUS_SUCCESS;
        [self intentionView];
    }
}

@end
