//
//  RechargeViewController.m
//  LttMember
//
//  Created by wuyong on 15/12/14.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeView.h"
#import "ValidateUtil.h"

@interface RechargeViewController () <RechargeViewDelegate>

@end

@implementation RechargeViewController
{
    RechargeView *rechargeView;
}

- (void)loadView
{
    rechargeView = [[RechargeView alloc] init];
    rechargeView.delegate = self;
    self.view = rechargeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值";
}

#pragma mark - Action
- (void)actionRecharge:(NSString *)amount payWay:(NSString *)payWay
{
    if (![ValidateUtil isRequired:amount]) {
        [self showError:@"请填写充值金额哦~亲！"];
        return;
    }
    if (![ValidateUtil isPositiveNumber:amount]) {
        [self showError:@"充值金额填写不正确"];
        return;
    }
    if (![ValidateUtil isRequired:payWay]) {
        [self showError:@"请选择支付方式哦~亲！"];
        return;
    }
    
    float rechargeAmount = [amount floatValue];
    //todo
    
}

@end
