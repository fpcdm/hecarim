//
//  CaseDetailActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/28.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseDetailActivity.h"
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
    //返回页面是否需要刷新
    BOOL needRefresh;
    
    //返回页面是否需要重新加载
    BOOL needReload;
}

@synthesize intention;

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
    needReload = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //是否需要重载，优先级高于refresh
    if (needReload) {
        needReload = NO;
        [self reloadCase];
    } else if (needRefresh) {
        needRefresh = NO;
        [self loadCase];
    }
}

- (NSString *) templateName
{
    return @"caseDetail.html";
}

- (void) reloadCase
{
    //切换控制器
    CaseDetailActivity *activity = [[CaseDetailActivity alloc] init];
    activity.caseId = self.caseId;
    [self refreshViewController:activity animated:NO];
}

#pragma mark - View
- (void)onTemplateLoaded
{
    //调整视图基本样式
    UITableView *tableGoods = (UITableView *) $(@"#goodsTable").firstView;
    tableGoods.scrollEnabled = NO;
    UITableView *tableServices = (UITableView *) $(@"#servicesTable").firstView;
    tableServices.scrollEnabled = NO;
    
    //调整联系地址和客户留言宽度
    NSString *contentWidth = [NSString stringWithFormat:@"%lfpx", (SCREEN_WIDTH - 60)];
    $(@"#caseAddress").ATTR(@"width", contentWidth);
    $(@"#caseRemark").ATTR(@"width", contentWidth);
}

