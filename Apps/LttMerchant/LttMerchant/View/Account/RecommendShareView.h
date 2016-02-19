//
//  RecommendShareView.h
//  LttMerchant
//
//  Created by 杨海锋 on 16/2/18.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol RecommendShareViewDelegate <NSObject>

- (void)actionRecommend;

- (void)actionMerchant;

- (void)actionShare;

@end

@interface RecommendShareView : AppTableView

@property (retain, nonatomic) id<RecommendShareViewDelegate>delegate;

@end
