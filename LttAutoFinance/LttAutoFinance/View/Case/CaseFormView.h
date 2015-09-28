//
//  CaseFormView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/7/14.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol CaseFormViewDelegate <NSObject>

- (void) actionAddress;
- (void) actionProperty;
- (void) actionSubmit: (NSString *) remark;

@end

@interface CaseFormView : AppTableView

@property (retain, nonatomic) id<CaseFormViewDelegate> delegate;

//是否含有属性框
- (void) setPropertyEnabled:(BOOL) enabled;

@end
