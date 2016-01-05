//
//  GoodsFormViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsFormViewController.h"
#import "CategoryEntity.h"
#import "GoodsHandler.h"
#import "BrandEntity.h"
#import "CaseEntity.h"
#import "CaseHandler.h"
#import "SKDropDown.h"
#import "GoodsFormView.h"

@interface GoodsFormViewController () <SKDropDownDelegate,GoodsFormViewDelegate>

@end

@implementation GoodsFormViewController
{
    NSArray *categoryList;
    NSArray *brandList;
    NSArray *modelList;
    
    CategoryEntity *category;
    BrandEntity *brand;
    ModelEntity *model;
    GoodsEntity *goods;
    GoodsFormView *goodsFormView;
    
    SKDropDown *categoryDropDown;
    SKDropDown *brandDropDown;
    SKDropDown *modelDropDown;
    
    UIButton *brandButton;
    UIButton *modelButton;
    
    NSNumber *priceId;
}

@synthesize intention;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    goodsFormView = [[GoodsFormView alloc] init];
    brandButton = goodsFormView.brandButton;
    modelButton = goodsFormView.modelButton;
    goodsFormView.delegate = self;
    self.view = goodsFormView;
    self.view.backgroundColor = COLOR_MAIN_BG;
    self.navigationItem.title = @"商品添加";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //查询需求
    [self loadCase:^(id object){
        [self reloadData];
    }];
}

#pragma mark - reloadData
- (void) reloadData
{
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.no = self.intention.no;
    caseEntity.status = self.intention.status;
    [goodsFormView setData:@"caseEntity" value:caseEntity];
    [goodsFormView setCaseNo];
    
}

- (void)reloadSpec
{
    //规格列表
    NSInteger specCount = goods && goods.specList ? [goods.specList count] : 0;
    NSMutableArray *specs = [NSMutableArray array];
    
    //已选型号
    if (specCount > 0) {
        for (SpecEntity *specEntity in goods.specList) {
            [specs addObject:@{
                               @"info": @"",
                               @"name": specEntity.name ? specEntity.name : @"",
                               @"list": specEntity.children ? specEntity.children : @[]
                               }];
        }
    }
    [goodsFormView setData:@"spexBox" value:specs];
    [goodsFormView specBox];
}

#pragma mark - DropDown
- (void) showDropDown:(UIButton *)sender tag:(NSInteger)tag
{
    //整理数据
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    switch (tag) {
        case 1:
            for (CategoryEntity *entity in categoryList) {
                [rows addObject:entity.name ? entity.name : @""];
            }
            break;
        case 2:
            for (BrandEntity *entity in brandList) {
                [rows addObject:entity.name ? entity.name : @""];
            }
            break;
        default:
            for (ModelEntity *entity in modelList) {
                [rows addObject:entity.name ? entity.name : @""];
            }
            break;
    }
    
    //初始化下拉列表
    CGFloat dropDownHeight = 35 * [rows count];
    if (dropDownHeight > 200) dropDownHeight = 200;
    SKDropDown *dropDown = [[SKDropDown alloc]showDropDown:sender withHeight:dropDownHeight withData:rows animationDirection:@"down"];
    dropDown.tag = tag;
    dropDown.delegate = self;
    
    //变量赋值
    switch (tag) {
        case 1:
            categoryDropDown = dropDown;
            break;
        case 2:
            brandDropDown = dropDown;
            break;
        default:
            modelDropDown = dropDown;
            break;
    }
}

- (CGFloat) dropDown:(SKDropDown *)_dropDown heightForRow:(NSIndexPath *)indexPath
{
    return 35;
}