#pragma mark - reloadData
- (void) reloadData
{
    [super reloadData];
    
    NSString *buyerAddress = [NSString stringWithFormat:@"服务地址：%@", (intention.buyerAddress && [intention.buyerAddress length] > 0 ? intention.buyerAddress : @"-")];
    NSString *customerRemark = intention.customerRemark && [intention.customerRemark length] > 0 ? intention.customerRemark : nil;
    if (!customerRemark) customerRemark = (intention.typeName && [intention.typeName length] > 0) ? intention.typeName : nil;
    self.scope[@"info"] = @{
                                       @"userName": intention.userName ? intention.userName: @"-",
                                       @"userMobile": intention.userMobile,
                                       @"buyerName": intention.buyerName ? intention.buyerName : @"-",
                                       @"buyerMobile": intention.buyerMobile ? intention.buyerMobile : @"-",
                                       @"buyerAddress": buyerAddress,
                                       @"remark": customerRemark ? customerRemark: @"-"
                                       };
    
    NSInteger goodsCount = intention.goods ? [intention.goods count] : 0;
    self.scope[@"goods"] = @{
                                   
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
        $(@"#goodsTable").ATTR(@"height", [NSString stringWithFormat:@"%ldpx", goodsCount * 50]);
    } else {
        $(@"#goodsTable").ATTR(@"height", @"25px");
    }
    
    [self.goodsTable reloadData];
    
    NSInteger servicesCount = intention.services ? [intention.services count] : 0;
    self.scope[@"services"] = @{
                                      
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
        $(@"#servicesTable").ATTR(@"height", [NSString stringWithFormat:@"%ldpx", servicesCount * 25]);
    } else {
        $(@"#servicesTable").ATTR(@"height", @"25px");
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
        $(@"#editCase").ATTR(@"visibility", @"hidden");
        
        $(@"#caseRemark").ATTR(@"display", @"block");
        $(@"#remarkTitle").ATTR(@"display", @"block");
        
        $(@"#goodsContainer").ATTR(@"display", @"none");
        $(@"#servicesContainer").ATTR(@"display", @"none");
        
        $(@"#editGoods").ATTR(@"visibility", @"hidden");
        $(@"#editServices").ATTR(@"visibility", @"hidden");
        
        $(@"#competeButton").ATTR(@"display", @"block");
        $(@"#startButton").ATTR(@"display", @"none");
        $(@"#finishButton").ATTR(@"display", @"none");
        $(@"#cancelButton").ATTR(@"display", @"none");
        
    } else if ([CASE_STATUS_LOCKED isEqualToString:intention.status]) {
        $(@"#editCase").ATTR(@"visibility", @"visible");
        
        $(@"#caseRemark").ATTR(@"display", @"block");
        $(@"#remarkTitle").ATTR(@"display", @"block");
        
        $(@"#goodsContainer").ATTR(@"display", @"block");
        $(@"#servicesContainer").ATTR(@"display", @"block");
        
        $(@"#editGoods").ATTR(@"visibility", @"visible");
        $(@"#editServices").ATTR(@"visibility", @"visible");
        
        $(@"#competeButton").ATTR(@"display", @"none");
        $(@"#startButton").ATTR(@"display", @"block");
        $(@"#finishButton").ATTR(@"display", @"none");
        $(@"#cancelButton").ATTR(@"display", @"block");
        
    } else if ([CASE_STATUS_CONFIRMED isEqualToString:intention.status]) {
        $(@"#editCase").ATTR(@"visibility", @"visible");
        
        $(@"#caseRemark").ATTR(@"display", @"block");
        $(@"#remarkTitle").ATTR(@"display", @"block");
        
        $(@"#goodsContainer").ATTR(@"display", @"block");
        $(@"#servicesContainer").ATTR(@"display", @"block");
        
        $(@"#editGoods").ATTR(@"visibility", @"visible");
        $(@"#editServices").ATTR(@"visibility", @"visible");
        
        $(@"#competeButton").ATTR(@"display", @"none");
        $(@"#startButton").ATTR(@"display", @"none");
        $(@"#finishButton").ATTR(@"display", @"block");
        $(@"#cancelButton").ATTR(@"display", @"block");
        
    } else if ([CASE_STATUS_TOPAY isEqualToString:intention.status]) {
        $(@"#editCase").ATTR(@"visibility", @"visible");
        
        $(@"#caseRemark").ATTR(@"display", @"none");
        $(@"#remarkTitle").ATTR(@"display", @"none");
        UIView *remarkView = $(@"#remarkTitle").firstView;
        if (remarkView) [remarkView removeFromSuperview];
        
        $(@"#goodsContainer").ATTR(@"display", @"block");
        $(@"#servicesContainer").ATTR(@"display", @"block");
        
        $(@"#editGoods").ATTR(@"visibility", @"hidden");
        $(@"#editServices").ATTR(@"visibility", @"hidden");
        
        $(@"#competeButton").ATTR(@"display", @"none");
        $(@"#startButton").ATTR(@"display", @"none");
        $(@"#finishButton").ATTR(@"display", @"none");
        $(@"#cancelButton").ATTR(@"display", @"none");
        
    } else if ([CASE_STATUS_PAYED isEqualToString:intention.status]) {
        $(@"#editCase").ATTR(@"visibility", @"visible");
        
        $(@"#caseRemark").ATTR(@"display", @"none");
        $(@"#remarkTitle").ATTR(@"display", @"none");
        UIView *remarkView = $(@"#remarkTitle").firstView;
        if (remarkView) [remarkView removeFromSuperview];
        
        $(@"#goodsContainer").ATTR(@"display", @"block");
        $(@"#servicesContainer").ATTR(@"display", @"block");
        
        $(@"#editGoods").ATTR(@"visibility", @"hidden");
        $(@"#editServices").ATTR(@"visibility", @"hidden");
        
        $(@"#competeButton").ATTR(@"display", @"none");
        $(@"#startButton").ATTR(@"display", @"none");
        $(@"#finishButton").ATTR(@"display", @"none");
        $(@"#cancelButton").ATTR(@"display", @"none");
        
    } else if ([CASE_STATUS_SUCCESS isEqualToString:intention.status]) {
        $(@"#editCase").ATTR(@"visibility", @"visible");
        
        $(@"#caseRemark").ATTR(@"display", @"none");
        $(@"#remarkTitle").ATTR(@"display", @"none");
        UIView *remarkView = $(@"#remarkTitle").firstView;
        if (remarkView) [remarkView removeFromSuperview];
        
        $(@"#goodsContainer").ATTR(@"display", @"block");
        $(@"#servicesContainer").ATTR(@"display", @"block");
        
        $(@"#editGoods").ATTR(@"visibility", @"hidden");
        $(@"#editServices").ATTR(@"visibility", @"hidden");
        
        $(@"#competeButton").ATTR(@"display", @"none");
        $(@"#startButton").ATTR(@"display", @"none");
        $(@"#finishButton").ATTR(@"display", @"none");
        $(@"#cancelButton").ATTR(@"display", @"none");
        
    }
    
    //重新布局
    [self relayout];
}

#pragma mark - Action
//联系下单人
- (void)actionContactUser:(SamuraiSignal *)signal
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", intention.userMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

//联系服务联系人
- (void)actionContactBuyer:(SamuraiSignal *)signal
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", intention.buyerMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

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
            
            [self reloadCase];
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
            
            [self reloadCase];
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
            
            [self reloadCase];
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
    viewController.callbackBlock = ^(id object){
        //标记可重载
        if (object && [@2 isEqualToNumber:object]) {
            needReload = YES;
            //标记可刷新
        } else if (object && [@1 isEqualToNumber:object]) {
            needRefresh = YES;
        }
    };
    [self pushViewController:viewController animated:YES];
}

- (void)actionEditServices:(SamuraiSignal *)signal
{
    ServiceListActivity *viewController = [[ServiceListActivity alloc] init];
    viewController.caseId = self.caseId;
    viewController.callbackBlock = ^(id object){
        //标记可重载
        if (object && [@2 isEqualToNumber:object]) {
            needReload = YES;
        //标记可刷新
        } else if (object && [@1 isEqualToNumber:object]) {
            needRefresh = YES;
        }
    };
    [self pushViewController:viewController animated:YES];
}

@end
