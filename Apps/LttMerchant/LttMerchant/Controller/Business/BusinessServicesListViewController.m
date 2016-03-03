//
//  BusinessServicesListViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessServicesListViewController.h"
#import "BusinessServicesListView.h"
#import "BusinessHandler.h"

@interface BusinessServicesListViewController ()<BusinessServicesListViewDelegate>

@end

@implementation BusinessServicesListViewController
{
    BusinessServicesListView *listView;
    NSMutableArray *servicesList;
}


- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"绑定服务";
    
    //默认值
    servicesList = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    listView = [[BusinessServicesListView alloc] init];
    listView.delegate = self;
    self.view = listView;
    
    [self showLoading:[FWLocale system:@"Request.Start"]];
    
    BusinessHandler *businessHandler = [[BusinessHandler alloc] init];
    
    [businessHandler getUserServicesList:nil success:^(NSArray *result) {
        [self hideLoading];
        ResultEntity *resultEntity = [result firstObject];
        NSLog(@"服务列表：%@",resultEntity.data);
        for (NSDictionary *servicesDetail in resultEntity.data) {
            [servicesList addObject:servicesDetail];
        }
        [listView assign:@"servicesList" value:servicesList];
        [listView display];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];

}

- (void)actionSelectServices:(NSDictionary *)services
{
    [FWDebug dump:services];
    if (self.callbackBlock) {
        self.callbackBlock(services);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
