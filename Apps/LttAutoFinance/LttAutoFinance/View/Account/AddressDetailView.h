//
//  AddressDetailView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol AddressDetailViewDelegate <NSObject>

@required
- (void) actionDelete;

- (void) actionDefault;

@end

@interface AddressDetailView : AppTableView

@property (retain, nonatomic) id<AddressDetailViewDelegate> delegate;

@end
