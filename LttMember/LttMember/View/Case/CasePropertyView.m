//
//  CasePropertyView.m
//  LttMember
//
//  Created by wuyong on 15/9/28.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CasePropertyView.h"

@interface CasePropertyView ()

@end

@implementation CasePropertyView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //添加背景图
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"homePopupBg"];
    [self addSubview:bgView];
    
    UIView *superview = self;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
    }];
    
    //表格放到上面
    [self bringSubviewToFront:self.collectionView];
    
    //设置滚动视图
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = COLOR_MAIN_CLEAR;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    return self;
}

- (void)renderData
{
    NSMutableArray *section = [NSMutableArray array];
    
    //计算宽度
    CGFloat cellWidth = (SCREEN_WIDTH - 70) / 4;
    
    //循环属性
    NSArray *properties = [self getData:@"properties"];
    if (properties) {
        for (PropertyEntity *property in properties) {
            [section addObject:@{@"id" : @"address", @"type" : @"custom", @"view": @"cellProperty:cellData:", @"action": @"actionChoose:", @"height":@85, @"width": @(cellWidth), @"data": property}];
        }
    }
    
    self.collectionData = [[NSMutableArray alloc] initWithObjects:section,nil];
    [self.collectionView reloadData];
}

#pragma mark - CollectionView
- (UICollectionViewCell *)cellProperty: (UICollectionViewCell *)cell cellData:(NSDictionary *)cellData
{
    //移除子视图
    for (UIView *subview in cell.subviews) {
        subview.hidden = YES;
        [subview removeFromSuperview];
    }
    
    //图片显示
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.cornerRadius = 3.0f;
    imageView.backgroundColor = COLOR_MAIN_CLEAR;
    [cell addSubview:imageView];
    
    PropertyEntity *property = [cellData objectForKey:@"data"];
    [property iconView:imageView];
    
    UIView *superview = cell;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(5);
        make.centerX.equalTo(superview.mas_centerX);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    //文字显示
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = property.name;
    nameLabel.font = FONT_SMALL;
    nameLabel.textColor = COLOR_MAIN_WHITE;
    [cell addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom);
        make.centerX.equalTo(superview.mas_centerX);
        make.height.equalTo(@25);
    }];
    
    return cell;
}

#pragma mark - Action
- (void) actionChoose:(NSDictionary *)cellData
{
    PropertyEntity *property = [cellData objectForKey:@"data"];
    [self.delegate actionSelected:property];
}

@end
