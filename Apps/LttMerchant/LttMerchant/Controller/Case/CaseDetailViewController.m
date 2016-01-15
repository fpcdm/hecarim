//
//  CaseDetailViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/7/28.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "ServiceEntity.h"
#import "CaseListViewController.h"
#import "CaseEditViewController.h"
#import "GoodsListViewController.h"
#import "ServiceListViewController.h"
#import "ConsumeHistoryViewController.h"
#import "CaseErrorView.h"
#import "CaseDetailView.h"

@interface CaseDetailViewController () <UIActionSheetDelegate,CaseDetailViewDelegate>

@end

@implementation CaseDetailViewController
{
    //返回页面是否需要刷新
    BOOL needRefresh;
    
    //返回页面是否需要重新加载
    BOOL needReload;
    
    //支付区域按钮
    UIButton *weixinQrcodeButton;
    UIButton *alipayQrcodeButton;
    UIButton *moneyButton;
    UIView *qrcodeView;
    UIImageView *qrcodeImage;
    UIButton *moneyConfirmButton;
    UIButton *qrcodeChooseButton;
    UIButton *moneyChooseButton;
    
    //支付方式列表
    NSArray *payments;
    
    CaseDetailView *caseDetailView;
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
    
    caseDetailView = [[CaseDetailView alloc] init];
    caseDetailView.delegate = self;
    self.view = caseDetailView;
    self.navigationItem.title = @"服务单详情";
    
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

- (void) reloadCase
{
    //切换控制器
    CaseDetailViewController *activity = [[CaseDetailViewController alloc] init];
    activity.caseId = self.caseId;
    [self refreshViewController:activity animated:NO];
}

#pragma mark - loadError
- (void)loadError:(ErrorEntity *)error
{
    //无权限单独处理
    if (error.code != ERROR_CODE_NOAUTH) {
        [super loadError:error];
    } else {
        self.view = [[CaseErrorView alloc] initWithMessage:@"抢单失败\n下次手快点哦~亲！"];
        
        //标记列表刷新
        if (self.callbackBlock) {
            self.callbackBlock(@1);
        }
    }
}


- (void)setCaseInfo
{
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    //获取订单相关信息
    caseEntity.no = intention.no;
    caseEntity.status = intention.status;
    caseEntity.createTime = intention.createTime;
    caseEntity.totalAmount = intention.totalAmount;
    //订单下单人信息
    caseEntity.userAppellation = intention.userAppellation;
    caseEntity.userName = intention.userName;
    caseEntity.userMobile = intention.userMobile;
    //服务联系人信息
    caseEntity.buyerName = intention.buyerName;
    caseEntity.buyerMobile = intention.buyerMobile;
    caseEntity.buyerAddress = intention.buyerAddress;
    caseEntity.customerRemark = intention.customerRemark;
    caseEntity.typeName = intention.typeName;
    caseEntity.propertyName = intention.propertyName;
    
    [caseDetailView setData:@"intention" value:caseEntity];
}

#pragma mark - reloadData
- (void) reloadData
{
    
    //商品列表
    NSInteger goodsCount = intention.goods ? [intention.goods count] : 0;
    NSDictionary *goodsInfo = [[NSDictionary alloc] init];
    goodsInfo = @{@"goodsNumber" : [NSNumber numberWithInteger:goodsCount],@"goodsAmount" : [NSString stringWithFormat:@"￥%.2f", (intention.goodsAmount ? [intention.goodsAmount floatValue] : 0.00)]};
                                   
   NSMutableArray *goodsList = [[NSMutableArray alloc] init];
   
   if (goodsCount > 0) {
       for (GoodsEntity *goods in intention.goods) {
           [goodsList addObject:@{
                                  @"name": goods.name,
                                  @"number": [NSString stringWithFormat:@"x%@", goods.number],
                                  @"price": [NSString stringWithFormat:@"￥%@", goods.price],
                                  @"specName": goods.specName,
                                  @"height" : @50,
                                  @"type" : @"type"
                                  }];
       }
   } else {
       [goodsList addObject:@{
                              @"name": @"没有商品",
                              @"number": @"",
                              @"price": @"",
                              @"specName": @"",
                              @"height" : @25,
                              @"type" : @""
                              }];
   }
    
    [caseDetailView setData:@"goodsInfo" value:goodsInfo];
    [caseDetailView setData:@"goodsList" value:goodsList];
    
    
    //服务列表
    NSInteger servicesCount = intention.services ? [intention.services count] : 0;
    NSDictionary *servicesInfo = [[NSDictionary alloc] init];
    servicesInfo = @{@"servicesAmount" : [NSString stringWithFormat:@"￥%.2f", (intention.servicesAmount ? [intention.servicesAmount floatValue] : 0.00)]};
    
    NSMutableArray *servicesList = [NSMutableArray array];
    if (servicesCount > 0) {
        for (ServiceEntity *service in intention.services) {
            [servicesList addObject:@{
                                   @"name": service.name ? service.name : @"",
                                   @"price": [NSString stringWithFormat:@"￥%@", service.price]
                                   }];
        }
    } else {
        [servicesList addObject:@{
                                  @"name": @"没有服务",
                                  @"price": @""
                                  }];
    }
    
    [caseDetailView setData:@"servicesInfo" value:servicesInfo];
    [caseDetailView setData:@"servicesList" value:servicesList];
    
    
    //获取服务单信息
    [self setCaseInfo];
    
    //加载支付
    if ([CASE_STATUS_TOPAY isEqualToString:intention.status]) {
        [self loadPaymentView];
        [self showRefresh];
    }else{
        [caseDetailView renderData];
    }
}


//加载支付列表，显示视图
- (void)loadPaymentView
{
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    NSDictionary *param = @{@"is_online": @"no"};
    [caseHandler queryPayments:param success:^(NSArray *result) {
        [self hideLoading];
        payments = result;
        [caseDetailView setData:@"payments" value:payments];
        [caseDetailView renderData];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

//显示刷新按钮
- (void)showRefresh
{
    //刷新按钮
    UIBarButtonItem *refreshButton = [AppUIUtil makeBarButtonItem:@"刷新" highlighted:isIndexNavBar];
    refreshButton.target = self;
    refreshButton.action = @selector(refreshCaseStatus);
    self.navigationItem.rightBarButtonItem = refreshButton;
    
}

//刷新需求，有加载效果
- (void) refreshCaseStatus
{
    [self showLoading:[LocaleUtil system:@"Refresh.Start"]];
    
    //需求当前状态
    NSString *oldStatus = intention ? intention.status : nil;
    
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = self.caseId;
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler queryCase:intentionEntity success:^(NSArray *result){
        CaseEntity *resultIntention = [result firstObject];
        [self loadingSuccess:[LocaleUtil system:@"Refresh.Suceess"] callback:^{
            //检测需求状态是否变化
            if (![resultIntention.status isEqualToString:oldStatus]) {
                //标记列表刷新
                if (self.callbackBlock) {
                    self.callbackBlock(@1);
                }
                
                [self reloadCase];
            }
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

#pragma mark - Action
//联系下单人
- (void)actionContactUser
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", intention.userMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

//联系服务联系人
- (void)actionContactBuyer
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", intention.buyerMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

//消费记录
- (void)actionConsumeHistory
{
    ConsumeHistoryViewController *viewController = [[ConsumeHistoryViewController alloc] init];
    viewController.intention = intention;
    [self pushViewController:viewController animated:YES];
}

//抢单
- (void) actionCompeteCase
{
    //获取数据
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = self.caseId;
    
    //开始抢单
    [self showLoading:[LocaleUtil info:@"Challenge.Start"]];
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler competeCase:intentionEntity success:^(NSArray *result){
        [self loadingSuccess:[LocaleUtil info:@"Challenge.Suceess"] callback:^{
            //标记列表刷新
            if (self.callbackBlock) {
                self.callbackBlock(@1);
            }
            
            [self reloadCase];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:[LocaleUtil info:@"Challenge.Fail"]];
    }];
}

//取消需求
- (void)actionCancelCase
{
    //获取数据
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = self.caseId;
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler giveupCase:intentionEntity success:^(NSArray *result){
        [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
            //标记列表刷新
            if (self.callbackBlock) {
                self.callbackBlock(@1);
            }
            //跳转首页
            CaseListViewController *viewController = [[CaseListViewController alloc] init];
            [self toggleViewController:viewController animated:YES];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

//开始服务
- (void)actionStartCase
{
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.id = self.caseId;
    
    NSDictionary *param = @{@"action": CASE_STATUS_CONFIRMED};
    
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler updateCaseStatus:caseEntity param:param success:^(NSArray *result){
        [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
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
- (void)actionFinishCase
{
    //至少添加一个商品和服务
    NSInteger goodsCount = intention.goods ? [intention.goods count] : 0;
    NSInteger servicesCount = intention.services ? [intention.services count] : 0;
    if (goodsCount < 1 && servicesCount < 1) {
        [self showError:[LocaleUtil error:@"GoodsOrServices.Required"]];
        return;
    }
    
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.id = self.caseId;
    
    NSDictionary *param = @{@"action": CASE_STATUS_TOPAY};
    
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler updateCaseStatus:caseEntity param:param success:^(NSArray *result){
        [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
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

//编辑基本信息
- (void)actionEditCase
{
    CaseEditViewController *viewController = [[CaseEditViewController alloc] init];
    viewController.caseId = self.caseId;
    [self pushViewController:viewController animated:YES];
}

//编辑商品
- (void)actionEditGoods
{
    GoodsListViewController *viewController = [[GoodsListViewController alloc] init];
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

//编辑服务
- (void)actionEditServices
{
    ServiceListViewController *viewController = [[ServiceListViewController alloc] init];
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

//修改支付方式公用方法
- (void)actionUpdatePayment:(NSString *)payment success:(CallbackBlock)success
{
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.id = self.caseId;
    
    NSDictionary *param = @{@"pay_way": payment};
    
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler updateCasePayment:caseEntity param:param success:^(NSArray *result){
        [self hideLoading];
        
        success(result);
    } failure:^(ErrorEntity *error){
        //是否已经支付
        if (error.code == 1100) {
            [self showSuccess:[LocaleUtil info:@"Case.Finished"] callback:^{
                //标记列表刷新
                if (self.callbackBlock) {
                    self.callbackBlock(@1);
                }
                
                [self reloadCase];
            }];
        } else {
            [self showError:error.message];
        }
    }];
}

//微信扫码支付
- (void)actionWeixinQrcode
{
    [self actionUpdatePayment:PAY_WAY_WEIXIN success:^(id object) {
        self.navigationItem.title = @"微信扫码支付";
        [caseDetailView showImage];
        caseDetailView.img.image = nil;
        //微信二维码
        [intention qrcodeImageView:caseDetailView.img way:PAY_WAY_WEIXIN failure:^{
            [self showError:[LocaleUtil error:@"Qrcode.Failed"]];
        }];
    }];
}

//支付宝扫码支付
- (void)actionAlipayQrcode
{
    [self actionUpdatePayment:PAY_WAY_ALIPAY success:^(id object) {
        self.navigationItem.title = @"支付宝扫码支付";
        [caseDetailView showImage];
        caseDetailView.img.image = nil;
        //支付宝二维码
        [intention qrcodeImageView:caseDetailView.img way:PAY_WAY_ALIPAY failure:^{
            [self showError:[LocaleUtil error:@"Qrcode.Failed"]];
        }];
    }];
}

//现金支付
- (void)actionUseMoney
{
    [self actionUpdatePayment:PAY_WAY_CASH success:^(id object) {
        caseDetailView.img.image = nil;
        self.navigationItem.title = @"现金支付";
    }];
}

//重新选择支付方式
- (void)actionChooseMethod
{
    caseDetailView.img.image = nil;
    self.navigationItem.title = @"服务单详情";
}

//确认现金支付
- (void)actionConfirmPayed
{
    UIActionSheet *sheet = [UIActionSheet alloc];
    
    sheet = [sheet initWithTitle:@"你确认已经收到用户现金，支付成功了吗？" delegate:self cancelButtonTitle: @"未收款" destructiveButtonTitle:@"已收款" otherButtonTitles:nil];
    
    sheet.tag = 1;
    [sheet showInView:self.view];
}

//弹出sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag != 1) return;
    
    switch (buttonIndex) {
        //确定
        case 0:
        {
            CaseEntity *caseEntity = [[CaseEntity alloc] init];
            caseEntity.id = self.caseId;
            
            [self showLoading:[LocaleUtil system:@"Request.Start"]];
            
            //调用接口
            CaseHandler *caseHandler = [[CaseHandler alloc] init];
            [caseHandler payWithCash:caseEntity param:nil success:^(NSArray *result) {
                [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
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
            break;
        //取消
        default:
            break;
    }
}

@end
