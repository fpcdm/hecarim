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
#import "ConsumeHistoryActivity.h"
#import "CaseErrorView.h"

@interface CaseDetailActivity () <UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *consumeTable;

@property (nonatomic, strong) UITableView *goodsTable;

@property (nonatomic, strong) UITableView *servicesTable;

@end

@implementation CaseDetailActivity
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

#pragma mark - View
- (void)onTemplateLoaded
{
    //调整视图基本样式
    UITableView *tableConsume = (UITableView *) $(@"#consumeTable").firstView;
    tableConsume.scrollEnabled = NO;
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
    
    NSString *buyerAddress = [NSString stringWithFormat:@"服务地址: %@", (intention.buyerAddress && [intention.buyerAddress length] > 0 ? intention.buyerAddress : @"-")];
    NSString *customerRemark = [NSString stringWithFormat:@"%@ (%@%@)",
                                intention.customerRemark ? intention.customerRemark : @"",
                                intention.typeName ? intention.typeName : @"",
                                intention.propertyName && [intention.propertyName length] > 0 ? [NSString stringWithFormat:@"-%@", intention.propertyName] : @""
                                ];
    self.scope[@"info"] = @{
                                       @"userName": intention.userName ? intention.userName: @"-",
                                       @"userAppellation": intention.userAppellation ? intention.userAppellation : @"-",
                                       @"userMobile": intention.userMobile,
                                       @"buyerName": intention.buyerName ? intention.buyerName : @"-",
                                       @"buyerMobile": intention.buyerMobile ? intention.buyerMobile : @"-",
                                       @"buyerAddress": buyerAddress,
                                       @"remark": customerRemark ? customerRemark: @"-"
                                       };
    
    self.scope[@"consume"] = @{@"consumeList": @{@"consumeItems":@[@{
                                                                       @"accessoryType": @(UITableViewCellAccessoryDisclosureIndicator)
                                                                       }]}};
    
    [self.consumeTable reloadData];
    
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
        
        $(@"#consumeContainer").ATTR(@"display", @"block");
        $(@"#goodsContainer").ATTR(@"display", @"none");
        $(@"#servicesContainer").ATTR(@"display", @"none");
        
        $(@"#editGoods").ATTR(@"visibility", @"hidden");
        $(@"#editServices").ATTR(@"visibility", @"hidden");
        
        $(@"#payContainer").ATTR(@"display", @"none");
        
        $(@"#competeButton").ATTR(@"display", @"block");
        $(@"#startButton").ATTR(@"display", @"none");
        $(@"#finishButton").ATTR(@"display", @"none");
        $(@"#cancelButton").ATTR(@"display", @"none");
        
    } else if ([CASE_STATUS_LOCKED isEqualToString:intention.status]) {
        $(@"#editCase").ATTR(@"visibility", @"hidden");
        
        $(@"#caseRemark").ATTR(@"display", @"block");
        $(@"#remarkTitle").ATTR(@"display", @"block");
        
        $(@"#consumeContainer").ATTR(@"display", @"block");
        $(@"#goodsContainer").ATTR(@"display", @"block");
        $(@"#servicesContainer").ATTR(@"display", @"block");
        
        $(@"#editGoods").ATTR(@"visibility", @"visible");
        $(@"#editServices").ATTR(@"visibility", @"visible");
        
        $(@"#payContainer").ATTR(@"display", @"none");
        
        $(@"#competeButton").ATTR(@"display", @"none");
        $(@"#startButton").ATTR(@"display", @"block");
        $(@"#finishButton").ATTR(@"display", @"none");
        $(@"#cancelButton").ATTR(@"display", @"block");
        
    } else if ([CASE_STATUS_CONFIRMED isEqualToString:intention.status]) {
        $(@"#editCase").ATTR(@"visibility", @"hidden");
        
        $(@"#caseRemark").ATTR(@"display", @"block");
        $(@"#remarkTitle").ATTR(@"display", @"block");
        
        $(@"#consumeContainer").ATTR(@"display", @"none");
        $(@"#goodsContainer").ATTR(@"display", @"block");
        $(@"#servicesContainer").ATTR(@"display", @"block");
        
        $(@"#editGoods").ATTR(@"visibility", @"visible");
        $(@"#editServices").ATTR(@"visibility", @"visible");
        
        $(@"#payContainer").ATTR(@"display", @"none");
        
        $(@"#competeButton").ATTR(@"display", @"none");
        $(@"#startButton").ATTR(@"display", @"none");
        $(@"#finishButton").ATTR(@"display", @"block");
        $(@"#cancelButton").ATTR(@"display", @"block");
        
    } else if ([CASE_STATUS_TOPAY isEqualToString:intention.status]) {
        $(@"#editCase").ATTR(@"visibility", @"hidden");
        
        $(@"#caseRemark").ATTR(@"display", @"none");
        $(@"#remarkTitle").ATTR(@"display", @"none");
        UIView *remarkView = $(@"#remarkTitle").firstView;
        if (remarkView) [remarkView removeFromSuperview];
        
        $(@"#consumeContainer").ATTR(@"display", @"none");
        $(@"#goodsContainer").ATTR(@"display", @"none");
        $(@"#servicesContainer").ATTR(@"display", @"none");
        
        $(@"#editGoods").ATTR(@"visibility", @"hidden");
        $(@"#editServices").ATTR(@"visibility", @"hidden");
        
        $(@"#payContainer").ATTR(@"display", @"block");
        
        $(@"#competeButton").ATTR(@"display", @"none");
        $(@"#startButton").ATTR(@"display", @"none");
        $(@"#finishButton").ATTR(@"display", @"none");
        $(@"#cancelButton").ATTR(@"display", @"none");
        
        //切换到选择支付方式
        [self loadPaymentView];
        
    } else if ([CASE_STATUS_PAYED isEqualToString:intention.status]) {
        $(@"#editCase").ATTR(@"visibility", @"hidden");
        
        $(@"#caseRemark").ATTR(@"display", @"none");
        $(@"#remarkTitle").ATTR(@"display", @"none");
        UIView *remarkView = $(@"#remarkTitle").firstView;
        if (remarkView) [remarkView removeFromSuperview];
        
        $(@"#consumeContainer").ATTR(@"display", @"none");
        $(@"#goodsContainer").ATTR(@"display", @"block");
        $(@"#servicesContainer").ATTR(@"display", @"block");
        
        $(@"#editGoods").ATTR(@"visibility", @"hidden");
        $(@"#editServices").ATTR(@"visibility", @"hidden");
        
        $(@"#payContainer").ATTR(@"display", @"none");
        
        $(@"#competeButton").ATTR(@"display", @"none");
        $(@"#startButton").ATTR(@"display", @"none");
        $(@"#finishButton").ATTR(@"display", @"none");
        $(@"#cancelButton").ATTR(@"display", @"none");
        
    } else if ([CASE_STATUS_SUCCESS isEqualToString:intention.status]) {
        $(@"#editCase").ATTR(@"visibility", @"hidden");
        
        $(@"#caseRemark").ATTR(@"display", @"none");
        $(@"#remarkTitle").ATTR(@"display", @"none");
        UIView *remarkView = $(@"#remarkTitle").firstView;
        if (remarkView) [remarkView removeFromSuperview];
        
        $(@"#consumeContainer").ATTR(@"display", @"none");
        $(@"#goodsContainer").ATTR(@"display", @"block");
        $(@"#servicesContainer").ATTR(@"display", @"block");
        
        $(@"#editGoods").ATTR(@"visibility", @"hidden");
        $(@"#editServices").ATTR(@"visibility", @"hidden");
        
        $(@"#payContainer").ATTR(@"display", @"none");
        
        $(@"#competeButton").ATTR(@"display", @"none");
        $(@"#startButton").ATTR(@"display", @"none");
        $(@"#finishButton").ATTR(@"display", @"none");
        $(@"#cancelButton").ATTR(@"display", @"none");
        
    }
    
    //重新布局
    [self relayout];
}

