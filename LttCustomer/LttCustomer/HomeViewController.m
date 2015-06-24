//
//  RootViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "IntentionViewController.h"
#import "IntentionEntity.h"
#import "IntentionHandler.h"

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
- (void)actionIntention:(NSNumber *)type
{
    //获取参数
    IntentionEntity *intentionEntity = [[IntentionEntity alloc] init];
    intentionEntity.type = type;
    //@todo:gps坐标
    intentionEntity.location = @"0,0";
    
    NSLog(@"intention: %@", [intentionEntity toDictionary]);
    
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    [intentionHandler addIntention:intentionEntity success:^(NSArray *result){
        IntentionEntity *intention = [result firstObject];
        
        //跳转需求详情
        IntentionViewController *viewController = [[IntentionViewController alloc] init];
        viewController.intentionId = intention.id;
        [self pushViewController:viewController animated:YES];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

@end
