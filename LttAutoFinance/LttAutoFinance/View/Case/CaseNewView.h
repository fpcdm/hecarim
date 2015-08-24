//
//  IntentionNewView.h
//  LttAutoFInance
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CaseNewViewDelegate <NSObject>

- (void)actionCancel;

@end

@interface CaseNewView : AppView

@property (retain, nonatomic) id<CaseNewViewDelegate> delegate;

@property (retain, nonatomic) UILabel *timerLabel;

@end
