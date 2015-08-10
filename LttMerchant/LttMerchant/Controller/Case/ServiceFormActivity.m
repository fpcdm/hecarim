//
//  ServiceFormActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ServiceFormActivity.h"
#import "CategoryEntity.h"
#import "ServiceEntity.h"
#import "PickerUtil.h"
#import "GoodsHandler.h"
#import "CaseHandler.h"

@interface ServiceFormActivity ()

@end

@implementation ServiceFormActivity
{
    CategoryEntity *category;
}

@synthesize intention;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadCase];
}

- (NSString *)templateName
{
    return @"serviceForm.html";
}

#pragma mark - reloadData
- (void) reloadData
{
    [super reloadData];
    
    self.scope[@"category"] = @{
                                      @"name": category ? category.name : @"选择服务类别"
                                      };
    
    //重新布局
    [self relayout];
}

#pragma mark - Action
- (void) actionChooseCategory: (SamuraiSignal *) signal
{
    PickerUtil *pickerUtil = [[PickerUtil alloc] initWithTitle:nil grade:1 origin:signal.sourceView];
    
    pickerUtil.firstLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){
        CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
        categoryEntity.id = @0;
        categoryEntity.tradeId = [NSNumber numberWithInteger:LTT_TRADE_SERVICE];
        
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
    //参数检查
    if (!category) {
        [self showError:@"请先选择服务类别哦~亲！"];
        return;
    }
    //价格
    UITextField *priceField = (UITextField *) $(@"#priceField").firstView;
    NSString *priceStr = priceField.text;
    if (![ValidateUtil isRequired:priceStr]) {
        [self showError:@"请先填写价格哦~亲！"];
        return;
    }
    if (![ValidateUtil isPositiveNumber:priceStr]) {
        [self showError:@"价格填写不正确哦~亲！"];
        return;
    }
    
    //备注
    UITextField *remarkField = (UITextField *) $(@"#remarkField").firstView;
    NSString *remark = remarkField.text;
    if (![ValidateUtil isRequired:remark]) {
        [self showError:@"请先填写备注哦~亲！"];
        return;
    }
    
    //获取服务列表
    CaseEntity *postCase = [[CaseEntity alloc] init];
    postCase.id = self.caseId;
    
    BOOL isEdit = intention.services && [intention.services count] > 0 ? YES : NO;
    //获取之前的服务列表
    NSMutableArray *serviceList = [[NSMutableArray alloc] init];
    if (isEdit) {
        for (ServiceEntity *entity in intention.services) {
            [serviceList addObject:entity];
        }
    }
    
    //添加当前服务
    ServiceEntity *currentService = [[ServiceEntity alloc] init];
    currentService.typeId = category.id;
    currentService.typeName = category.name;
    currentService.name = remark;
    currentService.price = [NSNumber numberWithFloat:[priceStr floatValue]];
    [serviceList addObject:currentService];
    
    //转换数据
    postCase.services = serviceList;
    postCase.servicesParam = [postCase formatFormServices];
    postCase.services = nil;
    
    //提交数据
    [self showLoading:TIP_REQUEST_MESSAGE];
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    //新增
    if (!isEdit) {
        [caseHandler addCaseServices:postCase success:^(NSArray *result){
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
        [caseHandler editCaseServices:postCase success:^(NSArray *result){
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
