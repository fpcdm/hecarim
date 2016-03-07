//
//  BusinessServicesListViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessServicesListViewController.h"
#import "BusinessServicesListView.h"
#import "BusinessHandler.h"
#import "ActionSheetPicker.h"


@interface BusinessServicesListViewController ()<BusinessServicesListViewDelegate>

@end

@implementation BusinessServicesListViewController
{
    BusinessServicesListView *listView;
    NSMutableArray *servicesList;
    NSMutableArray *childServicesList;
}


- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"绑定服务";
    
    //默认值
    servicesList = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    listView = [[BusinessServicesListView alloc] init];
    listView.delegate = self;
    self.view = listView;
    
    [self showLoading:[FWLocale system:@"Request.Start"]];
    
    BusinessHandler *businessHandler = [[BusinessHandler alloc] init];
    
    [businessHandler getUserServicesList:nil success:^(NSArray *result) {
        [self hideLoading];
        ResultEntity *resultEntity = [result firstObject];
        NSLog(@"服务列表：%@",resultEntity.data);
        for (NSDictionary *servicesDetail in resultEntity.data) {
            [servicesList addObject:servicesDetail];
        }
        [listView assign:@"servicesList" value:servicesList];
        [listView display];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];

}

- (void)actionSelectServices:(NSDictionary *)services
{
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:services];
    [muDic setObject:@0 forKey:@"propertyId"];
    FWDUMP(@"services:%@", muDic);
    //判断是否有下级服务
    
    NSDictionary *param = @{
                            @"page" : @"",
                            @"pagesize" : @""
                            };
    
    BusinessHandler *businessHandler = [[BusinessHandler alloc] init];
    [businessHandler selectChildBusiness:[services objectForKey:@"type_id"] param:param success:^(NSArray *result) {
        childServicesList = [NSMutableArray array];
        for (CaseEntity *caseEntity in result) {
            [childServicesList addObject:caseEntity];
        }
        FWDUMP(@"child services: %@", childServicesList);
        [listView assign:@"childService" value:childServicesList];
        
        //显示子服务
        if ([childServicesList count] > 0) {
            //地址选择器
            PickerUtil *pickerUtil = [[PickerUtil alloc] initWithTitle:nil grade:1 origin:listView];
            pickerUtil.firstLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){
                NSMutableArray *rows = [[NSMutableArray alloc] init];
                for (CaseEntity *child in childServicesList) {
                    [rows addObject:[PickerUtilRow rowWithName:child.propertyName ? child.propertyName : @"" value:child.propertyId]];
                }
                completionHandler(rows);
            };
            pickerUtil.resultBlock = ^(NSArray *selectedRows){
                PickerUtilRow *firstRow = [selectedRows objectAtIndex:0];
                NSLog(@"选择的地址：%@  服务是:%@", firstRow.value,firstRow.name);
                [muDic setValue:firstRow.value forKey:@"propertyId"];
                [muDic setValue:firstRow.name forKey:@"type_name"];
                
                if (self.callbackBlock) {
                    self.callbackBlock(muDic);
                }
                [self.navigationController popViewControllerAnimated:YES];
            };
            [pickerUtil show];
        } else {
            
            if (self.callbackBlock) {
                self.callbackBlock(muDic);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
    
}

@end
