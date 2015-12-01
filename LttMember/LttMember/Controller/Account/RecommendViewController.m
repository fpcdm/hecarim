//
//  RecommendViewController.m
//  LttMember
//
//  Created by wuyong on 15/12/1.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendView.h"

@interface RecommendViewController () <RecommendViewDelegate>

@end

@implementation RecommendViewController
{
    RecommendView *recommendView;
}

- (void)loadView
{
    recommendView = [[RecommendView alloc] init];
    recommendView.delegate = self;
    self.view = recommendView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐人信息";
}

@end
