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
#import "CaseHandler.h"
#import "PaymentHandler.h"
#import "LttAppDelegate.h"

@interface RechargeViewController () <RechargeViewDelegate>

@end

@implementation RechargeViewController
{
    RechargeView *rechargeView;
    NSArray *payments;
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
    
    [self showLoading:TIP_LOADING_MESSAGE];
    
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    NSDictionary *param = @{@"is_online": @"yes"};
    [caseHandler queryPayments:param success:^(NSArray *result) {
        [self hideLoading];
        
        payments = result;
        
        [rechargeView setData:@"payments" value:payments];
        [rechargeView renderData];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
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
    
    NSNumber *rechargeAmount = [NSNumber numberWithFloat:[amount floatValue]];
    if ([PAY_WAY_WEIXIN isEqualToString:payWay]) {
        [self actionWeixinRecharge:rechargeAmount];
    } else if ([PAY_WAY_ALIPAY isEqualToString:payWay]) {
        [self actionAlipayRecharge:rechargeAmount];
    }
}

//只支持App版本
- (void)actionWeixinRecharge:(NSNumber *)amount
{
    //是否安装微信
    if (![WXApi isWXAppInstalled]) {
        [self showError:@"请先安装微信再充值哦~亲！"];
        return;
    }
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //生成微信订单
    PaymentEntity *payment = [[PaymentEntity alloc] init];
    payment.amount = amount;
    payment.type = @1;
    
    PaymentHandler *paymentHandler = [[PaymentHandler alloc] init];
    [paymentHandler makeWeixinOrder:payment param:nil success:^(NSArray *result) {
        [self hideLoading];
        
        //调用微信支付
        PayReq *req = [result firstObject];
        [WXApi sendReq:req];
        
        //日志输出
        NSLog(@"partid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

//支持App和网页版
- (void)actionAlipayRecharge:(NSNumber *)amount
{
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //生成支付宝订单
    PaymentEntity *payment = [[PaymentEntity alloc] init];
    payment.amount = amount;
    payment.type = @1;
    
    PaymentHandler *paymentHandler = [[PaymentHandler alloc] init];
    [paymentHandler makeAlipayOrder:payment param:nil success:^(NSArray *result) {
        [self hideLoading];
        
        AlipayOrder *order = [result firstObject];
        
        //应用注册scheme,在Info.plist定义URL types
        NSString *appScheme = URL_SCHEME_APIPAY_CALLBACK;
        
        //将商品信息拼接成字符串
        NSString *orderSpec = [order orderSpec];
        NSLog(@"orderSpec = %@",orderSpec);
        
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [order orderStr];
        NSLog(@"orderStr = %@", orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            //支付宝返回结果（实际结果看账户余额或订单状态）
            BOOL status = NO;
            NSString *message = nil;
            if ([resultDic[@"resultStatus"] intValue]==9000) {
                status = YES;
                NSLog(@"充值成功");
            } else {
                status = NO;
                message = [NSString stringWithFormat:@"(%@-%@)", resultDic[@"resultStatus"], resultDic[@"memo"]];
                NSLog(@"充值失败:%@", message);
            }
            
            //统一处理回调
            LttAppDelegate *appDelegate = (LttAppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate rechargeCallback:status message:message];
        }];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

@end
