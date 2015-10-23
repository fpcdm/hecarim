//
//  CaseCategoryView.m
//  LttMember
//
//  Created by wuyong on 15/10/22.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CaseCategoryView.h"

@implementation CaseCategoryView
{
    NSMutableArray *selectCategories;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.collectionView.scrollEnabled = YES;
    self.collectionView.allowsMultipleSelection = YES;
    
    //初始化数据
    selectCategories = [NSMutableArray array];
    
    return self;
}

- (void)renderData
{
    NSMutableArray *section = [NSMutableArray array];
    
    //循环分类
    NSArray *categories = [self getData:@"categories"];
    if (categories) {
        for (CategoryEntity *category in categories) {
            [section addObject:@{@"id" : @"address", @"type" : @"custom", @"view": @"cellCategory:cellData:", @"action": @"actionChoose:indexPath:", @"height":@90, @"width": @67.5, @"data": category}];
        }
    }
    
    self.collectionData = [[NSMutableArray alloc] initWithObjects:section,nil];
    [self.collectionView reloadData];
}

#pragma mark - CollectionView
- (UICollectionViewCell *)cellCategory: (UICollectionViewCell *)cell cellData:(NSDictionary *)cellData
{
    //设置选中样式
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedView.backgroundColor = [UIColor colorWithHexString:@"E8F0FA"];
    selectedView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    selectedView.layer.borderWidth = 0.5f;
    cell.selectedBackgroundView = selectedView;
    
    //图片显示
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.cornerRadius = 3.0f;
    imageView.backgroundColor = COLOR_MAIN_CLEAR;
    [cell addSubview:imageView];
    
    CategoryEntity *category = [cellData objectForKey:@"data"];
    [category iconView:imageView placeholder:nil];
    
    UIView *superview = cell;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@67.5);
    }];
    
    //文字显示
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = category.name;
    nameLabel.font = FONT_MIDDLE;
    nameLabel.textColor = COLOR_MAIN_BLACK;
    [cell addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom);
        make.centerX.equalTo(superview.mas_centerX);
        make.height.equalTo(@22.5);
    }];
    
    return cell;
}

#pragma mark - Action
- (void) actionChoose:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *cellData = [self collectionView:collectionView cellDataForRowAtIndexPath:indexPath];
    CategoryEntity *category = [cellData objectForKey:@"data"];
    
    //切换选中
    if ([selectCategories containsObject:category]) {
        [selectCategories removeObject:category];
        cell.selected = NO;
    } else {
        [selectCategories addObject:category];
        cell.selected = YES;
    }
}

#pragma mark - selectedCategories
- (NSArray *)selectedCategories
{
    return selectCategories;
}

@end
