//
//  IntentionListView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"
#import "IntentionEntity.h"

@protocol CaseListViewDelegate <NSObject>

- (void)actionDetail:(IntentionEntity *)intention;

@end

@interface CaseListView : AppTableView

@property (retain, nonatomic) id<CaseListViewDelegate> delegate;

@end
