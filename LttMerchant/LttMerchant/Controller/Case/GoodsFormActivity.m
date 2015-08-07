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
    
    NSNumber *priceId;
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
        [self domCss:@"#specTable" name:@"height" value:[NSString stringWithFormat:@"%ldpx", specCount * 55]];
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
        goods = nil;
        priceId = nil;
        
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
            //清空之前的商品
            goods = nil;
            priceId = nil;
            
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

//规格改变事件
- (void) actionChooseSpec: (SamuraiSignal *) signal
{
    //获取所有规格隐藏按钮
    NSArray *specButtons = $(@"#specButton").views;
    //拼装选中规格
    NSMutableArray *specIds = [[NSMutableArray alloc] init];
    for (UIButton *specButton in specButtons) {
        NSString *specValue = specButton.titleLabel.text ? specButton.titleLabel.text : nil;
        if (specValue && [specValue length] > 0) {
            [specIds addObject:specValue];
        }
    }
    
    //是否选中完成
    UILabel *priceLabel = (UILabel *) $(@"#goodsPrice").firstView;
    if ([specIds count] < [specButtons count]) {
        priceId = nil;
        priceLabel.text = @"￥0";
        return;
    }
    
    //选中完成，获取当前价格id
    NSString *specIdsStr = [specIds componentsJoinedByString:@","];
    NSArray *priceList = goods.priceList;
    NSDictionary *priceItem = nil;
    if (priceList) {
        for (NSDictionary *subPrice in priceList) {
            if ([specIdsStr isEqualToString:[subPrice objectForKey:@"spec_ids"]]) {
                priceItem = subPrice;
                break;
            }
        }
    }
    
    //切换价格
    if (priceItem) {
        priceId = [priceItem objectForKey:@"price_id"];
        NSNumber *price = [priceItem objectForKey:@"goods_price"];
        priceLabel.text = [NSString stringWithFormat:@"￥%@", price];
    } else {
        priceId = nil;
        priceLabel.text = @"￥0";
        return;
    }
}

- (void) actionGoodsNumberPlus: (SamuraiSignal *) signal
{
    UILabel *numberLabel = (UILabel *) $(@"#goodsNumber").firstView;
    NSInteger number = [self getGoodsNumber:numberLabel];
    
    number++;
    numberLabel.text = [NSString stringWithFormat:@"%ld", number];
}

- (void) actionGoodsNumberMinus: (SamuraiSignal *) signal
{
    UILabel *numberLabel = (UILabel *) $(@"#goodsNumber").firstView;
    NSInteger number = [self getGoodsNumber:numberLabel];
    
    number--;
    if (number < 1) number = 1;
    numberLabel.text = [NSString stringWithFormat:@"%ld", number];
}

//获取商品数量
- (NSInteger) getGoodsNumber: (UILabel *) numberLabel
{
    if (!numberLabel) {
        numberLabel = (UILabel *) $(@"#goodsNumber").firstView;
    }
    NSString *numberStr = [numberLabel.text trim];
    NSInteger number = [numberStr length] > 0 ? [numberStr integerValue] : 1;
    return number;
}

- (void) actionSave: (SamuraiSignal *) signal
{
    //参数检查
    if (!category) {
        [self showError:@"请先选择品类哦~亲！"];
        return;
    }
    if (!model) {
        [self showError:@"请先选择品牌型号哦~亲！"];
        return;
    }
    if (!goods || !priceId) {
        [self showError:@"请先选择商品哦~亲！"];
        return;
    }
    
    //获取商品列表
    CaseEntity *postCase = [[CaseEntity alloc] init];
    postCase.id = self.caseId;
    
    BOOL isEdit = intention.goods && [intention.goods count] > 0 ? YES : NO;
    //获取之前的商品列表
    NSMutableArray *goodsList = [[NSMutableArray alloc] init];
    if (isEdit) {
        for (GoodsEntity *entity in intention.goods) {
            [goodsList addObject:entity];
        }
    }
    
    //添加当前商品
    GoodsEntity *currentGoods = [[GoodsEntity alloc] init];
    currentGoods.id = goods.id;
    NSInteger number = [self getGoodsNumber:nil];
    currentGoods.number = [NSNumber numberWithInteger:number];
    currentGoods.priceId = priceId;
    [goodsList addObject:currentGoods];
    
    //转换数据
    postCase.goods = goodsList;
    postCase.goodsParam = [postCase formatFormGoods];
    postCase.goods = nil;
    
    //提交数据
    [self showLoading:TIP_REQUEST_MESSAGE];
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    //新增
    if (!isEdit) {
        [caseHandler addCaseGoods:postCase success:^(NSArray *result){
            [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
                //通知刷新
                if (self.callbackBlock) {
                    self.callbackBlock(@1);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
    //编辑
    } else {
        [caseHandler editCaseGoods:postCase success:^(NSArray *result){
            [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
                //通知刷新
                if (self.callbackBlock) {
                    self.callbackBlock(@1);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
    }
}

@end
