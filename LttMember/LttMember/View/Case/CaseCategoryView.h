//
//  CaseCategoryView.h
//  LttMember
//
//  Created by wuyong on 15/10/22.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppCollectionView.h"
#import "CategoryEntity.h"

@protocol CaseCategoryViewDelegate <NSObject>

@required

- (void)actionSelected:(NSArray *)categories;

@end

@interface CaseCategoryView : AppCollectionView

@property (retain, nonatomic) id<CaseCategoryViewDelegate> delegate;

@end
