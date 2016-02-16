//
//  BaseCollectionView.h
//  LttAutoFinance
//
//  Created by wuyong on 15/9/28.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BaseView.h"

@interface BaseCollectionView : BaseView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (retain, nonatomic) UICollectionView *collectionView;

@property (retain, nonatomic) NSMutableArray *collectionData;

//加载主CollectionView
- (UICollectionView *)loadCollectionView;

//加载可重用CollectionViewCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView loadReuseCollectionViewCell:(NSIndexPath *)indexPath;

//获取CollectionViewCell数据
- (NSDictionary *)collectionView:(UICollectionView *)collectionView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath;

//自定义CollectionViewCell视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UICollectionViewCell *)cell;

@end
