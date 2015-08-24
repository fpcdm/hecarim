//
//  SafetyView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/6/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol SafetyViewDelegate <NSObject>

@required
- (void)actionPassword;

@end

@interface SafetyView : AppTableView

@property (retain, nonatomic) id<SafetyViewDelegate> delegate;

@end
