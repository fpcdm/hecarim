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
    
    //设置滚动视图
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = COLOR_MAIN_CLEAR;
    
    return self;
}

- (void)renderData
{
    NSMutableArray *section = [NSMutableArray array];
    
    //计算宽度
    CGFloat cellWidth = (SCREEN_WIDTH - 50) / 4;
    
    //循环属性
    NSArray *properties = [self getData:@"properties"];
    if (properties) {
        for (PropertyEntity *property in properties) {
            [section addObject:@{@"id" : @"address", @"type" : @"custom", @"view": @"cellProperty:cellData:", @"action": @"actionChoose:", @"height":@85, @"width": @(cellWidth), @"data": property}];
        }
    }
    
    //添加取消图标
    PropertyEntity *cancelProperty = [[PropertyEntity alloc] init];
    cancelProperty.id = @-1;
    cancelProperty.name = @"取消";
    cancelProperty.icon = @"homeItemCancel";
    [section addObject:@{@"id" : @"address", @"type" : @"custom", @"view": @"cellProperty:cellData:", @"action": @"actionChoose:", @"height":@85, @"width": @(cellWidth), @"data": cancelProperty}];
    
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
    if ([@-1 isEqualToNumber:property.id]) {
        imageView.image = [UIImage imageNamed:property.icon];
    } else {
        [property iconView:imageView];
    }
    
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