//加载支付列表，显示视图
- (void)loadPaymentView
{
    [self showLoading:LocalString(@"TIP_REQUEST_MESSAGE")];
    
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    NSDictionary *param = @{@"is_online": @"no"};
    [caseHandler queryPayments:param success:^(NSArray *result) {
        [self hideLoading];
        
        payments = result;
        [self paymentView];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

//显示支付方式视图
- (void)paymentView
{
    UIView *payContainer = $(@"#payContainer").firstView;
    UIView *superview = payContainer;
    UIView *separatorView = nil;
    
    //循环输出支付方式
    for (ResultEntity* payment in payments) {
        //当前支付按钮
        UIView *paymentButton = nil;
        
        //判断支付方式
        if ([PAY_WAY_WEIXIN isEqualToString:payment.data]) {
            //微信扫码支付
            weixinQrcodeButton = [self makeButton:@{
                                                    @"icon": @"methodWeixinQrcode",
                                                    @"text": @"微信扫码"
                                                    }];
            [weixinQrcodeButton addTarget:self action:@selector(actionWeixinQrcode) forControlEvents:UIControlEventTouchUpInside];
            [payContainer addSubview:weixinQrcodeButton];
            
            paymentButton = weixinQrcodeButton;
        } else if ([PAY_WAY_ALIPAY isEqualToString:payment.data]) {
            //支付宝扫码支付
            alipayQrcodeButton = [self makeButton:@{
                                                    @"icon": @"methodAlipayQrcode",
                                                    @"text": @"支付宝扫码"
                                                    }];
            [alipayQrcodeButton addTarget:self action:@selector(actionAlipayQrcode) forControlEvents:UIControlEventTouchUpInside];
            [payContainer addSubview:alipayQrcodeButton];
            
            paymentButton = alipayQrcodeButton;
        } else if ([PAY_WAY_CASH isEqualToString:payment.data]) {
            //现金支付
            moneyButton = [self makeButton:@{
                                             @"icon": @"methodMoney",
                                             @"text": @"现金支付"
                                             }];
            [moneyButton addTarget:self action:@selector(actionUseMoney) forControlEvents:UIControlEventTouchUpInside];
            [payContainer addSubview:moneyButton];
            
            paymentButton = moneyButton;
        }
        
        //按钮输出
        if (paymentButton) {
            [paymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
                if (separatorView) {
                    make.top.equalTo(separatorView.mas_bottom).offset(10);
                } else {
                    make.top.equalTo(superview.mas_top);
                }
                make.left.equalTo(superview.mas_left);
                make.right.equalTo(superview.mas_right);
                make.height.equalTo(@60);
            }];
            
            separatorView = paymentButton;
        }
    }
    
    //二维码视图
    qrcodeView = [[UIView alloc] init];
    qrcodeView.backgroundColor = COLOR_MAIN_WHITE;
    qrcodeView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    qrcodeView.layer.borderWidth = 0.5f;
    qrcodeView.hidden = YES;
    [payContainer addSubview:qrcodeView];
    
    [qrcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@170);
    }];
    
    qrcodeImage = [[UIImageView alloc] init];
    [qrcodeView addSubview:qrcodeImage];
    
    [qrcodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrcodeView.mas_top).offset(10);
        make.centerX.equalTo(qrcodeView.mas_centerX);
        make.height.equalTo(@150);
        make.width.equalTo(@150);
    }];
    
    //二维码重新选择按钮
    qrcodeChooseButton = [AppUIUtil makeButton:@"选择其它支付方式"];
    qrcodeChooseButton.backgroundColor = COLOR_MAIN_WHITE;
    qrcodeChooseButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    qrcodeChooseButton.layer.borderWidth = 0.5f;
    qrcodeChooseButton.hidden = YES;
    [qrcodeChooseButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [qrcodeChooseButton addTarget:self action:@selector(actionChooseMethod) forControlEvents:UIControlEventTouchUpInside];
    [payContainer addSubview:qrcodeChooseButton];
    
    [qrcodeChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qrcodeView.mas_bottom).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
    
    //确认现金支付按钮
    moneyConfirmButton = [AppUIUtil makeButton:@"确认用户已付款完成支付"];
    moneyConfirmButton.hidden = YES;
    [moneyConfirmButton addTarget:self action:@selector(actionConfirmPayed) forControlEvents:UIControlEventTouchUpInside];
    [payContainer addSubview:moneyConfirmButton];
    
    [moneyConfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
    
    //现金支付重新选择按钮
    moneyChooseButton = [AppUIUtil makeButton:@"选择其它支付方式"];
    moneyChooseButton.backgroundColor = COLOR_MAIN_WHITE;
    moneyChooseButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    moneyChooseButton.layer.borderWidth = 0.5f;
    moneyChooseButton.hidden = YES;
    [moneyChooseButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
    [moneyChooseButton addTarget:self action:@selector(actionChooseMethod) forControlEvents:UIControlEventTouchUpInside];
    [payContainer addSubview:moneyChooseButton];
    
    [moneyChooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyConfirmButton.mas_bottom).offset(20);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
}

- (UIButton *)makeButton:(NSDictionary *)param
{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = COLOR_MAIN_WHITE;
    button.layer.borderColor = CGCOLOR_MAIN_BORDER;
    button.layer.borderWidth = 0.5f;
    
    //图标
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:[param objectForKey:@"icon"]];
    [button addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_top).offset(10);
        make.left.equalTo(button.mas_left).offset(10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    //文字
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = [param objectForKey:@"text"];
    textLabel.font = FONT_MAIN_BOLD;
    textLabel.textColor = COLOR_MAIN_BLACK;
    [button addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button.mas_centerY);
        make.left.equalTo(imageView.mas_right).offset(10);
        make.height.equalTo(@20);
    }];
    
    //箭头
    UIImageView *chooseView = [[UIImageView alloc] init];
    chooseView.image = [UIImage imageNamed:@"chooseMethod"];
    [button addSubview:chooseView];
    
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(button.mas_centerY);
        make.right.equalTo(button.mas_right).offset(-10);
        make.width.equalTo(@10);
        make.height.equalTo(@20);
    }];
    
    return button;
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

