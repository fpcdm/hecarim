//
//  OrderReceivedView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol OrderReceivedViewDelegate <NSObject>

- (void)actionComment:(int)value;

@end

@interface OrderReceivedView : AppView

@property (retain, nonatomic) id<OrderReceivedViewDelegate> delegate;

@end
