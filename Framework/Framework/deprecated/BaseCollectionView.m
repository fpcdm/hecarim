//
//  BaseCollectionView.m
//  LttAutoFinance
//
//  Created by wuyong on 15/9/28.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "BaseCollectionView.h"

@interface BaseCollectionView ()

@end

@implementation BaseCollectionView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    /****************************************************************
     collectionData数据格式介绍：
     默认字段：id,type,view,action,width,height,data
     type取值: custom
     action说明：参数个数为1时，参数为cellData字典；为2时参数为collectionView和indexPath
     view说明：定义了view且type为custom时，使用该方法的返回值作为视图；参数个数为1时为cell,为2时为cell和cellData
     customCell说明：type为custom且未定义view或view参数不满足需求时，使用此方式
     自定义字段：可自定义字段，加入更多默认功能
     备注：没有值的字段可不配置，会自动忽略
     优化：可以将NSDictionry改为CollectionCellEntity之类的数据固定格式，从而简化访问
     
     self.collectionData = [[NSMutableArray alloc] initWithObjects:
     @[
     @{@"id" : @"info", @"index" : @0, @"type" : @"custom", @"view": @"", @"action": @"", @"data" : @"", @"height": @0, @"width": @0},
     ],
     @[
     @{@"id" : @"feedback", @"index" : @4, @"type" : @"custom", @"action": @"actionFeedback:", @"data" : @"", @"height": @0},
     @{@"id" : @"contact", @"index" : @5, @"type" : @"custom", @"action": @"actionContact", @"data" : @"400-820-5555", @"height": @0},
     ],
     nil];
     ****************************************************************/
    
    if (self.collectionData == nil) {
        self.collectionData = [NSMutableArray array];
    }
    
    //默认CollectionView
    self.collectionView = [self loadCollectionView];
    if (self.collectionView == nil) {
        //默认布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:SIZE_COLLECTION_CELL_DEFAULT];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = INSET_COLLECTION_SECTION_DEFAULT;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:[self bounds] collectionViewLayout:flowLayout];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_REUSE_IDENTIFIER_DEFAULT];
        self.collectionView.backgroundView = nil;
    }
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    
    UIView *superview = self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //自定义表格视图钩子，子类可以实现(不会影响别的子类)，也可以利用类分类实现(会影响别的子类)
    if ([self respondsToSelector:@selector(customCollectionView)]) {
        [self performSelector:@selector(customCollectionView)];
    }
    
    return self;
}

- (UICollectionView *)loadCollectionView
{
    return nil;
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.collectionData count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id sectionData = [self.collectionData objectAtIndex:section];
    if (sectionData == nil) {
        return 0;
    } else {
        return [(NSArray *)sectionData count];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellData = [self collectionView:collectionView cellDataForRowAtIndexPath:indexPath];
    
    NSNumber *width = [cellData objectForKey:@"width"];
    NSNumber *height = [cellData objectForKey:@"height"];
    if (width != nil && height != nil && [width floatValue] > 0.0f && [height floatValue] > 0.0f) {
        return CGSizeMake([width floatValue], [height floatValue]);
    } else {
        return SIZE_COLLECTION_CELL_DEFAULT;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView loadReuseCollectionViewCell:(NSIndexPath *)indexPath
{
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //默认CollectionViewCell
    UICollectionViewCell *cell = [self collectionView:collectionView loadReuseCollectionViewCell:indexPath];
    //单元格数据
    NSDictionary *cellData = [self collectionView:collectionView cellDataForRowAtIndexPath:indexPath];
    
    //初始化默认Cell
    if (cell == nil) {
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CELL_REUSE_IDENTIFIER_DEFAULT forIndexPath:indexPath];
    }
    
    //全局配置
    NSString *type = [cellData objectForKey:@"type"];
    //custom
    if ([@"custom" isEqualToString:type]) {
        //默认设置了值保留原视图，原始图基础上自定义，没设置则直接忽略，下同
        //自定义视图钩子，仅支持最多两个参数
        NSString *view = [cellData objectForKey:@"view"];
        if (view != nil && [view length] > 0) {
            //分析SEL参数个数
            NSArray *components = [view componentsSeparatedByString:@":"];
            NSUInteger paramCount = (components != nil) ? [components count] : 0;
            if (paramCount < 1) {
                return cell;
            }
            
            //根据参数个数传参数，最多支持两个参数
            SEL selector = NSSelectorFromString(view);
            if (paramCount == 1) {
                [self performSelector:selector];
            } else if (paramCount == 2) {
                [self performSelector:selector withObject:cell];
            } else {
                [self performSelector:selector withObject:cell withObject:cellData];
            }
            //自定义视图方法，重写即可，可以忽略cell完全重写，默认直接返回cell
        } else {
            cell = [self collectionView:collectionView customCellForRowAtIndexPath:indexPath withCell:cell];
        }
        return cell;
    //TODO
    } else {
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellData = [self collectionView:collectionView cellDataForRowAtIndexPath:indexPath];
    NSString *action = [cellData objectForKey:@"action"];
    if (action == nil || [action length] < 1) {
        return;
    }
    
    //分析SEL参数个数
    NSArray *components = [action componentsSeparatedByString:@":"];
    NSUInteger paramCount = (components != nil) ? [components count] : 0;
    if (paramCount < 1) {
        return;
    }
    
    //根据参数个数传参数，最多支持两个参数
    SEL selector = NSSelectorFromString(action);
    if (paramCount == 1) {
        [self performSelector:selector];
    } else if (paramCount == 2) {
        [self performSelector:selector withObject:cellData];
    } else {
        [self performSelector:selector withObject:collectionView withObject:indexPath];
    }
}

- (NSDictionary *)collectionView:(UICollectionView *)collectionView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionData = [self.collectionData objectAtIndex:indexPath.section];
    NSDictionary *cellData = [sectionData objectAtIndex:indexPath.row];
    return cellData;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UICollectionViewCell *)cell
{
    return cell;
}

@end
