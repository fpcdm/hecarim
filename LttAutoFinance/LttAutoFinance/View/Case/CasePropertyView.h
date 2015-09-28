//
//  CasePropertyView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/9/28.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppCollectionView.h"
#import "PropertyEntity.h"

@protocol CasePropertyViewDelegate <NSObject>

@required

- (void)actionSelected:(PropertyEntity *)property;

@end

@interface CasePropertyView : AppCollectionView

@property (retain, nonatomic) id<CasePropertyViewDelegate> delegate;

@end
