//
//  RecommendMerchantView.h
//  LttMerchant
//
//  Created by 杨海锋 on 16/2/18.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol RecommendMerchantDelegate <NSObject>

- (void)actionLoadMore;

@end

@interface RecommendMerchantView : AppTableView

@property (retain, nonatomic) id<RecommendMerchantDelegate>delegate;

@end
