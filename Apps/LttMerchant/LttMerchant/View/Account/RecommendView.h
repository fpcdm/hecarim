//
//  RecommendView.h
//  LttMerchant
//
//  Created by 杨海锋 on 16/2/18.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol RecommendViewDelegate <NSObject>

- (void)actionRecommend:(NSString *)recommendMobile;

@end

@interface RecommendView : AppView

@property (retain, nonatomic) id<RecommendViewDelegate>delegate;

- (void)hideKeyboard;

@end
