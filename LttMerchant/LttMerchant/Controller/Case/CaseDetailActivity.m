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
#import "UIView+Loading.h"

@interface CaseDetailActivity ()

@property (nonatomic, strong) UITextView *caseAddress;

@property (nonatomic, strong) UITextView *caseRemark;

@property (nonatomic, strong) UITableView *goodsTable;

@property (nonatomic, strong) UITableView *servicesTable;

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
    [self showLoading:TIP_LOADING_MESSAGE];
    [self loadData:^(id object){
        [self hideLoading];
        
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
    //调整视图基本样式
    self.caseAddress.editable = NO;
    self.caseRemark.editable = NO;
    
    self.goodsTable.scrollEnabled = NO;
    self.servicesTable.scrollEnabled = NO;
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
            NSNumber *goodsAmount = [order.goodsParam objectForKey:@"amount"];
            order.goodsAmount = goodsAmount ? goodsAmount : @0.00;
            
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
            float servicesAmount = 0.00;
            
            for (NSDictionary *servicesDict in order.services) {
                NSNumber *serviceAmount = [servicesDict objectForKey:@"amount"];
                servicesAmount += (serviceAmount ? [serviceAmount floatValue] : 0.00);
                
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
            
            order.servicesAmount = [NSNumber numberWithFloat:servicesAmount];
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
    NSString *totalAmount = order && order.amount ? [NSString stringWithFormat:@"￥%@", order.amount] : @"-";
    self.viewStorage[@"case"] = @{
                                       @"no": intention.orderNo,
                                       @"status": intention.status,
                                       @"statusName": intention.statusName,
                                       @"time": intention.createTime,
                                       @"totalAmount":totalAmount
                                       };
    
    NSString *buyerAddress = [NSString stringWithFormat:@"服务地址：%@", (intention.address ? intention.address : @"-")];
    self.viewStorage[@"info"] = @{
                                       @"userName": intention.userName ? intention.userName: @"-",
                                       @"userMobile": intention.userMobile,
                                       @"buyerName": intention.buyerName ? intention.buyerName : @"-",
                                       @"buyerMobile": intention.buyerMobile ? intention.buyerMobile : @"-",
                                       @"buyerAddress": buyerAddress,
                                       @"remark": intention.remark ? intention.remark : @"-"
                                       };
    
    self.viewStorage[@"goods"] = @{
                                   
                                   @"goodsNumber": [NSNumber numberWithInteger:(order && order.goods ? [order.goods count] : 0)],
                                   
                                   @"goodsAmount": [NSString stringWithFormat:@"￥%.2f", (order && order.goodsAmount ? [order.goodsAmount floatValue] : 0.00)],
                                   
                                   @"goodsList": @{@"goodsItems":({
                                       NSMutableArray *goodsList = [NSMutableArray array];
                                       
                                       if (order && order.goods && [order.goods count] > 0) {
                                           for (GoodsEntity *goods in order.goods) {
                                               [goodsList addObject:@{
                                                                      @"name": goods.name,
                                                                      @"number": [NSString stringWithFormat:@"x%@", goods.number],
                                                                      @"price": [NSString stringWithFormat:@"￥%@", goods.price],
                                                                      @"specName": goods.specName
                                                                      }];
                                           }
                                       } else {
                                           //没有商品
                                           [goodsList addObject:@{
                                                                  @"name": @"没有商品",
                                                                  @"number": @"",
                                                                  @"price": @"",
                                                                  @"specName": @""
                                                                  }];
                                       }
                                       
                                       goodsList;
                                   })}
                                   
                                   };
    
    [self.goodsTable reloadData];
    
    self.viewStorage[@"services"] = @{
                                      
                                    @"servicesAmount": [NSString stringWithFormat:@"￥%.2f", (order && order.servicesAmount ? [order.servicesAmount floatValue] : 0.00)],
                                    
                                    @"servicesList" : @{@"servicesItems": ({
                                        NSMutableArray *servicesList = [NSMutableArray array];
                                        
                                        if (order && order.services && [order.services count] > 0) {
                                            for (ServiceEntity *service in order.services) {
                                                [servicesList addObject:@{
                                                                       @"name": service.typeName,
                                                                       @"price": [NSString stringWithFormat:@"￥%@", service.price]
                                                                       }];
                                            }
                                        } else {
                                            //没有服务
                                            [servicesList addObject:@{
                                                                      @"name": @"没有服务",
                                                                      @"price": @""
                                                                      }];
                                        }
                                        
                                        servicesList;
                                    })}
                                    
                                    };
    
    [self.servicesTable reloadData];
    
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
