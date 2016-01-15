//
//  CaseDetailView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/8/13.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol CaseDetailViewDelegate <NSObject>

- (void)actionContactBuyer;

@end

@interface CaseDetailView : AppTableView

@property (retain,nonatomic) id<CaseDetailViewDelegate> delegate;

@end
