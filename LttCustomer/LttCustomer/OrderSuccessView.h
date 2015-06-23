//
//  OrderSuccessView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol OrderSuccessViewDelegate <NSObject>

- (void)actionHome;

@end

@interface OrderSuccessView : AppView

@property (retain,nonatomic) id<OrderSuccessViewDelegate> delegate;

@end
