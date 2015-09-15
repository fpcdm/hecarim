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
#import "SKDropDown.h"

@interface GoodsFormActivity () <SKDropDownDelegate>

@property (nonatomic, strong) UITableView *specTable;

@end

@implementation GoodsFormActivity
{
    NSArray *categoryList;
    NSArray *brandList;
    NSArray *modelList;
    
    CategoryEntity *category;
    BrandEntity *brand;
    ModelEntity *model;
    GoodsEntity *goods;
    
    SKDropDown *categoryDropDown;
    SKDropDown *brandDropDown;
    SKDropDown *modelDropDown;
    
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

- (void)onTemplateLoaded
{
    self.specTable.scrollEnabled = NO;
}

#pragma mark - reloadData
- (void) reloadData
{
    [super reloadData];
    
    //规格列表
    NSInteger specCount = goods && goods.specList ? [goods.specList count] : 0;
    self.scope[@"specs"] = @{
                                   @"list":({
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
                                       } else {
                                           [specs addObject:@{
                                                              @"info": @"请先选择品牌型号",
                                                              @"name": @"",
                                                              @"list": @[]
                                                              }];
                                       }
                                       
                                       specs;
                                   })
                                   
                                   };
    
    //自动切换样式并计算高度
    if (specCount > 0) {
        $(@"#specTable").ATTR(@"height", [NSString stringWithFormat:@"%ldpx", specCount * 60]);
    } else {
        $(@"#specTable").ATTR(@"height", @"60px");
    }
    
    [_specTable reloadData];
    
    //重新布局
    [self relayout];
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
            
            UIButton *brandButton = (UIButton *)$(@"#brandButton").firstView;
            [brandButton setTitle:@"请选择" forState:UIControlStateNormal];
            
            UIButton *modelButton = (UIButton *)$(@"#modelButton").firstView;
            [modelButton setTitle:@"请选择" forState:UIControlStateNormal];
            
            if (goods) {
                goods = nil;
                priceId = nil;
                [self reloadData];
                
                UILabel *priceLabel = (UILabel *) $(@"#goodsPrice").firstView;
                priceLabel.text = @"￥0";
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
            
            UIButton *modelButton = (UIButton *)$(@"#modelButton").firstView;
            [modelButton setTitle:@"请选择" forState:UIControlStateNormal];
            
            if (goods) {
                goods = nil;
                priceId = nil;
                [self reloadData];
                
                UILabel *priceLabel = (UILabel *) $(@"#goodsPrice").firstView;
                priceLabel.text = @"￥0";
            }
        }
            break;
        //选择型号
        default:
        {
            model = [modelList objectAtIndex:indexPath.row];
            modelDropDown = nil;
            
            [self showLoading:TIP_LOADING_MESSAGE];
            
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
                
                UILabel *priceLabel = (UILabel *) $(@"#goodsPrice").firstView;
                priceLabel.text = @"￥0";
                
                //没有商品
                if ([result count] < 1) {
                    [self reloadData];
                    
                    [self showError:@"该型号暂无商品"];
                    return;
                }
                
                goods = [result firstObject];
                
                [self reloadData];
            } failure:^(ErrorEntity *error){
                [self showError:error.message];
            }];
        }
            break;
    }
}

#pragma mark - Action
- (void) actionChooseCategory: (SamuraiSignal *) signal
{
    UIButton *sender = (UIButton *) signal.sourceView;
    
    //显示dropDown
    if (categoryDropDown == nil) {
        //加载分类列表
        if (!categoryList) {
            [self showLoading:TIP_LOADING_MESSAGE];
            
            CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
            categoryEntity.id = @0;
            categoryEntity.tradeId = [NSNumber numberWithInteger:LTT_TRADE_GOODS];
            
            GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
            [goodsHandler queryCategories:categoryEntity success:^(NSArray *result){
                [self hideLoading];
                
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

- (void) actionChooseBrand: (SamuraiSignal *) signal
{
    //参数检查
    if (!category) {
        [self showError:@"请先选择商品类别哦~亲！"];
        return;
    }
    
    UIButton *sender = (UIButton *) signal.sourceView;
    
    //显示dropDown
    if (brandDropDown == nil) {
        [self showLoading:TIP_LOADING_MESSAGE];
        
        //获取品牌列表
        CategoryEntity *categoryModel = [[CategoryEntity alloc] init];
        categoryModel.id = category.id;
        
        GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
        [goodsHandler queryCategoryBrands:categoryModel success:^(NSArray *result){
            [self hideLoading];
            
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

- (void) actionChooseModel: (SamuraiSignal *) signal
{
    //参数检查
    if (!brand) {
        [self showError:@"请先选择品牌哦~亲！"];
        return;
    }
    
    UIButton *sender = (UIButton *) signal.sourceView;
    
    //显示dropDown
    if (modelDropDown == nil) {
        [self showLoading:TIP_LOADING_MESSAGE];
        
        //获取型号列表
        BrandEntity *brandEntity = brand;
        NSDictionary *param = @{@"category_id": category.id};
        
        GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
        [goodsHandler queryBrandModels:brandEntity param:param success:^(NSArray *result){
            [self hideLoading];
            
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
        [self showError:@"请先选择商品类别哦~亲！"];
        return;
    }
    if (!model) {
        [self showError:@"请先选择品牌型号哦~亲！"];
        return;
    }
    if (!goods || !priceId) {
        [self showError:@"请先选择商品规格哦~亲！"];
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
