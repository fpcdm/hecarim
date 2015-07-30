//
//  OrderFormViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/4/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "OrderFormViewController.h"
#import "BrandEntity.h"
#import "CategoryEntity.h"
#import "ModelEntity.h"
#import "IntentionEntity.h"
#import "OrderEntity.h"
#import "IntentionHandler.h"
#import "GoodsHandler.h"
#import "OrderHandler.h"

@interface OrderFormViewController ()

@end

@implementation OrderFormViewController
{
    NSArray *brandList;
    NSArray *modelList;
    NSArray *goodsList;
    GoodsEntity *goodsItem;
    
    NSNumber *categoryId;
    NSNumber *goodsId;
    NSNumber *priceId;
    NSNumber *price;
    
    //暂时只支持一个商品
    IntentionEntity *intention;
    OrderEntity *order;
    GoodsEntity *orderGoods;
}

@synthesize scrollView;

@synthesize brandSegment, modelSegment, specLabel1, specSegment1, specLabel2, specSegment2, specLabel3, specSegment3, priceLabel, numberField, amountLabel, modelEmptyLabel, specEmptyLabel;

@synthesize mobileServiceName, mobileServicePrice, computerServiceName, computerServicePrice;

@synthesize intentionId;

@synthesize orderNo;

- (void)viewDidLoad {
    [self.scrollView contentSizeToFit];
    
    [super viewDidLoad];
    
    if (self.orderNo != nil) {
        self.title = @"修改订单";
    } else {
        self.title = @"新建订单";
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //初始化view
    [self initView];
}

- (void) viewDidUnload
{
    [self setScrollView:nil];
    
    [super viewDidUnload];
}

- (void) initView
{
    //隐藏选项
    self.brandSegment.hidden = YES;
    self.modelSegment.hidden = YES;
    self.modelEmptyLabel.hidden = NO;
    [self clearSpecs];
    
    //新建订单
    if (self.intentionId != nil) {
        [self initIntention];
    //修改订单
    } else if (self.orderNo != nil) {
        [self initOrder];
    //参数不正确
    } else {
        [self showError:LocalString(@"ERROR_PARAM_REQUIRED")];
        return;
    }
}

- (void) clearSpecs
{
    self.specEmptyLabel.hidden = NO;
    self.specLabel1.hidden = YES;
    self.specLabel2.hidden = YES;
    self.specLabel3.hidden = YES;
    self.specSegment1.hidden = YES;
    self.specSegment2.hidden = YES;
    self.specSegment3.hidden = YES;
    self.priceLabel.text = @"0";
    self.amountLabel.text = @"0";
    goodsId = nil;
    priceId = nil;
}

//初始化需求
- (void) initIntention
{
    [self showLoading:LocalString(@"TIP_LOADING_MESSAGE")];
    
    IntentionEntity *intentionModel = [[IntentionEntity alloc] init];
    intentionModel.id = self.intentionId;
    
    //调用接口
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    [intentionHandler queryIntention:intentionModel success:^(NSArray *result){
        [self hideLoading];
        
        intention = [result firstObject];
        categoryId = LTT_CATEGORY_MOBILE;
        
        [self initData];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        [self showError:error.message];
    }];
}

//初始化订单
- (void) initOrder
{
    [self showLoading:LocalString(@"TIP_LOADING_MESSAGE")];
    
    OrderEntity *orderModel = [[OrderEntity alloc] init];
    orderModel.no = self.orderNo;
    
    //调用接口
    OrderHandler *orderHandler = [[OrderHandler alloc] init];
    [orderHandler queryOrder:orderModel success:^(NSArray *result){
        [self hideLoading];
        
        order = [result firstObject];
        
        //获取商品（目前只支持第一个商品）
        NSDictionary *goodsDict = [order.goods objectAtIndex:0];
        if (goodsDict) {
            orderGoods = [[GoodsEntity alloc] init];
            orderGoods.categoryId = [goodsDict objectForKey:@"category_id"];
            orderGoods.brandId = [goodsDict objectForKey:@"brand_id"];
            orderGoods.modelId = [goodsDict objectForKey:@"model_id"];
            orderGoods.priceId = [goodsDict objectForKey:@"price_id"];
            orderGoods.id = [goodsDict objectForKey:@"goods_id"];
            orderGoods.name = [goodsDict objectForKey:@"goods_name"];
            orderGoods.number = [goodsDict objectForKey:@"goods_num"];
            orderGoods.price = [goodsDict objectForKey:@"goods_price"];
            
            categoryId = orderGoods.categoryId;
        }
        
        [self initData];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        [self showError:error.message];
    }];
}

//加载数据
- (void) initData
{
    [self showLoading:LocalString(@"TIP_LOADING_MESSAGE")];
    
    //重置品牌和型号
    self.brandSegment.selectedSegmentIndex = -1;
    self.brandSegment.hidden = YES;
    self.modelSegment.selectedSegmentIndex = -1;
    self.modelSegment.hidden = YES;
    
    //绑定事件
    [self.brandSegment addTarget:self action:@selector(brandSegmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.modelSegment addTarget:self action:@selector(modelSegmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.specSegment1 addTarget:self action:@selector(specSegmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.specSegment2 addTarget:self action:@selector(specSegmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.specSegment3 addTarget:self action:@selector(specSegmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.numberField addTarget:self action:@selector(numberFieldAction:) forControlEvents:UIControlEventEditingChanged];
    
    //获取品牌列表
    CategoryEntity *categoryModel = [[CategoryEntity alloc] init];
    categoryModel.id = categoryId;
    
    GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
    [goodsHandler queryCategoryBrands:categoryModel success:^(NSArray *result){
        [self hideLoading];
        
        brandList = result;
        [self initBrand];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        [self showError:error.message];
    }];
}

- (void) initBrand
{
    //重绘品牌
    self.brandSegment.selectedSegmentIndex = -1;
    [self.brandSegment removeAllSegments];
    
    NSInteger i = 0;
    for (BrandEntity *brand in brandList) {
        [self.brandSegment insertSegmentWithTitle:brand.name atIndex:i animated:NO];
        
        //修改订单
        if (orderGoods && [orderGoods.brandId isEqualToNumber:brand.id]) {
            self.brandSegment.selectedSegmentIndex = i;
            [self brandSegmentAction:self.brandSegment];
        }
        
        i++;
    }
    
    self.brandSegment.hidden = NO;
}

- (void) initModel
{
    //重绘型号
    self.modelSegment.selectedSegmentIndex = -1;
    [self.modelSegment removeAllSegments];
    
    //无数据
    if (modelList == nil || [modelList count] < 1) {
        self.modelSegment.hidden = YES;
        self.modelEmptyLabel.text = @"暂无型号";
        self.modelEmptyLabel.hidden = NO;
    //有数据
    } else {
        self.modelEmptyLabel.text = @"请先选择品牌";
        self.modelEmptyLabel.hidden = YES;
        
        NSInteger i = 0;
        for (ModelEntity *model in modelList) {
            [self.modelSegment insertSegmentWithTitle:model.name atIndex:i animated:NO];
            
            //修改订单
            if (orderGoods && [orderGoods.modelId isEqualToNumber:model.id]) {
                self.modelSegment.selectedSegmentIndex = i;
                [self modelSegmentAction:self.modelSegment];
            }
            
            i++;
        }
        self.modelSegment.hidden = NO;
    }
    
    //清空规格
    [self clearSpecs];
}

//初始化商品列表
- (void) initGoods
{
    [self clearSpecs];
    
    if (goodsList == nil || [goodsList count] < 1) {
        self.specEmptyLabel.text = @"该型号暂无商品";
        self.specEmptyLabel.hidden = NO;
        return;
    }
    
    //只支持一个商品
    goodsItem = [goodsList objectAtIndex:0];
    if (goodsItem.specList == nil || [goodsItem.specList count] < 1) {
        self.specEmptyLabel.text = @"该型号暂无商品";
        self.specEmptyLabel.hidden = NO;
        return;
    }
    
    self.specEmptyLabel.text = @"请先选择型号";
    self.specEmptyLabel.hidden = YES;
    
    //初始化商品规格
    [self initSpec];
}

//初始化规格
- (void) initSpec
{
    NSArray *specList = goodsItem.specList;
    
    //修改订单
    NSString *specIds = @",,";
    NSArray *priceList = goodsItem.priceList;
    if (orderGoods) {
        for (NSDictionary *subPrice in priceList) {
            if ([orderGoods.priceId isEqualToNumber:[subPrice objectForKey:@"price_id"]]) {
                specIds = [subPrice objectForKey:@"spec_ids"];
                break;
            }
        }
    }
    //按逗号拆分
    NSArray *specComps = [specIds componentsSeparatedByString:@","];
    NSInteger specCount = [specList count];
    
    //规格1
    NSDictionary *specItem1 = [specList objectAtIndex:0];
    [self showSpec:specItem1 withLabel:specLabel1 withSegment:specSegment1 specId:[specComps objectAtIndex:0]];
    
    //规格2
    if (specCount > 1) {
        NSDictionary *specItem2 = [specList objectAtIndex:1];
        [self showSpec:specItem2 withLabel:specLabel2 withSegment:specSegment2 specId:[specComps objectAtIndex:1]];
    }
    
    //规格3
    if (specCount > 2) {
        NSDictionary *specItem3 = [specList objectAtIndex:2];
        [self showSpec:specItem3 withLabel:specLabel3 withSegment:specSegment3 specId:[specComps objectAtIndex:2]];
    }
    
    self.priceLabel.text = @"0";
    self.amountLabel.text = @"0";
    goodsId = nil;
    priceId = nil;
    
    //修改订单
    if (orderGoods) {
        //数量
        numberField.text = [orderGoods.number stringValue];
        
        [self specSegmentAction:specSegment1];
    }
}

//显示某一个规格
- (void) showSpec: (NSDictionary *) specItem withLabel: (UILabel *) label withSegment: (UISegmentedControl *) segment specId: (id) specId
{
    if (!specItem) return;
    
    label.text = [specItem objectForKey:@"spec_name"];
    label.hidden = NO;
    
    segment.selectedSegmentIndex = -1;
    [segment removeAllSegments];
    NSArray *subSpecs = [specItem objectForKey:@"list"];
    NSInteger i = 0;
    for (NSDictionary *subSpec in subSpecs) {
        [segment insertSegmentWithTitle:[subSpec objectForKey:@"spec_name"] atIndex:i animated:NO];

        //选中
        if (specId && [specId length] > 0 && [specId isEqualToString:[[subSpec objectForKey:@"spec_id"] stringValue]]) {
            segment.selectedSegmentIndex = i;
        }
        
        i++;
    }
    segment.hidden = NO;
}

#pragma mark - Actions
- (void) brandSegmentAction: (UISegmentedControl *) segment
{
    NSInteger selected = segment.selectedSegmentIndex;
    BrandEntity *brandModel = [brandList objectAtIndex:selected];
    NSDictionary *param = @{@"category_id": categoryId};
    
    //获取型号列表
    GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
    [goodsHandler queryBrandModels:brandModel param:param success:^(NSArray *result){
        modelList = result;
        [self initModel];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void) modelSegmentAction: (UISegmentedControl *) segment
{
    NSInteger selected = segment.selectedSegmentIndex;
    ModelEntity *modelModel = [modelList objectAtIndex:selected];
    
    //获取型号列表
    GoodsHandler *goodsHandler = [[GoodsHandler alloc] init];
    [goodsHandler queryModelGoods:modelModel success:^(NSArray *result){
        goodsList = result;
        [self initGoods];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void) specSegmentAction: (UISegmentedControl *) segment
{
    //获取当前的选择
    NSString *specIds = @"";
    
    NSArray *specList = goodsItem.specList;
    NSInteger specCount = [specList count];
    
    NSDictionary *specItem1 = [specList objectAtIndex:0];
    if (specItem1) {
        NSArray *subSpecs = [specItem1 objectForKey:@"list"];
        if (specSegment1.selectedSegmentIndex >= 0) {
            NSDictionary *subSpec = [subSpecs objectAtIndex:specSegment1.selectedSegmentIndex];
            specIds = [specIds stringByAppendingString:[[subSpec objectForKey:@"spec_id"] stringValue]];
        }
        specIds = [specIds stringByAppendingString:@","];
    }
    
    if (specCount > 1) {
        NSDictionary *specItem2 = [specList objectAtIndex:1];
        if (specItem2) {
            NSArray *subSpecs = [specItem2 objectForKey:@"list"];
            if (specSegment2.selectedSegmentIndex >= 0) {
                NSDictionary *subSpec = [subSpecs objectAtIndex:specSegment2.selectedSegmentIndex];
                specIds = [specIds stringByAppendingString:[[subSpec objectForKey:@"spec_id"] stringValue]];
            }
            if (specCount > 2) {
                specIds = [specIds stringByAppendingString:@","];
            }
        }
    }
    
    if (specCount > 2) {
        NSDictionary *specItem3 = [specList objectAtIndex:2];
        if (specItem3) {
            NSArray *subSpecs = [specItem3 objectForKey:@"list"];
            if (specSegment3.selectedSegmentIndex >= 0) {
                NSDictionary *subSpec = [subSpecs objectAtIndex:specSegment3.selectedSegmentIndex];
                specIds = [specIds stringByAppendingString:[[subSpec objectForKey:@"spec_id"] stringValue]];
            }
        }
    }
    
    //根据选择获取price_id
    NSArray *priceList = goodsItem.priceList;
    NSDictionary *priceItem = nil;
    if (priceList) {
        for (NSDictionary *subPrice in priceList) {
            if ([specIds isEqualToString:[subPrice objectForKey:@"spec_ids"]]) {
                priceItem = subPrice;
                break;
            }
        }
    }
    
    //切换价格
    if (priceItem) {
        goodsId = goodsItem.id;
        priceId = (NSNumber *) [priceItem objectForKey:@"price_id"];
        price = [priceItem objectForKey:@"goods_price"];
        
        priceLabel.text = [price stringValue];
        NSString *number = numberField.text;
        if ([ValidateUtil isPositiveInteger:number]) {
            NSNumber *total = [NSNumber numberWithDouble:([price doubleValue] * [number doubleValue])];
            amountLabel.text = [total stringValue];
        } else {
            amountLabel.text = @"0";
        }
    } else {
        goodsId = nil;
        priceId = nil;
        price = nil;
        
        priceLabel.text = @"0";
        amountLabel.text = @"0";
    }
}

- (void) numberFieldAction: (UITextField *) sender
{
    //是否格式合法
    if (![ValidateUtil isPositiveInteger:sender.text]) {
        sender.text = @"";
        amountLabel.text = @"0";
        return;
    }
    
    //价格是否设置
    if (!price) {
        amountLabel.text = @"0";
    } else {
        NSNumber *total = [NSNumber numberWithDouble:([price doubleValue] * [sender.text doubleValue])];
        amountLabel.text = [total stringValue];
    }
}

- (IBAction)orderSubmitAction:(id)sender {
    //参数检查
    if (goodsId == nil || priceId == nil || price == nil) {
        [self showError:@"请先选择商品参数"];
        return;
    }
    if (![ValidateUtil isPositiveInteger:numberField.text]) {
        [self showError:@"请填写商品数量"];
        return;
    }
    
    NSNumber *number = [NSNumber numberWithInteger:[numberField.text integerValue]];
    
    NSNumber *goodsAmount = @0;
    NSNumber *servicesAmount = @0;
    
    //收集参数
    OrderEntity *postOrder = [[OrderEntity alloc] init];
    goodsAmount = [NSNumber numberWithDouble:([price doubleValue] * [number doubleValue])];
    postOrder.buyerAddress = @"";
    
    //只添加一个商品
    NSMutableDictionary *goodsParam = [[NSMutableDictionary alloc] init];
    //添加商品：为了解决nsarray不传key的问题，使用nsdictionary
    NSDictionary *goodsDict = @{@"goods_id":goodsId, @"goods_num":number,@"goods_price":price,@"price_id":priceId};
    [goodsParam setObject:goodsDict forKey:@"0"];
    postOrder.goodsParam = @{@"amount":goodsAmount, @"list":goodsParam};
    
    //添加服务
    NSDictionary *servicesParam = [[NSDictionary alloc] init];
    //手机上门，仅支持一个
    if ([mobileServiceName.text length] > 0 && [mobileServicePrice.text length] > 0) {
        if (![ValidateUtil isPositiveInteger:mobileServicePrice.text]) {
            [self showError:@"手机上门价格不正确"];
            return;
        }
        
        NSNumber *mobileAmount = [NSNumber numberWithInteger:[mobileServicePrice.text integerValue]];
        servicesAmount = [NSNumber numberWithDouble:([servicesAmount doubleValue] + [mobileAmount doubleValue])];
        NSDictionary *mobileService = @{
                                        @"amount": mobileAmount,
                                        @"type": [NSNumber numberWithInt:LTT_TYPE_MOBILEDOOR],
                                        @"list": @{
                                                @"0":@{
                                                    @"detail": mobileServiceName.text,
                                                    @"price": mobileAmount,
                                                    },
                                                },
                                        };
        servicesParam = mobileService;
    }
    postOrder.servicesParam = servicesParam;
    
    //价格
    NSNumber *totalAmount = [NSNumber numberWithDouble:([goodsAmount doubleValue] + [servicesAmount doubleValue])];
    postOrder.amount = totalAmount;
    
    //获取UserModel
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    
    //新建订单
    if (intention != nil || self.orderNo == nil) {
        postOrder.buyerId = intention.userId;
        postOrder.buyerMobile = intention.userMobile;
        postOrder.sellerId = user.id;
        postOrder.sellerMobile = user.mobile;
        postOrder.intentionId = self.intentionId;
    //编辑订单
    } else {
        postOrder.buyerMobile = order.buyerMobile;
        postOrder.sellerMobile = user.mobile;
    }
    
    
    NSLog(@"order: %@", [postOrder toDictionary]);
    
    //调接口
    [self showLoading:LocalString(@"TIP_REQUEST_MESSAGE")];
    
    //新建
    if (intention != nil || self.orderNo == nil) {
        OrderHandler *orderHandler = [[OrderHandler alloc] init];
        [orderHandler addOrder:postOrder success:^(NSArray *result){
            [self loadingSuccess:LocalString(@"TIP_REQUEST_SUCCESS")];
            
            OrderEntity *resOrder = [result firstObject];
            [self performSelector:@selector(success:) withObject:resOrder afterDelay:1];
        } failure:^(ErrorEntity *error){
            [self hideLoading];
            
            [self showError:error.message];
        }];
    } else {
        postOrder.no = order.no;
        
        OrderHandler *orderHandler = [[OrderHandler alloc] init];
        [orderHandler updateOrder:postOrder success:^(NSArray *result){
            [self loadingSuccess:LocalString(@"TIP_REQUEST_SUCCESS")];
            
            [self performSelector:@selector(success:) withObject:order afterDelay:1];
        } failure:^(ErrorEntity *error){
            [self hideLoading];
            
            [self showError:error.message];
        }];
        
    }
}

- (void) success: (OrderEntity *) resOrder
{
    [self hideLoading];
    
    if (self.callbackBlock) {
        self.callbackBlock(nil);
    }
    
    //跳转订单详情
    [self.navigationController popViewControllerAnimated:YES];
}

@end
