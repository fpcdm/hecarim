//
//  RegisterMobileView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol RegisterMobileViewDelegate <NSObject>

- (void) actionCheckMobile:(NSString *)mobile;

@end

@interface RegisterMobileView : AppView

@property (retain, nonatomic) id<RegisterMobileViewDelegate> delegate;

@end
