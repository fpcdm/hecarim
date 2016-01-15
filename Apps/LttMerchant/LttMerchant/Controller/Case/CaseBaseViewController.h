//
//  CaseBaseViewController.h
//  LttMerchant
//
//  Created by wuyong on 15/8/3.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"
#import "CaseHandler.h"
#import "CaseEntity.h"

@interface CaseBaseViewController : AppViewController

@property (retain, nonatomic) NSNumber *caseId;

@property (retain, nonatomic) CaseEntity *intention;

//加载需求数据并重新渲染
- (void) loadCase;

//加载需求数据并执行回调
- (void) loadCase:(CallbackBlock)callback;

//子类重写，渲染数据
- (void) reloadData;

//渲染需求头数据
- (void) renderCaseData;

//默认错误处理，子类可重写
- (void) loadError:(ErrorEntity *)error;

@end
