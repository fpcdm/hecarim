//
//  OrderNewView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol OrderNewViewDelegate <NSObject>

- (void)actionPay;

@end

@interface OrderNewView : AppView

@property (retain,nonatomic) id<OrderNewViewDelegate> delegate;

@end