//消费记录
- (void)actionConsumeHistory:(SamuraiSignal *)signal
{
    ConsumeHistoryActivity *viewController = [[ConsumeHistoryActivity alloc] init];
    viewController.intention = intention;
    [self pushViewController:viewController animated:YES];
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
    //至少添加一个商品和服务
    NSInteger goodsCount = intention.goods ? [intention.goods count] : 0;
    NSInteger servicesCount = intention.services ? [intention.services count] : 0;
    if (goodsCount < 1 && servicesCount < 1) {
        [self showError:@"请至少添加一个商品或服务"];
        return;
    }
    
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

//编辑基本信息
- (void)actionEditCase:(SamuraiSignal *)signal
{
    CaseEditActivity *viewController = [[CaseEditActivity alloc] init];
    viewController.caseId = self.caseId;
    [self pushViewController:viewController animated:YES];
}

//编辑商品
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

//编辑服务
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

//修改支付方式公用方法
- (void)actionUpdatePayment:(NSString *)payment success:(CallbackBlock)success
{
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.id = self.caseId;
    
    NSDictionary *param = @{@"pay_way": PAY_WAY_WEIXIN};
    
    [self showLoading:LocalString(@"TIP_REQUEST_MESSAGE")];
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler updateCasePayment:caseEntity param:param success:^(NSArray *result){
        [self hideLoading];
        
        success(result);
    } failure:^(ErrorEntity *error){
        //是否已经支付
        if (error.code == 1100) {
            [self showSuccess:@"该服务单已经支付完成了哦~亲！" callback:^{
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
        if (weixinQrcodeButton) weixinQrcodeButton.hidden = YES;
        if (alipayQrcodeButton) alipayQrcodeButton.hidden = YES;
        if (moneyButton) moneyButton.hidden = YES;
        
        qrcodeView.hidden = NO;
        qrcodeChooseButton.hidden = NO;
        moneyConfirmButton.hidden = YES;
        moneyChooseButton.hidden = YES;
        
        //微信二维码
        [intention qrcodeImageView:qrcodeImage way:PAY_WAY_WEIXIN failure:^{
            [self showError:@"二维码生成失败，请重试！"];
        }];
    }];
}

//支付宝扫码支付
- (void)actionAlipayQrcode
{
    [self actionUpdatePayment:PAY_WAY_ALIPAY success:^(id object) {
        if (weixinQrcodeButton) weixinQrcodeButton.hidden = YES;
        if (alipayQrcodeButton) alipayQrcodeButton.hidden = YES;
        if (moneyButton) moneyButton.hidden = YES;
        
        qrcodeView.hidden = NO;
        qrcodeChooseButton.hidden = NO;
        moneyConfirmButton.hidden = YES;
        moneyChooseButton.hidden = YES;
        
        //支付宝二维码
        [intention qrcodeImageView:qrcodeImage way:PAY_WAY_ALIPAY failure:^{
            [self showError:@"二维码生成失败，请重试！"];
        }];
    }];
}

//现金支付
- (void)actionUseMoney
{
    [self actionUpdatePayment:PAY_WAY_CASH success:^(id object) {
        if (weixinQrcodeButton) weixinQrcodeButton.hidden = YES;
        if (alipayQrcodeButton) alipayQrcodeButton.hidden = YES;
        if (moneyButton) moneyButton.hidden = YES;
        
        qrcodeView.hidden = YES;
        qrcodeChooseButton.hidden = YES;
        moneyConfirmButton.hidden = NO;
        moneyChooseButton.hidden = NO;
        
        //清除二维码
        qrcodeImage.image = nil;
    }];
}

//重新选择支付方式
- (void)actionChooseMethod
{
    if (weixinQrcodeButton) weixinQrcodeButton.hidden = NO;
    if (alipayQrcodeButton) alipayQrcodeButton.hidden = NO;
    if (moneyButton) moneyButton.hidden = NO;
    
    qrcodeView.hidden = YES;
    qrcodeChooseButton.hidden = YES;
    moneyConfirmButton.hidden = YES;
    moneyChooseButton.hidden = YES;
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
            
            NSDictionary *param = @{@"action": CASE_STATUS_PAYED};
            
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
            break;
        //取消
        default:
            break;
    }
}

@end
