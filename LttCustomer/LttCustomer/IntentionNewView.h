//
//  IntentionNewView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol IntentionNewViewDelegate <NSObject>

- (void)actionCancel;

@end

@interface IntentionNewView : AppView

@property (retain, nonatomic) id<IntentionNewViewDelegate> delegate;

@property (retain, nonatomic) UILabel *timerLabel;

@end
