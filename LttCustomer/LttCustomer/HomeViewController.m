//
//  RootViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "CaseViewController.h"
#import "LoginViewController.h"
#import "CaseEntity.h"
#import "CaseHandler.h"

@interface HomeViewController () <HomeViewDelegate>

@end

@implementation HomeViewController
{
    HomeView *homeView;
}

- (void)loadView
{
    homeView = [[HomeView alloc] init];
    homeView.delegate = self;
    self.view = homeView;
}

- (void)viewDidLoad
{
    isMenuEnabled = [self isLogin];
    isIndexNavBar = YES;
    hideBackButton = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"两条腿";
    
    NSString *address = @"重庆市 渝北区 龙山街道";
    NSNumber *count = @12;
    
    [homeView setData:@"address" value:address];
    [homeView setData:@"count" value:count];
    [homeView renderData];
}

#pragma mark - Action
- (void)actionCase:(NSNumber *)type
{
    //是否登陆
    if (![self isLogin]) {
        LoginViewController *viewController = [[LoginViewController alloc] init];
        [self pushViewController:viewController animated:YES];
        return;
    }
    
    //获取参数
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.type = type;
    //@todo:gps坐标
    intentionEntity.location = @"0,0";
    
    NSLog(@"intention: %@", [intentionEntity toDictionary]);
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    CaseHandler *intentionHandler = [[CaseHandler alloc] init];
    [intentionHandler addIntention:intentionEntity success:^(NSArray *result){
        CaseEntity *intention = [result firstObject];
        
        NSLog(@"需求id: %@", intention.id);
        
        //查询需求
        CaseHandler *intentionHandler = [[CaseHandler alloc] init];
        [intentionHandler queryIntention:intentionEntity success:^(NSArray *result){
            CaseEntity *intention = [result firstObject];
            
            NSLog(@"需求数据：%@", [intention toDictionary]);
            
            //跳转需求详情
            CaseViewController *viewController = [[CaseViewController alloc] init];
            viewController.intention = intention;
            [self pushViewController:viewController animated:YES];
        } failure:^(ErrorEntity *error){
            [self hideLoading];
            
            [self showError:error.message];
        }];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        
        [self showError:error.message];
    }];
}

@end
