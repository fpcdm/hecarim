//
//  GoodsFormActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsFormActivity.h"
#import "CategoryEntity.h"
#import "GoodsHandler.h"
#import "BrandEntity.h"
#import "CaseEntity.h"
#import "CaseHandler.h"

@interface GoodsFormActivity ()

@end

@implementation GoodsFormActivity

@synthesize intention;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadCase:^(id object){
        [self reloadData];
    }];
}

- (NSString *)templateName
{
    return @"goodsForm.html";
}

#pragma mark - reloadData
- (void) reloadData
{
    [self renderCaseData];
    
    //重新布局
    [self relayout];
}

#pragma mark - Api
- (void) queryData
{
    //获取品牌列表
    CategoryEntity *categoryModel = [[CategoryEntity alloc] init];
    categoryModel.id = @1;
    
    GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
    [goodsHandler queryCategoryBrands:categoryModel success:^(NSArray *result){
        [self hideLoading];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        [self showError:error.message];
    }];
}

- (void) brandSegmentAction: (UISegmentedControl *) segment
{
    NSInteger selected = segment.selectedSegmentIndex;
    BrandEntity *brandModel = [[BrandEntity alloc] init];
    NSDictionary *param = @{@"category_id": @1};
    
    //获取型号列表
    GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
    [goodsHandler queryBrandModels:brandModel param:param success:^(NSArray *result){
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void) modelSegmentAction: (UISegmentedControl *) segment
{
    NSInteger selected = segment.selectedSegmentIndex;
    ModelEntity *modelModel = [[ModelEntity alloc] init];
    
    //获取型号列表
    GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
    [goodsHandler queryModelGoods:modelModel success:^(NSArray *result){
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

#pragma mark - Action
- (void) actionSave: (SamuraiSignal *) signal
{
    //todo 保存
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
