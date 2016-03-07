//
//  BusinessListView.h
//  LttMember
//
//  Created by wuyong on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "AppTableView.h"
#import "BusinessEntity.h"

@protocol BusinessListViewDelegate <NSObject>

- (void)actionLoad:(UITableView *)tableView;
- (void)actionDetail:(BusinessEntity *)business;

@end

@interface BusinessListView : AppTableView

@property (retain, nonatomic) id<BusinessListViewDelegate> delegate;

@end