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
#import "WXApi.h"
#import "AlipayOrder.h"
#import <AlipaySDK/AlipaySDK.h>

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
    [self showError:@"todo"];
}

- (void)actionWeixinRecharge:(float)amount
{
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }else{
                NSString *msg = [dict objectForKey:@"retmsg"];
            }
        }else{
            NSString *msg = @"服务器返回错误，未获取到json对象";
        }
    }else{
        NSString *msg = @"服务器返回错误";
    }
}

- (void)actionAlipayRecharge:(float)amount
{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    AlipayOrder *order = [[AlipayOrder alloc] init];
    order.partner = nil;
    order.seller = nil;
    order.tradeNO = @""; //订单ID（由商家自行制定）
    order.productName = @""; //商品标题
    order.productDescription = @""; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",amount]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    order.sign = @"";
    order.signType = @"RSA";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkcomlttoklttmember";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order orderSpec];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = [order orderStr];
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

@end
