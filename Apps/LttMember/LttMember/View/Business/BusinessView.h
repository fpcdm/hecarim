//
//  BusinessView.h
//  LttMember
//
//  Created by wuyong on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "AppView.h"
#import "BaseScrollView.h"

@protocol BusinessViewDelegate <NSObject>

- (void)actionBusiness;

@end

@interface BusinessView : BaseScrollView

@property (retain, nonatomic) id<BusinessViewDelegate> delegate;

@end
