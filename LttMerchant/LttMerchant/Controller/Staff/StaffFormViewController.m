//
//  StaffFormViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/29.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "StaffFormViewController.h"
#import "StaffFormView.h"
#import "ValidateUtil.h"
#import "StaffHandler.h"


@interface StaffFormViewController ()<StaffFormViewDelegate>

@end

@implementation StaffFormViewController
{
    StaffFormView *formView;
    StaffEntity *staffEntity;
}

@synthesize staffId;

- (void)loadView
{
    formView = [[StaffFormView alloc] init];
    formView.delegate = self;
    self.view = formView;
}

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    if (staffId == nil) {
        self.navigationItem.title = @"添加员工信息";
    } else {
        self.navigationItem.title = @"编辑员工信息";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (staffId) {
        [self showLoading:TIP_LOADING_MESSAGE];
        
        staffEntity = [[StaffEntity alloc] init];
        staffEntity.id = staffId;
        
        StaffHandler *staffHandler = [[StaffHandler alloc] init];
        [staffHandler staffDetail:staffEntity param:nil success:^(NSArray *result) {
            [self loadingSuccess:TIP_LOADING_SUCCESS callback:^{
                staffEntity = [result firstObject];
                
                [formView setData:@"staff" value:staffEntity];
                [formView renderData];
            }];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    }
}

- (void)actionSave:(StaffEntity *)staff
{
    if (![ValidateUtil isRequired:staff.no]) {
        [self showError:@"编号不能为空！"];
        return;
    }
    if (![ValidateUtil isRequired:staff.name]) {
        [self showError:@"姓名不能为空！"];
        return;
    }
    if (![ValidateUtil isRequired:staff.nickname]) {
        [self showError:@"昵称不能为空！"];
        return;
    }
    if (![ValidateUtil isRequired:staff.mobile]) {
        [self showError:@"电话号码不能为空！"];
        return;
    }
    if (![ValidateUtil isMobile:staff.mobile]) {
        [self showError:@"电话号码格式不正确！"];
        return;
    }

    [self showLoading:TIP_REQUEST_MESSAGE];
    
    StaffHandler *staffHandler = [[StaffHandler alloc] init];
    
    NSDictionary *param = @{
                            @"code" : staff.no,
                            @"truename" : staff.name,
                            @"nickname" : staff.nickname,
                            @"mobile" : staff.mobile
                            };
    
    //新增
    if (!staffId || [staffId intValue] < 1) {
        [staffHandler addStaff:param success:^(NSArray *result) {
            [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    //编辑
    } else {
        [staffHandler editStaff:staffEntity param:param success:^(NSArray *result) {
            [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    }
    
}

@end
