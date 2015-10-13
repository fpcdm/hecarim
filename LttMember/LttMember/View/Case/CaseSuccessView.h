//
//  OrderSuccessView.h
//  LttMember
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CaseSuccessViewDelegate <NSObject>

- (void)actionHome;

@end

@interface CaseSuccessView : AppView

@property (retain,nonatomic) id<CaseSuccessViewDelegate> delegate;

@end
