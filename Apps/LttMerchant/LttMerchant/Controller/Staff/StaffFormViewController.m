//
//  StaffFormViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/29.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "StaffFormViewController.h"
#import "StaffFormView.h"
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
        [self showLoading:[LocaleUtil system:@"Loading.Start"]];
        
        staffEntity = [[StaffEntity alloc] init];
        staffEntity.id = staffId;
        
        StaffHandler *staffHandler = [[StaffHandler alloc] init];
        [staffHandler staffDetail:staffEntity param:nil success:^(NSArray *result) {
            [self hideLoading];
            
            staffEntity = [result firstObject];
                
            [formView assign:@"staff" value:staffEntity];
            [formView display];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    }
}

- (void)actionSave:(StaffEntity *)staff
{
    if (![ValidateUtil isRequired:staff.no]) {
        [self showError:[LocaleUtil error:@"StaffNo.Required"]];
        return;
    }
    if (![ValidateUtil isRequired:staff.name]) {
        [self showError:[LocaleUtil error:@"StaffName.Required"]];
        return;
    }
    if (![ValidateUtil isRequired:staff.nickname]) {
        [self showError:[LocaleUtil error:@"StaffNickname.Required"]];
        return;
    }
    if (![ValidateUtil isRequired:staff.mobile]) {
        [self showError:[LocaleUtil error:@"Mobile.Required"]];
        return;
    }
    if (![ValidateUtil isMobile:staff.mobile]) {
        [self showError:[LocaleUtil error:@"Mobile.Format"]];
        return;
    }

    [self showLoading:[LocaleUtil system:@"Request.Start"]];
    
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
            [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    //编辑
    } else {
        [staffHandler editStaff:staffEntity param:param success:^(NSArray *result) {
            [self loadingSuccess:[LocaleUtil system:@"Request.Success"] callback:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    }
    
}

@end
