//
//  CaseBaseActivity.h
//  LttMerchant
//
//  Created by wuyong on 15/8/3.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppActivity.h"
#import "CaseHandler.h"
#import "CaseEntity.h"

@interface CaseBaseActivity : AppActivity

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

@end
