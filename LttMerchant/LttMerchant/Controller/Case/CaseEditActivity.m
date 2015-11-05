//
//  CaseEditActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseEditActivity.h"
#import "CaseEditView.h"

@interface CaseEditActivity ()<CaseEditViewDelegate>

@property (nonatomic, strong) UITextView *caseRemark;

@end

@implementation CaseEditActivity
{
    CaseEditView *caseEditView;
}

@synthesize intention;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    self.navigationItem.title = @"服务单编辑";
    
    caseEditView = [[CaseEditView alloc] init];
    caseEditView.delegate = self;
    
    self.view = caseEditView;
    self.view.backgroundColor = COLOR_MAIN_BG;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadCase];
}

#pragma mark - reloadData
- (void) reloadData
{
    //设置参数
    CaseEntity *caseEntity = [[CaseEntity alloc] init];
    caseEntity.no = self.intention.no;
    caseEntity.status = self.intention.status;
    caseEntity.createTime = self.intention.createTime;
    caseEntity.totalAmount = self.intention.totalAmount;
    [caseEditView setData:@"caseEntity" value:caseEntity];
    
    [caseEditView renderData];
}

#pragma mark - Action
- (void) actionSave: (NSString *)remark
{
    if (!remark || [remark length] < 1) {
        [self showError:@"请填写服务单备注哦~亲！"];
        return;
    }
    
    //todo: 保存备注
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
