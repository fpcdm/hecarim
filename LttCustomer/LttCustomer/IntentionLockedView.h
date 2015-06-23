//
//  IntentionLockedView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/19.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol IntentionLockedViewDelegate <NSObject>

- (void)actionMobile;

@end

@interface IntentionLockedView : AppView

@property (retain, nonatomic) id<IntentionLockedViewDelegate> delegate;

@end
