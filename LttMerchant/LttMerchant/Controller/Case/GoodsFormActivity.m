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

@property (nonatomic, strong) UITableView *specTable;

@end

@implementation GoodsFormActivity
{
    CategoryEntity *category;
    BrandEntity *brand;
    ModelEntity *model;
    GoodsEntity *goods;
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
    }
    
    //规格列表
    NSInteger specCount = goods && goods.specList ? [goods.specList count] : 0;
    self.viewStorage[@"specs"] = @{
                                   @"list":({
                                       NSMutableArray *specs = [NSMutableArray array];
                                       
                                       //已选型号
                                       if (specCount > 0) {
                                           for (SpecEntity *specEntity in goods.specList) {
                                               [specs addObject:@{
                                                                  @"name": specEntity.name ? specEntity.name : @"",
                                                                  @"list": specEntity.children ? specEntity.children : @[]
                                                                  }];
                                           }
                                       }
                                       
                                       specs;
                                   })
                                   
                                   };
    
    //自动切换样式并计算高度
    if (specCount > 0) {
        [self domDisplay:@"#specEmpty" display:@"none"];
        [self domCss:@"#specTable" name:@"height" value:[NSString stringWithFormat:@"%ldpx", specCount * 50]];
    } else {
        [self domDisplay:@"#specEmpty" display:@"block"];
        [self domCss:@"#specTable" name:@"height" value:@"0px"];
    }
    
    [_specTable reloadData];
    
    //重新布局
    [self relayout];
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
            for (BrandEntity *entity in result) {
                [rows addObject:[PickerUtilRow rowWithName:entity.name ? entity.name : @"" value:entity]];
            }
            
            completionHandler(rows);
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
    };
    
    pickerUtil.secondLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){
        PickerUtilRow *brandRow = [selectedRows objectAtIndex:0];
        
        BrandEntity *brandEntity = brandRow.value;
        NSDictionary *param = @{@"category_id": category.id};
        
        //获取型号列表
        GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
        [goodsHandler queryBrandModels:brandEntity param:param success:^(NSArray *result){
            //分类列表
            NSMutableArray *rows = [[NSMutableArray alloc] init];
            for (ModelEntity *entity in result) {
                [rows addObject:[PickerUtilRow rowWithName:entity.name ? entity.name : @"" value:entity]];
            }
            
            completionHandler(rows);
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
    };
    
    pickerUtil.resultBlock = ^(NSArray *selectedRows){
        if ([selectedRows count] < 2) return;
        
        PickerUtilRow *brandRow = [selectedRows objectAtIndex:0];
        brand = brandRow.value;
        
        PickerUtilRow *modelRow = [selectedRows objectAtIndex:1];
        model = modelRow.value;
        
        //加载规格列表
        ModelEntity *modelEntity = [[ModelEntity alloc] init];
        modelEntity.id = model.id;
        
        //获取型号列表
        GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
        [goodsHandler queryModelGoods:modelEntity success:^(NSArray *result){
            //没有商品
            if ([result count] < 1) {
                [self reloadData];
                
                [self showError:@"该型号暂无商品"];
                return;
            }
            
            goods = [result firstObject];
            
            [self reloadData];
        } failure:^(ErrorEntity *error){
            [self reloadData];
            
            [self showError:error.message];
        }];
    };
    
    [pickerUtil show];
}

- (void) actionSave: (SamuraiSignal *) signal
{
    //todo 保存
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
