//
//  OrderDetailViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/4/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderFormViewController.h"
#import "ZBarSDK.h"
#import "OrderEntity.h"
#import "OrderHandler.h"
#import "UIViewController+BackButtonHandler.h"
#import "CaseListActivity.h"

@interface OrderDetailViewController () <MBProgressHUDDelegate, ZBarReaderDelegate>

@end

@implementation OrderDetailViewController
{
    OrderEntity *order;
    MBProgressHUD *hud;
}

@synthesize qrcodeView, finishView;

@synthesize goodsTextView, employeeButton, finishTextLabel, finishTimeLabel;

@synthesize orderNo;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    [self initView];
}

//修改返回按钮事件
- (BOOL) navigationShouldPopOnBackButton
{
    CaseListActivity *viewController = [[CaseListActivity alloc] init];
    [self toggleViewController:viewController animated:YES];
    return YES;
}

- (void) initView
{
    //隐藏初始数据
    self.goodsTextView.hidden = YES;
    self.employeeButton.hidden = YES;
    
    NSLog(@"orderNo: %@", self.orderNo);
    if (self.orderNo == nil) {
        [self showError:LocalString(@"ERROR_PARAM_REQUIRED")];
        return;
    }
    
    [self loadOrder];
}

- (void) loadOrder
{
    [self showLoading:LocalString(@"TIP_LOADING_MESSAGE")];
    
    OrderEntity *orderModel = [[OrderEntity alloc] init];
    orderModel.no = self.orderNo;
    
    //调用接口
    OrderHandler *orderHandler = [[OrderHandler alloc] init];
    [orderHandler queryOrder:orderModel success:^(NSArray *result){
        [self hideLoading];
        
        order = [result firstObject];
        [self initOrder];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        [self showError:error.message];
    }];
}

- (void) initOrder
{
    NSString *employeeText = (order.buyerName ? [order.buyerName stringByAppendingString:@"  "] : @"");
    employeeText = [employeeText stringByAppendingString:order.buyerMobile];
    [self.employeeButton setTitle:employeeText forState:UIControlStateNormal];
    [self.employeeButton addTarget:self action:@selector(actionMobile) forControlEvents:UIControlEventTouchUpInside];
    self.employeeButton.hidden = NO;
    
    NSString *goodsText = @"";
    //商品
    GoodsEntity *goodsModel = [[GoodsEntity alloc] init];
    if (order.goodsParam) {
        NSArray *goodsList = [order.goodsParam objectForKey:@"list"];
        if (goodsList && [goodsList count] > 0) {
            for (NSDictionary *goods in goodsList) {
                //转换为商品Model
                goodsModel.id = [goods objectForKey:@"goods_id"];
                goodsModel.name = [goods objectForKey:@"goods_name"];
                goodsModel.number = [goods objectForKey:@"goods_num"];
                goodsModel.price = [goods objectForKey:@"goods_price"];
                
                NSNumber *total = [goodsModel total];
                goodsText = [goodsText stringByAppendingFormat:@"%@：%@ x %@ = %@元\n", goodsModel.name, goodsModel.price, goodsModel.number, total];
            }
        }
    }
    //服务
    if (order.services && [order.services count] > 0) {
        NSDictionary *servicesDict = [order.services objectAtIndex:0];
        NSArray *servicesList = servicesDict ? [servicesDict objectForKey:@"list"] : @[];
        if (servicesList && [servicesList count] > 0) {
            goodsText = [goodsText stringByAppendingFormat:@"\n%@\n\n", [servicesDict objectForKey:@"remark"]];
            for (NSDictionary *service in servicesList) {
                NSString *serviceName = [service objectForKey:@"detail"];
                NSString *servicePrice = [service objectForKey:@"price"];
                goodsText = [goodsText stringByAppendingFormat:@"%@：%@元\n", serviceName, servicePrice];
            }
        }
    }
    //总价
    goodsText = [goodsText stringByAppendingFormat:@"\n合计：%@元", order.amount];
    
    self.goodsTextView.text = goodsText;
    self.goodsTextView.editable = NO;
    self.goodsTextView.hidden = NO;
    
    //根据状态处理
    [self checkStatus];
}

- (void) checkStatus
{
    //根据状态不同操作不同
    NSLog(@"order status: %@", order.status);
    if ([CASE_STATUS_CONFIRMED isEqualToString:order.status]) {
        [self statusNew];
    } else if ([CASE_STATUS_PAYED isEqualToString:order.status] || [CASE_STATUS_TOPAY isEqualToString:order.status]) {
        [self statusReceived];
    } else if ([CASE_STATUS_SUCCESS isEqualToString:order.status]) {
        [self statusSuccess];
    } else {
        [self statusFail];
    }
}

#pragma mark - Status Methods
-(void) statusNew
{
    //暂时同已收货操作
    [self statusReceived];
}

-(void) statusReceived
{
    self.qrcodeView.hidden = YES;
    self.finishView.hidden = YES;
}

- (void) statusSuccess
{
    self.qrcodeView.hidden = YES;
    self.finishView.hidden = NO;
    
    self.finishTimeLabel.text = [NSString stringWithFormat:@"完成时间：%@", order.updateTime];
}

- (void) statusFail
{
    self.qrcodeView.hidden = YES;
    self.finishView.hidden = NO;
    
    self.finishTextLabel.text = @"交易失败";
    self.finishTextLabel.textColor = [UIColor redColor];
    self.finishTimeLabel.text = [NSString stringWithFormat:@"失败时间：%@", order.updateTime];
}

#pragma mark - Actions
- (IBAction)changeOrderAction:(id)sender {
    OrderFormViewController *viewController = [[OrderFormViewController alloc] init];
    viewController.orderNo = self.orderNo;
    [self pushViewController:viewController animated:YES];
}

- (IBAction)qrcodeScanAction:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    if ([ZBarReaderController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        reader.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [reader.scanner setSymbology:ZBAR_I25
                          config:ZBAR_CFG_ENABLE
                              to:0];
    
    [self presentViewController:reader animated:YES completion:nil];
}

// 获取识别结果
- (void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for (symbol in results) {
        //grab the first
        break;
    }
    
    [reader dismissViewControllerAnimated:YES completion:nil];
    
    NSString *qrcode = symbol.data;
    [self confirmOrder:qrcode];
}

//确认订单号
- (void) confirmOrder: (NSString *) qrcode
{
    [self showLoading:LocalString(@"TIP_REQUEST_MESSAGE")];
    
    OrderEntity *orderModel = [[OrderEntity alloc] init];
    orderModel.no = self.orderNo;
    
    NSDictionary *param = @{@"qrcode": qrcode};
    
    //调用接口
    OrderHandler *orderHandler = [[OrderHandler alloc] init];
    [orderHandler confirmOrder:orderModel param:param success:^(NSArray *result){
        [self hideLoading];
        
        [self loadOrder];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        [self showError:error.message];
    }];
}

- (void)actionMobile
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", order.buyerMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

@end
