//
//  CaseEditActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseEditActivity.h"
#import "CaseEntity.h"
#import "CaseHandler.h"
#import "OrderEntity.h"
#import "OrderHandler.h"
#import "UITextView+Placeholder.h"

@interface CaseEditActivity ()

@property (nonatomic, strong) UITextView *caseRemark;

@end

@implementation CaseEditActivity
{
    CaseEntity *intention;
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
    
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = self.caseId;
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler queryCase:intentionEntity success:^(NSArray *result){
        intention = [result firstObject];
        
        NSLog(@"需求数据：%@", [intention toDictionary]);
        
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
                                  @"no": intention.no,
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
