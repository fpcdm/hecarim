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

@interface ApplyDetailViewController () <MBProgressHUDDelegate>

@end

@implementation ApplyDetailViewController
{
    IntentionEntity *intention;
    MBProgressHUD *hud;
}

@synthesize brandLabel, modelLabel, remarkLabel, employeeButton;

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
        
        //仅当lock时进入此页面
        intention.status = INTENTION_STATUS_LOCKED;
        if ([INTENTION_STATUS_LOCKED isEqualToString:intention.status]) {
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
    self.brandLabel.text = [@"品牌：" stringByAppendingString:(intention.brandName ? intention.brandName : @"未填写")];
    self.brandLabel.hidden = NO;
    
    self.modelLabel.text = [@"型号：" stringByAppendingString:(intention.modelName ? intention.modelName : @"未填写")];
    self.modelLabel.hidden = NO;
    
    self.remarkLabel.text = [@"留言：" stringByAppendingString:(intention.remark ? intention.remark : @"未填写")];
    self.remarkLabel.hidden = NO;
    
    NSString *employeeText = (intention.employeeName ? [intention.employeeName stringByAppendingString:@"  "] : @"");
    employeeText = [employeeText stringByAppendingString:(intention.employeeMobile ? intention.employeeMobile : @"")];
    [self.employeeButton setTitle:employeeText forState:UIControlStateNormal];
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
    
    //删除过期需求本地存储
    NSNumber *localIntention = [[StorageUtil sharedStorage] getIntention];
    if (localIntention && [localIntention isEqualToNumber:self.intentionId]) {
        [[StorageUtil sharedStorage] setIntention:nil];
    }
    
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
        
        //删除过期需求本地存储
        NSNumber *localIntention = [[StorageUtil sharedStorage] getIntention];
        if (localIntention && [localIntention isEqualToNumber:self.intentionId]) {
            [[StorageUtil sharedStorage] setIntention:nil];
        }
        
        //跳转首页
        HomeViewController *viewController = [[HomeViewController alloc] init];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        
        [self showError:error.message];
    }];
}

- (IBAction)createSubmitAction:(id)sender {
    //跳转需求详情
    OrderFormViewController *viewController = [[OrderFormViewController alloc] init];
    viewController.intentionId = intention.id;
    
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
}
@end
