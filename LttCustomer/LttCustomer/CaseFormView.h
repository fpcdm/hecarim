//
//  CaseFormView.h
//  LttCustomer
//
//  Created by wuyong on 15/7/14.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CaseFormViewDelegate <NSObject>

- (void) actionSubmit: (NSString *) remark;

@end

@interface CaseFormView : AppView

@property (retain, nonatomic) id<CaseFormViewDelegate> delegate;

@end
