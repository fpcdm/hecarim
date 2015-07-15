//
//  CaseConfirmedView.h
//  LttCustomer
//
//  Created by wuyong on 15/7/15.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CaseConfirmedViewDelegate <NSObject>

- (void) actionMobile;
- (void) actionComplain;

@end

@interface CaseConfirmedView : AppView

@property (retain, nonatomic) id<CaseConfirmedViewDelegate> delegate;

@end
