//
//  GoodsContainerView.h
//  LttMerchant
//
//  Created by 杨海锋 on 15/11/23.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol GoodsContainerViewDelegate <NSObject>


@end

@interface GoodsContainerView : AppTableView

@property (retain , nonatomic) id<GoodsContainerViewDelegate>delegate;

@end
