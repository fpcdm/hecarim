//
//  OrderNewView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CaseTopayViewDelegate <NSObject>

- (void)actionPay;

@end

@interface CaseTopayView : AppView

@property (retain,nonatomic) id<CaseTopayViewDelegate> delegate;

@end
