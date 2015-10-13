//
//  OrderReceivedView.h
//  LttMember
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CasePayedViewDelegate <NSObject>

- (void)actionComment:(int)value;

@end

@interface CasePayedView : AppView

@property (retain, nonatomic) id<CasePayedViewDelegate> delegate;

@end
