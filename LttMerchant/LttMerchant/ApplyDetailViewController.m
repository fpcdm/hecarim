//
//  ApplyDetailViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/4/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ApplyDetailViewController.h"
#import "IntentionEntity.h"
#import "OrderDetailViewController.h"
#import "OrderFormViewController.h"
#import "HomeViewController.h"
#import "IntentionHandler.h"
#import "OrderEntity.h"
#import "OrderHandler.h"

@interface ApplyDetailViewController () <MBProgressHUDDelegate>

@end

@implementation ApplyDetailViewController
{
    IntentionEntity *intention;
    MBProgressHUD *hud;
}

@synthesize brandLabel, modelLabel, remarkLabel, employeeButton, submitButton;

@synthesize intentionId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"需求详情";
    
    [self initView];
}

- (void) initView
{
    //隐藏初始数据
    self.brandLabel.hidden = YES;
    self.modelLabel.hidden = YES;
    self.remarkLabel.hidden = YES;
    
    NSLog(@"intentionId: %@", self.intentionId);
    if (self.intentionId == nil) {
        [self showError:LocalString(@"ERROR_PARAM_REQUIRED")];
        return;
    }
    
    [self showLoading:LocalString(@"TIP_LOADING_MESSAGE")];
    
    IntentionEntity *intentionModel = [[IntentionEntity alloc] init];
    intentionModel.id = self.intentionId;
    
    //调用接口
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    [intentionHandler queryIntention:intentionModel success:^(NSArray *result){
        [self hideLoading];
        
        intention = [result firstObject];
        
        //仅当lock和confirmed时进入此页面
        if ([CASE_STATUS_LOCKED isEqualToString:intention.status] || [CASE_STATUS_CONFIRMED isEqualToString:intention.status]) {
            [self initIntention];
        } else {
            [self intentionOverdue];
        }
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        [self showError:error.message];
    }];
}

- (void) initIntention
{
    self.brandLabel.hidden = YES;
    
    self.modelLabel.hidden = YES;
    
    self.remarkLabel.text = [@"留言：" stringByAppendingString:(intention.remark ? intention.remark : @"未填写")];
    self.remarkLabel.hidden = NO;
    
    NSString *employeeText = (intention.userName ? [intention.userName stringByAppendingString:@"  "] : @"");
    employeeText = [employeeText stringByAppendingString:(intention.userMobile ? intention.userMobile : @"")];
    [self.employeeButton setTitle:employeeText forState:UIControlStateNormal];
    [self.employeeButton addTarget:self action:@selector(actionMobile) forControlEvents:UIControlEventTouchUpInside];
    
    //修改按钮
    NSLog(@"需求状态: %@", intention.status);
    if ([CASE_STATUS_LOCKED isEqualToString:intention.status]) {
        [submitButton setTitle:@"开始服务" forState: UIControlStateNormal];
        [submitButton addTarget:self action:@selector(actionServiceStart:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [submitButton setTitle:@"服务完成" forState: UIControlStateNormal];
        [submitButton addTarget:self action:@selector(actionCreateOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)actionMobile
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", intention.userMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

//需求已过期
- (void) intentionOverdue
{
    //清空视图
    for (UIView *view in [self.view subviews]) {
        view.hidden = YES;
    }
    
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        hud.delegate = self;
    }
    
    hud.labelText = @"需求已过期";
    hud.detailsLabelText = @"正在为您跳转首页";
    
    [hud show:YES];
    
    [self performSelector:@selector(showFail) withObject:nil afterDelay:2];
}

- (void) showFail
{
    HomeViewController *viewController = [[HomeViewController alloc] init];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
}

- (IBAction)cancelSubmitAction:(id)sender {
    [self showLoading:LocalString(@"TIP_REQUEST_MESSAGE")];
    
    //调用接口
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    [intentionHandler giveupIntention:intention success:^(NSArray *result){
        [self hideLoading];
        
        //跳转首页
        HomeViewController *viewController = [[HomeViewController alloc] init];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        
        [self showError:error.message];
    }];
}

- (void)actionServiceStart:(id)sender {
    OrderEntity *orderModel = [[OrderEntity alloc] init];
    orderModel.no = intention.orderNo;
    
    NSDictionary *param = @{@"action": CASE_STATUS_CONFIRMED};
    
    //调用接口
    OrderHandler *orderHandler = [[OrderHandler alloc] init];
    [orderHandler updateOrderStatus:orderModel param:param success:^(NSArray *result){
        intention.status = CASE_STATUS_CONFIRMED;
        
        [submitButton setTitle:@"服务完成" forState: UIControlStateNormal];
        [submitButton removeTarget:self action:@selector(actionServiceStart:) forControlEvents:UIControlEventTouchUpInside];
        [submitButton addTarget:self action:@selector(actionCreateOrder:) forControlEvents:UIControlEventTouchUpInside];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void)actionCreateOrder:(id)sender {
    //跳转需求详情
    OrderFormViewController *viewController = [[OrderFormViewController alloc] init];
    viewController.intentionId = intention.id;
    
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
}
@end
