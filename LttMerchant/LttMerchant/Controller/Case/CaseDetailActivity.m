//
//  CaseDetailActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/28.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseDetailActivity.h"
#import "IntentionEntity.h"
#import "OrderEntity.h"
#import "IntentionHandler.h"
#import "OrderHandler.h"
#import "ServiceEntity.h"

@interface CaseDetailActivity ()

@end

@implementation CaseDetailActivity
{
    IntentionEntity *intention;
    OrderEntity *order;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //加载数据
    [self loadData:^(id object){
        [self reloadData];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (NSString *) templateName
{
    return @"caseDetail.html";
}

#pragma mark - View
- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
    
}

- (void)onTemplateFailed
{
    
}

- (void)onTemplateCancelled
{
    
}

#pragma mark - Data
//加载需求数据
- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //查询需求
    NSLog(@"intentionId: %@", self.caseId);
    
    IntentionEntity *intentionEntity = [[IntentionEntity alloc] init];
    intentionEntity.id = self.caseId;
    
    //调用接口
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    [intentionHandler queryIntention:intentionEntity success:^(NSArray *result){
        intention = [result firstObject];
        
        NSLog(@"需求数据：%@", [intention toDictionary]);
        
        //是否需要查询订单
        if ([intention hasOrder]) {
            [self loadOrderData:success failure:failure];
        } else {
            success(nil);
        }
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

//加载订单数据
- (void)loadOrderData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //查询订单
    NSLog(@"orderNo: %@", intention.orderNo);
    
    OrderEntity *orderEntity = [[OrderEntity alloc] init];
    orderEntity.no = intention.orderNo;
    
    //调用接口
    OrderHandler *orderHandler = [[OrderHandler alloc] init];
    [orderHandler queryOrder:orderEntity success:^(NSArray *result){
        order = [result firstObject];
        
        //解析订单商品
        NSMutableArray *goodsArray = [NSMutableArray arrayWithObjects:nil];
        if (order.goodsParam) {
            NSArray *goodsList = [order.goodsParam objectForKey:@"list"];
            if (goodsList && [goodsList count] > 0) {
                for (NSDictionary *goodsItem in goodsList) {
                    GoodsEntity *goods = [[GoodsEntity alloc] init];
                    goods.id = [goodsItem objectForKey:@"goods_id"];
                    goods.name = [goodsItem objectForKey:@"goods_name"];
                    goods.number = [goodsItem objectForKey:@"goods_num"];
                    goods.price = [goodsItem objectForKey:@"goods_price"];
                    goods.specName = [goodsItem objectForKey:@"specs"];
                    
                    [goodsArray addObject:goods];
                }
            }
        }
        order.goods = goodsArray;
        
        //解析服务
        NSMutableArray *servicesArray = [NSMutableArray arrayWithObjects:nil];
        if (order.services && [order.services count] > 0) {
            for (NSDictionary *servicesDict in order.services) {
                NSArray *serviceList = [servicesDict objectForKey:@"list"];
                NSString *typeName = [servicesDict objectForKey:@"remark"];
                NSMutableArray *servicesGroup = [NSMutableArray arrayWithObjects:nil];
                if (serviceList && [serviceList count] > 0) {
                    for (NSDictionary *serviceItem in serviceList) {
                        ServiceEntity *service = [[ServiceEntity alloc] init];
                        service.name = [serviceItem objectForKey:@"detail"];
                        service.number = @1;
                        service.price = [serviceItem objectForKey:@"price"];
                        service.typeName = typeName;
                        
                        [servicesGroup addObject:service];
                    }
                    [servicesArray addObject:servicesGroup];
                }
            }
        }
        order.services = servicesArray;
        
        NSLog(@"订单数据：%@", [order toDictionary]);
        
        success(nil);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

#pragma mark - reloadData
- (void) reloadData
{
    self.viewStorage[@"intention"] = @{
                                       @"no": intention.orderNo,
                                       @"status": intention.status,
                                       @"statusName": intention.statusName,
                                       @"time": intention.createTime
                                       };
    
    [self relayout];
}

#pragma mark - Action
//抢单
- (void) actionCompeteCase: (SamuraiSignal *)signal
{
    //获取数据
    IntentionEntity *intentionEntity = [[IntentionEntity alloc] init];
    intentionEntity.id = self.caseId;
    
    //开始抢单
    [self showLoading:LocalString(@"TIP_CHALLENGE_START")];
    
    //调用接口
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    [intentionHandler competeIntention:intentionEntity success:^(NSArray *result){
        [self loadingSuccess:LocalString(@"TIP_CHALLENGE_SUCCESS") callback:^{
            //todo: 跳转需求详情
            CaseDetailActivity *viewController = [[CaseDetailActivity alloc] init];
            viewController.caseId = intention.id;
            [self pushViewController:viewController animated:YES];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:LocalString(@"TIP_CHALLENGE_FAIL")];
    }];
}

@end
