//
//  CaseDetailActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/28.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseDetailActivity.h"
#import "CaseEntity.h"
#import "CaseHandler.h"
#import "ServiceEntity.h"
#import "CaseListActivity.h"
#import "CaseEditActivity.h"
#import "GoodsListActivity.h"
#import "ServiceListActivity.h"

@interface CaseDetailActivity ()

@property (nonatomic, strong) UITableView *goodsTable;

@property (nonatomic, strong) UITableView *servicesTable;

@end

@implementation CaseDetailActivity
{
    CaseEntity *intention;
    
    //返回页面是否需要刷新
    BOOL needRefresh;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    
    //弹出时返回，跳转时显示菜单
    if ([self.navigationController.viewControllers count] > 1) {
        isMenuEnabled = NO;
    } else {
        isMenuEnabled = YES;
    }
    
    [super viewDidLoad];
    
    //第一次需要刷新
    needRefresh = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (needRefresh) {
        needRefresh = NO;
        [self loadCase];
    }
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
    self.goodsTable.scrollEnabled = NO;
    self.servicesTable.scrollEnabled = NO;
    
    //调整联系地址和客户留言宽度
    NSString *contentWidth = [NSString stringWithFormat:@"%lfpx", (SCREEN_WIDTH - 60)];
    [self domCss:@"#caseAddress" name:@"width" value:contentWidth];
    [self domCss:@"#caseRemark" name:@"width" value:contentWidth];
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
    NSLog(@"caseId: %@", self.caseId);
    
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.id = self.caseId;
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler queryCase:caseEntity success:^(NSArray *result){
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
    NSString *totalAmount = intention.totalAmount && [intention.totalAmount floatValue] > 0.0 ? [NSString stringWithFormat:@"￥%@", intention.totalAmount] : @"-";
    self.viewStorage[@"case"] = @{
                                       @"no": intention.no,
                                       @"status": intention.status,
                                       @"statusName": intention.statusName,
                                       @"time": intention.createTime,
                                       @"totalAmount":totalAmount
                                       };
    
    NSString *buyerAddress = [NSString stringWithFormat:@"服务地址：%@", (intention.buyerAddress && [intention.buyerAddress length] > 0 ? intention.buyerAddress : @"-")];
    NSString *customerRemark = intention.customerRemark && [intention.customerRemark length] > 0 ? intention.customerRemark : nil;
    if (!customerRemark) customerRemark = (intention.typeName && [intention.typeName length] > 0) ? intention.typeName : nil;
    self.viewStorage[@"info"] = @{
                                       @"userName": intention.userName ? intention.userName: @"-",
                                       @"userMobile": intention.userMobile,
                                       @"buyerName": intention.buyerName ? intention.buyerName : @"-",
                                       @"buyerMobile": intention.buyerMobile ? intention.buyerMobile : @"-",
                                       @"buyerAddress": buyerAddress,
                                       @"remark": customerRemark ? customerRemark: @"-"
                                       };
    
    NSInteger goodsCount = intention.goods ? [intention.goods count] : 0;
    self.viewStorage[@"goods"] = @{
                                   
                                   @"goodsNumber": [NSNumber numberWithInteger:goodsCount],
                                   
                                   @"goodsAmount": [NSString stringWithFormat:@"￥%.2f", (intention.goodsAmount ? [intention.goodsAmount floatValue] : 0.00)],
                                   
                                   @"goodsList": @{@"goodsItems":({
                                       NSMutableArray *goodsList = [NSMutableArray array];
                                       
                                       if (goodsCount > 0) {
                                           for (GoodsEntity *goods in intention.goods) {
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
    
    //自动切换样式并计算高度
    if (goodsCount > 0) {
        [self.goodsTable style_addClass:@"table-goods"];
        [self.goodsTable restyle];
        
        //style_attr不生效，用选择器，下同
        [self domCss:@"#goodsTable" name:@"height" value:[NSString stringWithFormat:@"%ldpx", goodsCount * 50]];
    } else {
        [self.goodsTable style_removeClass:@"table-goods"];
        [self.goodsTable restyle];
        
        //style_attr不生效，用选择器，下同
        [self domCss:@"#goodsTable" name:@"height" value:@"25px"];
    }
    
    [self.goodsTable reloadData];
    
    NSInteger servicesCount = intention.services ? [intention.services count] : 0;
    self.viewStorage[@"services"] = @{
                                      
                                    @"servicesAmount": [NSString stringWithFormat:@"￥%.2f", (intention.servicesAmount ? [intention.servicesAmount floatValue] : 0.00)],
                                    
                                    @"servicesList" : @{@"servicesItems": ({
                                        NSMutableArray *servicesList = [NSMutableArray array];
                                        
                                        if (servicesCount > 0) {
                                            for (ServiceEntity *service in intention.services) {
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
    
    //自动切换样式并计算高度
    if (servicesCount > 0) {
        [self domCss:@"#servicesTable" name:@"height" value:[NSString stringWithFormat:@"%ldpx", servicesCount * 25]];
    } else {
        [self domCss:@"#servicesTable" name:@"height" value:@"25px"];
    }
    
    [self.servicesTable reloadData];
    
    //根据需求状态切换视图显示效果
    [self intentionStatusView];
}

//根据状态切换视图
- (void) intentionStatusView
{
    //切换按钮状态
    if ([CASE_STATUS_NEW isEqualToString:intention.status]) {
        [self domVisible:@"#editCase" visible:NO];
        
        [self domDisplay:@"#caseRemark" display:@"block"];
        [self domDisplay:@"#remarkTitle" display:@"block"];
        
        [self domDisplay:@"#goodsContainer" display:@"none"];
        [self domDisplay:@"#servicesContainer" display:@"none"];
        
        [self domVisible:@"#editGoods" visible:NO];
        [self domVisible:@"#editServices" visible:NO];
        
        [self domDisplay:@"#competeButton" display:@"block"];
        [self domDisplay:@"#startButton" display:@"none"];
        [self domDisplay:@"#finishButton" display:@"none"];
        [self domDisplay:@"#cancelButton" display:@"none"];
        
    } else if ([CASE_STATUS_LOCKED isEqualToString:intention.status]) {
        [self domVisible:@"#editCase" visible:YES];
        
        [self domDisplay:@"#caseRemark" display:@"block"];
        [self domDisplay:@"#remarkTitle" display:@"block"];
        
        [self domDisplay:@"#goodsContainer" display:@"block"];
        [self domDisplay:@"#servicesContainer" display:@"block"];
        
        [self domVisible:@"#editGoods" visible:YES];
        [self domVisible:@"#editServices" visible:YES];
        
        [self domDisplay:@"#competeButton" display:@"none"];
        [self domDisplay:@"#startButton" display:@"block"];
        [self domDisplay:@"#finishButton" display:@"none"];
        [self domDisplay:@"#cancelButton" display:@"block"];
        
    } else if ([CASE_STATUS_CONFIRMED isEqualToString:intention.status]) {
        [self domVisible:@"#editCase" visible:YES];
        
        [self domDisplay:@"#caseRemark" display:@"block"];
        [self domDisplay:@"#remarkTitle" display:@"block"];
        
        [self domDisplay:@"#goodsContainer" display:@"block"];
        [self domDisplay:@"#servicesContainer" display:@"block"];
        
        [self domVisible:@"#editGoods" visible:YES];
        [self domVisible:@"#editServices" visible:YES];
        
        [self domDisplay:@"#competeButton" display:@"none"];
        [self domDisplay:@"#startButton" display:@"none"];
        [self domDisplay:@"#finishButton" display:@"block"];
        [self domDisplay:@"#cancelButton" display:@"block"];
        
    } else if ([CASE_STATUS_TOPAY isEqualToString:intention.status]) {
        [self domVisible:@"#editCase" visible:YES];
        
        [self domDisplay:@"#caseRemark" display:@"none"];
        [self domDisplay:@"#remarkTitle" display:@"none"];
        
        [self domDisplay:@"#goodsContainer" display:@"block"];
        [self domDisplay:@"#servicesContainer" display:@"block"];
        
        [self domVisible:@"#editGoods" visible:NO];
        [self domVisible:@"#editServices" visible:NO];
        
        [self domDisplay:@"#competeButton" display:@"none"];
        [self domDisplay:@"#startButton" display:@"none"];
        [self domDisplay:@"#finishButton" display:@"none"];
        [self domDisplay:@"#cancelButton" display:@"none"];
        
    } else if ([CASE_STATUS_PAYED isEqualToString:intention.status]) {
        [self domVisible:@"#editCase" visible:YES];
        
        [self domDisplay:@"#caseRemark" display:@"none"];
        [self domDisplay:@"#remarkTitle" display:@"none"];
        
        [self domDisplay:@"#goodsContainer" display:@"block"];
        [self domDisplay:@"#servicesContainer" display:@"block"];
        
        [self domVisible:@"#editGoods" visible:NO];
        [self domVisible:@"#editServices" visible:NO];
        
        [self domDisplay:@"#competeButton" display:@"none"];
        [self domDisplay:@"#startButton" display:@"none"];
        [self domDisplay:@"#finishButton" display:@"none"];
        [self domDisplay:@"#cancelButton" display:@"none"];
        
    } else if ([CASE_STATUS_SUCCESS isEqualToString:intention.status]) {
        [self domVisible:@"#editCase" visible:YES];
        
        [self domDisplay:@"#caseRemark" display:@"none"];
        [self domDisplay:@"#remarkTitle" display:@"none"];
        
        [self domDisplay:@"#goodsContainer" display:@"block"];
        [self domDisplay:@"#servicesContainer" display:@"block"];
        
        [self domVisible:@"#editGoods" visible:NO];
        [self domVisible:@"#editServices" visible:NO];
        
        [self domDisplay:@"#competeButton" display:@"none"];
        [self domDisplay:@"#startButton" display:@"none"];
        [self domDisplay:@"#finishButton" display:@"none"];
        [self domDisplay:@"#cancelButton" display:@"none"];
        
    }
    
    //重新布局
    [self relayout];
}

#pragma mark - Action
//抢单
- (void) actionCompeteCase: (SamuraiSignal *)signal
{
    //获取数据
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = self.caseId;
    
    //开始抢单
    [self showLoading:LocalString(@"TIP_CHALLENGE_START")];
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler competeCase:intentionEntity success:^(NSArray *result){
        [self loadingSuccess:LocalString(@"TIP_CHALLENGE_SUCCESS") callback:^{
            //标记列表刷新
            if (self.callbackBlock) {
                self.callbackBlock(@1);
            }
            
            //刷新需求
            [self loadCase];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:LocalString(@"TIP_CHALLENGE_FAIL")];
    }];
}

//取消需求
- (void)actionCancelCase:(SamuraiSignal *)signal
{
    //获取数据
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = self.caseId;
    
    [self showLoading:LocalString(@"TIP_REQUEST_MESSAGE")];
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler giveupCase:intentionEntity success:^(NSArray *result){
        [self loadingSuccess:LocalString(@"TIP_REQUEST_SUCCESS") callback:^{
            //标记列表刷新
            if (self.callbackBlock) {
                self.callbackBlock(@1);
            }
            
            //跳转首页
            CaseListActivity *viewController = [[CaseListActivity alloc] init];
            [self toggleViewController:viewController animated:YES];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

//开始服务
- (void)actionStartCase:(SamuraiSignal *)signal
{
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.id = self.caseId;
    
    NSDictionary *param = @{@"action": CASE_STATUS_CONFIRMED};
    
    [self showLoading:LocalString(@"TIP_REQUEST_MESSAGE")];
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler updateCaseStatus:caseEntity param:param success:^(NSArray *result){
        [self loadingSuccess:LocalString(@"TIP_REQUEST_SUCCESS") callback:^{
            //标记列表刷新
            if (self.callbackBlock) {
                self.callbackBlock(@1);
            }
            
            //刷新需求
            [self loadCase];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

//服务完成
- (void)actionFinishCase:(SamuraiSignal *)signal
{
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.id = self.caseId;
    
    NSDictionary *param = @{@"action": CASE_STATUS_TOPAY};
    
    [self showLoading:LocalString(@"TIP_REQUEST_MESSAGE")];
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler updateCaseStatus:caseEntity param:param success:^(NSArray *result){
        [self loadingSuccess:LocalString(@"TIP_REQUEST_SUCCESS") callback:^{
            //标记列表刷新
            if (self.callbackBlock) {
                self.callbackBlock(@1);
            }
            
            //刷新需求
            [self loadCase];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void)actionEditCase:(SamuraiSignal *)signal
{
    CaseEditActivity *viewController = [[CaseEditActivity alloc] init];
    viewController.caseId = self.caseId;
    [self pushViewController:viewController animated:YES];
}

- (void)actionEditGoods:(SamuraiSignal *)signal
{
    GoodsListActivity *viewController = [[GoodsListActivity alloc] init];
    viewController.caseId = self.caseId;
    [self pushViewController:viewController animated:YES];
}

- (void)actionEditServices:(SamuraiSignal *)signal
{
    ServiceListActivity *viewController = [[ServiceListActivity alloc] init];
    viewController.caseId = self.caseId;
    [self pushViewController:viewController animated:YES];
}

@end
