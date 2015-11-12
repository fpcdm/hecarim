//
//  AppCollectionView.m
//  LttMember
//
//  Created by wuyong on 15/9/28.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "AppCollectionView.h"

@implementation BaseCollectionView (App)

- (void) customCollectionView
{
    //全局背景色
    self.collectionView.backgroundColor = COLOR_MAIN_BG;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
}

@end

@implementation AppCollectionView

@end
