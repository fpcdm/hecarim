//
//  IntentionHandler.h
//  LttMember
//
//  Created by wuyong on 15/5/22.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseHandler.h"
#import "CaseEntity.h"
#import "CategoryEntity.h"
#import "PropertyEntity.h"

@interface CaseHandler : BaseHandler

//需求分类列表
- (void) queryCategories: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//需求类型列表
- (void) queryTypes: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

//保存分类列表
- (void) saveCategories: (NSArray *) categories success: (SuccessBlock) success failure: (FailedBlock) failure;

//保存需求类型
- (void) saveTypes: (NSNumber *) categoryId types: (NSArray *) types success: (SuccessBlock) success failure: (FailedBlock) failure;

//需求属性列表
- (void) queryProperties: (CategoryEntity *) type success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) addIntention: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryIntention: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) queryIntentions: (NSDictionary *) param success: (SuccessBlock) success failure: (FailedBlock) failure;

- (void) cancelIntention: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

//提交评价
- (void) addIntentionEvaluation: (CaseEntity *) intention success: (SuccessBlock) success failure: (FailedBlock) failure;

@end
