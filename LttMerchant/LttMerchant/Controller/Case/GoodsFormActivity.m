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
#import "PickerUtil.h"

@interface GoodsFormActivity ()

@end

@implementation GoodsFormActivity
{
    CategoryEntity *category;
    BrandEntity *brand;
    ModelEntity *model;
}

@synthesize intention;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //查询需求
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
    [super reloadData];
    
    self.viewStorage[@"category"] = @{
                                      @"name": category ? category.name : @"选择品类"
                                      };
    
    NSString *modelName = model ? [NSString stringWithFormat:@"%@ %@", brand.name, model.name] : (category ? @"选择品牌型号" : @"请先选择品类");
    self.viewStorage[@"model"] = @{
                                   @"name": modelName
                                   };
    
    //选择品牌型号
    if (category) {
        $(@"#modelButton").ATTR(@"color", @"black").ATTR(@"border", @"0.5px solid #b2b2b2");
        
        UIView *view = $(@"#modelButton").firstView;
    }
    
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
- (void) actionChooseCategory: (SamuraiSignal *) signal
{
    PickerUtil *pickerUtil = [[PickerUtil alloc] initWithTitle:nil grade:1 origin:self.view];
    
    pickerUtil.firstLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){
        CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
        categoryEntity.id = @0;
        categoryEntity.tradeId = [NSNumber numberWithInteger:LTT_TRADE_GOODS];
        
        GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
        [goodsHandler queryCategories:categoryEntity success:^(NSArray *result){
            //分类列表
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for (CategoryEntity *entity in result) {
                [rows addObject:[PickerUtilRow rowWithName:entity.name ? entity.name : @"" value:entity]];
            }
            
            completionHandler(rows);
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
    };
    
    pickerUtil.resultBlock = ^(NSArray *selectedRows){
        if ([selectedRows count] < 1) return;
        
        PickerUtilRow *row = [selectedRows objectAtIndex:0];
        category = row.value;
        
        brand = nil;
        model = nil;
        
        [self reloadData];
    };
    
    [pickerUtil show];
}

- (void) actionChooseModel: (SamuraiSignal *) signal
{
    if (!category) return;
    
    PickerUtil *pickerUtil = [[PickerUtil alloc] initWithTitle:nil grade:2 origin:self.view];
    
    pickerUtil.firstLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){
        //获取品牌列表
        CategoryEntity *categoryModel = [[CategoryEntity alloc] init];
        categoryModel.id = category.id;
        
        GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
        [goodsHandler queryCategoryBrands:categoryModel success:^(NSArray *result){
            //分类列表
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for (CategoryEntity *entity in result) {
                [rows addObject:[PickerUtilRow rowWithName:entity.name ? entity.name : @"" value:entity]];
            }
            
            completionHandler(rows);
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
    };
    
    pickerUtil.firstLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){
        CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
        categoryEntity.id = @0;
        categoryEntity.tradeId = [NSNumber numberWithInteger:LTT_TRADE_GOODS];
        
        GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
        [goodsHandler queryCategories:categoryEntity success:^(NSArray *result){
            //分类列表
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for (CategoryEntity *entity in result) {
                [rows addObject:[PickerUtilRow rowWithName:entity.name ? entity.name : @"" value:entity]];
            }
            
            completionHandler(rows);
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
    };
    
    pickerUtil.resultBlock = ^(NSArray *selectedRows){
        if ([selectedRows count] < 1) return;
        
        PickerUtilRow *row = [selectedRows objectAtIndex:0];
        category = row.value;
        
        [self reloadData];
    };
    
    [pickerUtil show];
}

- (void) actionSave: (SamuraiSignal *) signal
{
    //todo 保存
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
