//
//  IntentionLockedView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CaseLockedViewDelegate <NSObject>

- (void)actionMobile;

@end

@interface CaseLockedView : AppView

@property (retain, nonatomic) id<CaseLockedViewDelegate> delegate;

@end
