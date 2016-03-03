//
//  BusinessListView.h
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "AppTableView.h"
#import "BusinessEntity.h"

@protocol BusinessListViewDelegate <NSObject>

- (void)actionLoadMore;

- (void)actionDetail:(BusinessEntity *)business;

@end

@interface BusinessListView : AppTableView

@property(retain, nonatomic) id<BusinessListViewDelegate>delegate;

@end
