//
//  CaseCategoryViewController.m
//  LttMember
//
//  Created by wuyong on 15/10/22.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CaseCategoryViewController.h"
#import "CaseCategoryView.h"
#import "CaseHandler.h"

@interface CaseCategoryViewController () <CaseCategoryViewDelegate>

@end

@implementation CaseCategoryViewController
{
    CaseCategoryView *categoryView;
    NSArray *categoryList;
}

- (void)loadView
{
    categoryView = [[CaseCategoryView alloc] init];
    categoryView.delegate = self;
    self.view = categoryView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加服务";
    
    UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonItem:@"保存"];
    barButtonItem.target = self;
    barButtonItem.action = @selector(actionAdd);
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //获取服务列表
    [self showLoading:[LocaleUtil system:@"Loading.Start"]];
    
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler queryUnfavoriteTypes:nil success:^(NSArray *result) {
        [self hideLoading];
        
        categoryList = result;
        
        //刷新页面
        [categoryView assign:@"categories" value:categoryList];
        [categoryView display];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

#pragma mark - Action
- (void)actionAdd
{
    //获取选中的列表
    NSArray *categories = [categoryView selectedCategories];
    if (!categories || [categories count] < 1) {
        [self showError:[LocaleUtil error:@"Services.Required"]];
        return;
    }
    
    if (self.callbackBlock) {
        self.callbackBlock(categories);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
