//
//  GoodsListView.h
//  LttMerchant
//
//  Created by wuyong on 15/8/12.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol GoodsListViewDelegate <NSObject>

@end

@interface GoodsListView : AppTableView

@property (retain, nonatomic) id<GoodsListViewDelegate> delegate;

@end
