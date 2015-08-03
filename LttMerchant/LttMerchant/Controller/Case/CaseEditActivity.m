//
//  CaseEditActivity.m
//  LttMerchant
//
//  Created by wuyong on 15/7/31.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseEditActivity.h"
#import "UITextView+Placeholder.h"

@interface CaseEditActivity ()

@property (nonatomic, strong) UITextView *caseRemark;

@end

@implementation CaseEditActivity

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

- (NSString *) templateName
{
    return @"caseEdit.html";
}

#pragma mark - View
- (void)onTemplateLoaded
{
    //添加备注
    self.caseRemark.placeholder = @"备注";
}

#pragma mark - reloadData
- (void) reloadData
{
    [super reloadData];
    
    self.viewStorage[@"form"] = @{
                                  @"remark": @""
                                  };
    
    //重新布局
    [self relayout];
}

#pragma mark - Action
- (void) actionSave: (SamuraiSignal *)signal
{
    NSString *remark = self.caseRemark.text;
    if (!remark || [remark length] < 1) {
        [self showError:@"请填写服务单备注哦~亲！"];
        return;
    }
    
    //todo: 保存备注
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
