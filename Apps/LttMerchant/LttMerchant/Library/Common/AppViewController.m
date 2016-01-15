//
//  AppViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/7/21.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"
#import "LttNavigationController.h"
#import "LttAppDelegate.h"
#import "AppExtension.h"
#import "REFrostedViewController.h"
#import "MenuViewController.h"
#import "NotificationUtil.h"
#import "CaseDetailViewController.h"
#import "AppView.h"
#import "CNPPopupController.h"
#import "CasePopupView.h"

@interface AppViewController () <CNPPopupControllerDelegate, CasePopupViewDelegate>

@end

@implementation AppViewController
{
    CNPPopupController *popupController;
    CasePopupView *casePopupView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //子页面导航返回按钮
    NSString *backButtonTitle = IS_IOS7_PLUS ? @"" : @"返回";
    UIBarButtonItem *backButtonItem = [AppUIUtil makeBarButtonItem:backButtonTitle];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    //当前页面是否隐藏返回按钮
    if (hideBackButton) {
        self.navigationItem.hidesBackButton = YES;
    } else {
        self.navigationItem.hidesBackButton = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //是否有左侧菜单
    if (isMenuEnabled) {
        //启用手势
        [(LttNavigationController *) self.navigationController menuEnable:YES];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:(LttNavigationController *)self.navigationController
                                                                                action:@selector(showMenu)];
    } else {
        //禁用手势
        [(LttNavigationController *) self.navigationController menuEnable:NO];
    }
    
    //状态栏颜色
    if (isIndexNavBar) {
        //红色背景
        //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        //白色背景
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    //导航栏高亮，返回时保留
    if (isIndexNavBar) {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        if ([navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            navigationBar.barTintColor = COLOR_MAIN_BLUE;
        }
        navigationBar.tintColor = COLOR_MAIN_WHITE;
        navigationBar.titleTextAttributes = @{
                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                              NSForegroundColorAttributeName: COLOR_MAIN_WHITE
                                              };
    } else {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        if ([navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
            navigationBar.barTintColor = COLOR_MAIN_WHITE;
        }
        navigationBar.tintColor = COLOR_MAIN_BLACK;
        navigationBar.titleTextAttributes = @{
                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                              NSForegroundColorAttributeName: COLOR_MAIN_BLACK
                                              };
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //检查远程通知
    if (!hideRemoteNotification) {
        [self checkRemoteNotification];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //隐藏远程通知
    if (!hideRemoteNotification) {
        [self hideDialog];
    }
}

#pragma mark - Public Methods
- (BOOL) isLogin
{
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    if (user) {
        return YES;
    } else {
        return NO;
    }
}

- (void) pushViewController:(UIViewController *)viewController animated: (BOOL)animated
{
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void) toggleViewController: (UIViewController *)viewController animated: (BOOL)animated
{
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:animated];
}

- (void) refreshViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    //替换最后一个控制器
    if ([viewControllers count] > 0) {
        [viewControllers removeLastObject];
    }
    [viewControllers addObject:viewController];
    
    [self.navigationController setViewControllers:viewControllers animated:animated];
}

- (void) refreshMenu
{
    REFrostedViewController *frostedViewController = (REFrostedViewController *) self.view.window.rootViewController;
    MenuViewController *menuViewController = (MenuViewController *) frostedViewController.menuViewController;
    [menuViewController refresh];
}

- (void) checkRemoteNotification
{
    //未登录不检查
    if (![self isLogin]) return;
    
    //已登录
    NSDictionary *remoteNotification = [[StorageUtil sharedStorage] getRemoteNotification];
    if (remoteNotification) {
        NSDictionary *aps = [remoteNotification objectForKey:@"aps"];
        NSDictionary *action = [remoteNotification objectForKey:@"action"];
        
        //显示消息
        if (aps && action) {
            NSString *message = [aps objectForKey:@"alert"];
            NSString *type = [action objectForKey:@"type"];
            NSString *data = [action objectForKey:@"data"];
            
            //根据类型处理远程通知
            if (message && type) {
                [self handleRemoteNotification:message type:type data:data];
            }
        }
    }
}

//清除消息数量及消息
- (void) clearRemoteNotifications
{
    //取消消息
    [NotificationUtil cancelRemoteNotifications];
    //清空服务器数量
    LttAppDelegate *appDelegate = (LttAppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate clearNotifications];
}

//处理远程通知钩子（默认顶部弹出框）
- (void) handleRemoteNotification:(NSString *)message type:(NSString *)type data:(NSString *)data
{
    //新订单单独处理
    if ([@"CASE_CREATED" isEqualToString:type]) {
        NSNumber *caseId = [NSNumber numberWithInteger:[data integerValue]];
        [self handleCaseNewNotification:message caseId:caseId];
        return;
    }
    
    //其它推送采用弹出框方式
    [self showNotification:message callback:^{
        //清除消息数量及消息
        [self clearRemoteNotifications];
        
        //已支付，已完成
        if ([@"CASE_PAYED" isEqualToString:type] || [@"CASE_SUCCESS" isEqualToString:type]) {
            //跳转详情页面
            if (data) {
                NSNumber *caseId = [NSNumber numberWithInteger:[data integerValue]];
                
                CaseDetailViewController *viewController = [[CaseDetailViewController alloc] init];
                viewController.caseId = caseId;
                [self toggleViewController:viewController animated:YES];
            }
        }
        
        //隐藏弹出框
        [self hideDialog];
    }];
}

//处理新订单通知钩子
- (void) handleCaseNewNotification:(NSString *)message caseId:(NSNumber *)caseId
{
    //弹框已经存在，忽略消息
    if (popupController) return;
    
    //清除消息数量及消息，只弹出一次
    [self clearRemoteNotifications];
    
    //调用接口
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = caseId;
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler queryCase:intentionEntity success:^(NSArray *result){
        [self showPopupController:message intention:[result firstObject]];
    } failure:^(ErrorEntity *error){
        [self showError:[LocaleUtil info:@"Challenge.Lose"]];
    }];
}

#pragma mark - Popup
- (void)showPopupController:(NSString *)message intention:(CaseEntity *)newIntention
{
    //弹出框容器
    UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_AVAILABLE_HEIGHT)];
    
    //弹出视图
    casePopupView = [[CasePopupView alloc] init];
    casePopupView.delegate = self;
    [popupView addSubview:casePopupView];
    
    [casePopupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(popupView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //加载数据
    [casePopupView setData:@"title" value:message];
    [casePopupView setData:@"intention" value:newIntention];
    [casePopupView renderData];
    
    //显示弹出框
    popupController = [[CNPPopupController alloc] initWithContents:@[popupView]];
    popupController.theme = [CNPPopupTheme defaultTheme];
    popupController.theme.popupStyle = CNPPopupStyleActionSheet;
    popupController.theme.cornerRadius = 0;
    popupController.theme.popupContentInsets = UIEdgeInsetsZero;
    popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromTop;
    popupController.theme.maskType = CNPPopupMaskTypeDimmed;
    popupController.theme.contentVerticalPadding = 0;
    popupController.theme.maxPopupWidth = SCREEN_WIDTH;
    popupController.theme.shouldDismissOnBackgroundTouch = YES;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
}

- (void)popupControllerDidDismiss:(CNPPopupController *)controller
{
    popupController = nil;
    casePopupView = nil;
}

- (void)actionPopupMobile:(NSString *)mobile
{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

- (void)actionPopupClose
{
    [popupController dismissPopupControllerAnimated:YES];
}

- (void)actionPopupCompete:(NSNumber *)caseId
{
    //开始抢单
    [casePopupView startCompete];
    
    //获取数据
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.id = caseId;
    
    //调用接口
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler competeCase:intentionEntity success:^(NSArray *result){
        //抢单成功
        [casePopupView finishCompete];
        
        //关闭弹出框
        [popupController dismissPopupControllerAnimated:YES];
        
        //详情页面
        CaseDetailViewController *viewController = [[CaseDetailViewController alloc] init];
        viewController.caseId = caseId;
        [self toggleViewController:viewController animated:YES];
    } failure:^(ErrorEntity *error){
        [popupController dismissPopupControllerAnimated:YES];
        [self showError:[LocaleUtil info:@"Challenge.Fail"]];
    }];
}

@end
