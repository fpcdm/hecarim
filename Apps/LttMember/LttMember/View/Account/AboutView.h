//
//  AboutView.h
//  LttMember
//
//  Created by wuyong on 15/6/29.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol AboutViewDelegate <NSObject>

- (void)actionScore;

@end

@interface AboutView : AppTableView

@property (retain, nonatomic) id<AboutViewDelegate> delegate;

@end
