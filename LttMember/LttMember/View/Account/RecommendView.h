//
//  RecommendView.h
//  LttMember
//
//  Created by wuyong on 15/12/1.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol RecommendViewDelegate <NSObject>

- (void)actionRecommend: (NSString *)mobile;

@end

@interface RecommendView : AppView

@property (retain, nonatomic) id<RecommendViewDelegate> delegate;

@end
