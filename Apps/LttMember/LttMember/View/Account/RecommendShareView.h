//
//  RecommendShareView.h
//  LttMember
//
//  Created by wuyong on 15/12/1.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol RecommendShareViewDelegate <NSObject>

- (void)actionRecommend;
- (void)actionShare;

@end

@interface RecommendShareView : AppTableView

@property (retain, nonatomic) id<RecommendShareViewDelegate> delegate;

@end
