//
//  RegisterExistView.h
//  LttMember
//
//  Created by wuyong on 15/7/7.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol RegisterExistViewDelegate <NSObject>

- (void) actionLogin;

@end

@interface RegisterExistView : AppView

@property (retain, nonatomic) id<RegisterExistViewDelegate> delegate;

@end
