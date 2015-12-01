//
//  RecommendShareViewController.m
//  LttMember
//
//  Created by wuyong on 15/12/1.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "RecommendShareViewController.h"
#import "RecommendShareView.h"
#import "RecommendViewController.h"

@interface RecommendShareViewController () <RecommendShareViewDelegate>

@end

@implementation RecommendShareViewController
{
    RecommendShareView *recommendShareView;
}

- (void)loadView
{
    recommendShareView = [[RecommendShareView alloc] init];
    recommendShareView.delegate = self;
    self.view = recommendShareView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐与分享";
}

#pragma mark - Action
- (void)actionRecommend
{
    RecommendViewController *viewController = [[RecommendViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionShare
{
    
}

@end
