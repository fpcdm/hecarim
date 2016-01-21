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
    
    self.navigationItem.title = self.categoryId ? @"添加服务" : @"添加场景";
    
    UIBarButtonItem *barButtonItem = [AppUIUtil makeBarButtonItem:@"保存"];
    barButtonItem.target = self;
    barButtonItem.action = @selector(actionAdd);
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //获取分类列表
    if (!self.categoryId) {
        [self showLoading:[LocaleUtil system:@"Loading.Start"]];
        
        CaseHandler *caseHandler = [[CaseHandler alloc] init];
        NSDictionary *param = @{@"target": @"other"};
        [caseHandler queryCategories:param success:^(NSArray *result) {
            [self hideLoading];
            
            categoryList = result;
            
            //刷新页面
            [categoryView assign:@"categories" value:categoryList];
            [categoryView display];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    //获取服务列表
    } else {
        [self showLoading:[LocaleUtil system:@"Loading.Start"]];
        
        CaseHandler *caseHandler = [[CaseHandler alloc] init];
        NSDictionary *param = @{@"category_id": self.categoryId, @"target": @"other"};
        [caseHandler queryTypes:param success:^(NSArray *result) {
            [self hideLoading];
            
            categoryList = result;
            
            //刷新页面
            [categoryView assign:@"categories" value:categoryList];
            [categoryView display];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    }
}

#pragma mark - Action
- (void)actionAdd
{
    //获取选中的列表
    NSArray *categories = [categoryView selectedCategories];
    if (!categories || [categories count] < 1) {
        [self showError:self.categoryId ? [LocaleUtil error:@"Services.Required"] : [LocaleUtil error:@"Scenes.Required"]];
        return;
    }
    
    if (self.callbackBlock) {
        self.callbackBlock(categories);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
