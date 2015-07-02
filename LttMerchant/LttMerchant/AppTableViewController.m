//
//  BaseTableViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableViewController.h"
#import "LttNavigationController.h"
#import "NotificationUtil.h"
#import "OrderDetailViewController.h"
#import "ApplyDetailViewController.h"
#import "HomeViewController.h"

@interface AppTableViewController ()

@end

@implementation AppTableViewController

@synthesize tableData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //禁用菜单
    if (isMenuDisabled) {
        //禁用手势
        [(LttNavigationController *) self.navigationController menuEnable:NO];
        
        self.navigationItem.leftBarButtonItem = nil;
        //左侧为返回
    } else if (isMenuBack) {
        //禁用手势
        [(LttNavigationController *) self.navigationController menuEnable:NO];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        //显示菜单
    } else {
        //启用手势
        [(LttNavigationController *) self.navigationController menuEnable:YES];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"]
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:(LttNavigationController *)self.navigationController
                                                                                action:@selector(showMenu)];
    }
    
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    self.tableView.tableFooterView = tableFooterView;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) showEmpty:(NSString *)message
{
    //空数据
    if ([tableData count] < 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 80, 0, 160, 44)];
        label.text = message;
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.tableView.tableFooterView addSubview:label];
    //有数据
    } else {
        for (UIView *view in [self.tableView.tableFooterView subviews]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
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
        if (aps) {
            NSString *message = [aps objectForKey:@"alert"];
            [self showNotification:message callback:^{
                if (action) {
                    NSString *type = [action objectForKey:@"type"];
                    NSString *data = [action objectForKey:@"data"];
                    
                    //根据类型处理事件
                    if (type) {
                        [self handleRemoteNotification:type data:data];
                    }
                }
                
                //取消消息
                [NotificationUtil cancelRemoteNotifications];
                
                //隐藏弹出框
                [self hideDialog];
            }];
        }
    }
}

//根据类型处理远程通知
- (void) handleRemoteNotification:(NSString *) type data: (NSString *) data
{
    //新增需求
    if ([@"CASE_CREATED" isEqualToString:type]) {
        HomeViewController *viewController = [[HomeViewController alloc] init];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
        //已支付，已完成
    } else if ([@"CASE_PAYED" isEqualToString:type] || [@"CASE_SUCCESS" isEqualToString:type]) {
        //跳转详情页面
        if (data) {
            OrderDetailViewController *viewController = [[OrderDetailViewController alloc] init];
            viewController.orderNo = data;
            [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
        }
    }
}

@end
