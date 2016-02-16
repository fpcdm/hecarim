//
//  IntentionListView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"
#import "CaseEntity.h"

@protocol CaseListViewDelegate <NSObject>

- (void)actionLoadCase:(UIButton *)button status:(NSString *)status;
- (void)actionRefresh;
- (void)actionLoadMore;
- (void)actionDetail:(CaseEntity *)intention;

@end

@interface CaseListView : AppTableView

@property (retain, nonatomic) UIButton *defaultButton;

@property (retain, nonatomic) id<CaseListViewDelegate> delegate;

@end
