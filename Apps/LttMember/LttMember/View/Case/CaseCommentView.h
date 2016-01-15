//
//  OrderReceivedView.h
//  LttMember
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol CaseCommentViewDelegate <NSObject>

- (void)actionComment:(int)value;

@end

@interface CaseCommentView : AppView

@property (retain, nonatomic) id<CaseCommentViewDelegate> delegate;

@end
