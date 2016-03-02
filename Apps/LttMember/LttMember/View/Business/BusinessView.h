//
//  BusinessView.h
//  LttMember
//
//  Created by wuyong on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol BusinessViewDelegate <NSObject>

@end

@interface BusinessView : AppTableView

@property (retain, nonatomic) id<BusinessViewDelegate> delegate;

@end
