//
//  CaseEditActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseEditActivity.h"
#import "IntentionEntity.h"
#import "OrderEntity.h"
#import "IntentionHandler.h"
#import "OrderHandler.h"
#import "UITextView+Placeholder.h"

@interface CaseEditActivity ()

@property (nonatomic, strong) UITextView *caseRemark;

@end

@implementation CaseEditActivity
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
    
    [self loadCase];
}

- (NSString *) templateName
{
    return @"caseEdit.html";
}

#pragma mark - View
- (void)onTemplateLoading
{
}

- (void)onTemplateLoaded
{
    //添加备注
    self.caseRemark.placeholder = @"备注";
}

- (void)onTemplateFailed
{
    
}

- (void)onTemplateCancelled
{
    
}

#pragma mark - Data
//加载需求并显示
- (void) loadCase
{
    //加载数据
    [self showLoading:TIP_LOADING_MESSAGE];
    [self loadData:^(id object){
        [self hideLoading];
        
        [self reloadData];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

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
    
    self.viewStorage[@"form"] = @{
                                  @"remark": @""
                                  };
    
    //重新布局
    [self relayout];
}

#pragma mark - Action
- (void) actionSave: (SamuraiSignal *)signal
{
    NSString *remark = self.caseRemark.text;
    if (!remark || [remark length] < 1) {
        [self showError:@"请填写服务单备注哦~亲！"];
        return;
    }
    
    //todo: 保存备注
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