- (void) dropDown:(SKDropDown *)_dropDown didSelectRow:(NSIndexPath *)indexPath
{
    switch (_dropDown.tag) {
            //选择分类
        case 1:
        {
            category = [categoryList objectAtIndex:indexPath.row];
            categoryDropDown = nil;
            
            //清空已选择
            brand = nil;
            model = nil;
            brandList = nil;
            modelList = nil;
            
            [brandButton setTitle:@"请选择" forState:UIControlStateNormal];
            [brandButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
            brandButton.enabled = YES;
            
            [modelButton setTitle:@"请选择" forState:UIControlStateNormal];
            modelButton.enabled = NO;
            
            if (goods) {
                goods = nil;
                priceId = nil;
                [self reloadSpec];
                
                [goodsFormView setGoodsPrice:@"￥0"];
            }
        }
            break;
            //选择品牌
        case 2:
        {
            brand = [brandList objectAtIndex:indexPath.row];
            brandDropDown = nil;
            
            //清空已选择
            model = nil;
            modelList = nil;
            
            [modelButton setTitle:@"请选择" forState:UIControlStateNormal];
            [modelButton setTitleColor:COLOR_MAIN_BLACK forState:UIControlStateNormal];
            modelButton.enabled = YES;
            
            if (goods) {
                goods = nil;
                priceId = nil;
                [self reloadSpec];
                
                [goodsFormView setGoodsPrice:@"￥0"];
            }
        }
            break;
            //选择型号
        default:
        {
            model = [modelList objectAtIndex:indexPath.row];
            modelDropDown = nil;
            
            [self showLoading:[LocaleUtil system:@"Loading.Start"]];
            
            //加载规格列表
            ModelEntity *modelEntity = [[ModelEntity alloc] init];
            modelEntity.id = model.id;
            
            //获取型号列表
            GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
            [goodsHandler queryModelGoods:modelEntity success:^(NSArray *result){
                [self hideLoading];
                
                //清空之前的商品
                goods = nil;
                priceId = nil;
                
                [goodsFormView setGoodsPrice:@"￥0"];
                
                //没有商品
                if ([result count] < 1) {
                    [self reloadSpec];
                    
                    [self showError:[LocaleUtil error:@"Model.NotGoods"]];
                    return;
                }
                
                goods = [result firstObject];
                
                [self reloadSpec];
            } failure:^(ErrorEntity *error){
                [self showError:error.message];
            }];
        }
            break;
    }
}

#pragma mark - Action
- (void) actionChooseCategory:(UIButton *)sender
{
    //显示dropDown
    if (categoryDropDown == nil) {
        //加载分类列表
        if (!categoryList) {
            [self showLoading:[LocaleUtil system:@"Loading.Start"]];
            
            CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
            categoryEntity.id = @0;
            categoryEntity.tradeId = [NSNumber numberWithInteger:LTT_TRADE_GOODS];
            
            GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
            [goodsHandler queryCategories:categoryEntity success:^(NSArray *result){
                [self hideLoading];
                
                if ([result count] < 1) {
                    [self showError:[LocaleUtil error:@"Category.NotFound"]];
                    return;
                }
                
                categoryList = result;
                
                [self showDropDown:sender tag:1];
            } failure:^(ErrorEntity *error){
                [self showError:error.message];
            }];
        } else {
            [self showDropDown:sender tag:1];
        }
        //隐藏dropDown
    } else {
        [categoryDropDown hideDropDown:sender];
        categoryDropDown = nil;
    }
}

- (void) actionChooseBrand: (UIButton *) sender
{
    //参数检查
    if (!category) {
        [self showError:[LocaleUtil error:@"Category.Required"]];
        return;
    }
    
    //显示dropDown
    if (brandDropDown == nil) {
        [self showLoading:[LocaleUtil system:@"Loading.Start"]];
        
        //获取品牌列表
        CategoryEntity *categoryModel = [[CategoryEntity alloc] init];
        categoryModel.id = category.id;
        
        GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
        [goodsHandler queryCategoryBrands:categoryModel success:^(NSArray *result){
            [self hideLoading];
            
            if ([result count] < 1) {
                [self showError:[LocaleUtil error:@"Category.NotBrand"]];
                return;
            }
            
            brandList = result;
            
            [self showDropDown:sender tag:2];
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
        //隐藏dropDown
    } else {
        [brandDropDown hideDropDown:sender];
        brandDropDown = nil;
    }
}

- (void) actionChooseModel: (UIButton *) sender
{
    //参数检查
    if (!brand) {
        [self showError:[LocaleUtil error:@"Model.Required"]];
        return;
    }
    
    
    //显示dropDown
    if (modelDropDown == nil) {
        [self showLoading:[LocaleUtil system:@"Loading.Start"]];
        
        //获取型号列表
        BrandEntity *brandEntity = brand;
        NSDictionary *param = @{@"category_id": category.id};
        
        GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
        [goodsHandler queryBrandModels:brandEntity param:param success:^(NSArray *result){
            [self hideLoading];
            
            if ([result count] < 1) {
                [self showError:[LocaleUtil error:@"Brand.NotModel"]];
                return;
            }
            
            modelList = result;
            
            [self showDropDown:sender tag:3];
        } failure:^(ErrorEntity *error){
            [self showError:error.message];
        }];
        //隐藏dropDown
    } else {
        [modelDropDown hideDropDown:sender];
        modelDropDown = nil;
    }
}

//规格改变事件
- (void) actionChooseSpec: (NSMutableArray *) specData
{
    //选中完成，获取当前价格id
    NSString *specIdsStr = [specData componentsJoinedByString:@","];
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
        [goodsFormView setGoodsPrice:[NSString stringWithFormat:@"￥%@", price]];
    } else {
        priceId = nil;
        [goodsFormView setGoodsPrice:@"￥0"];
        return;
    }
}

//保存商品
- (void) actionSave: (NSInteger)number
{
    //参数检查
    if (!category) {
        [self showError:[LocaleUtil error:@"Category.Required"]];
        return;
    }
    if (!model) {
        [self showError:[LocaleUtil error:@"Model.Required"]];
        return;
    }
    if (!goods || !priceId) {
        [self showError:[LocaleUtil error:@"Spec.Required"]];
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
    currentGoods.number = [NSNumber numberWithInteger:number];
    currentGoods.priceId = priceId;
    [goodsList addObject:currentGoods];
    
    //转换数据
    postCase.goods = goodsList;
    postCase.goodsParam = [postCase formatFormGoods];
    postCase.goods = nil;
    
    //提交数据
    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    //新增
    if (!isEdit) {
        [caseHandler addCaseGoods:postCase success:^(NSArray *result){
            [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
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
            [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
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
