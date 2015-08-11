//
//  ServiceListView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol ServiceListViewDelegate <NSObject>

@end

@interface ServiceListView : AppTableView

@property (retain, nonatomic) id<ServiceListViewDelegate> delegate;

@end
