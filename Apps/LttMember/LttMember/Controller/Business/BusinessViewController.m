//
//  BusinessViewController.m
//  LttMember
//
//  Created by wuyong on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessViewController.h"
#import "BusinessView.h"
#import "BusinessEntity.h"
#import "BusinessHandler.h"

@interface BusinessViewController () <BusinessViewDelegate>

@end

@implementation BusinessViewController
{
    BusinessView *businessView;
    BusinessEntity *business;
}

- (void)loadView
{
    businessView = [[BusinessView alloc] init];
    businessView.delegate = self;
    self.view = businessView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"详情";
    
    [self showLoading:[FWLocale system:@"Loading.Start"]];
    [self loadData:^(id object) {
        [self hideLoading];
        
        [businessView assign:@"business" value:business];
        [businessView display];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

//加载微商数据
- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    BusinessEntity *businessEntity = [[BusinessEntity alloc] init];
    businessEntity.id = self.businessId;
    
    BusinessHandler *businessHandler = [[BusinessHandler alloc] init];
    [businessHandler queryBusiness:businessEntity success:^(NSArray *result) {
        business = [result firstObject];
        
        success(nil);
    } failure:^(ErrorEntity *error) {
        failure(error);
    }];
}

#pragma mark - Action
- (void)actionBusiness
{
    
}

- (void)actionPreview:(NSUInteger)index
{
    NSLog(@"preview: %ld", index);
}

@end
