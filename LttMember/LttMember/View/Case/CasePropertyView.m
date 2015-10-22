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
    
    self.collectionView.scrollEnabled = YES;
    
    return self;
}

- (void)renderData
{
    NSMutableArray *section = [NSMutableArray array];
    
    //循环属性
    NSArray *properties = [self getData:@"properties"];
    if (properties) {
        for (PropertyEntity *property in properties) {
            [section addObject:@{@"id" : @"address", @"type" : @"custom", @"view": @"cellProperty:cellData:", @"action": @"actionChoose:", @"height":@90, @"width": @67.5, @"data": property}];
        }
    }
    
    self.collectionData = [[NSMutableArray alloc] initWithObjects:section,nil];
    [self.collectionView reloadData];
}

#pragma mark - CollectionView
- (UICollectionViewCell *)cellProperty: (UICollectionViewCell *)cell cellData:(NSDictionary *)cellData
{
    //图片显示
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.layer.cornerRadius = 3.0f;
    imageView.backgroundColor = COLOR_MAIN_CLEAR;
    [cell addSubview:imageView];
    
    PropertyEntity *property = [cellData objectForKey:@"data"];
    [property iconView:imageView];
    
    UIView *superview = cell;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@67.5);
    }];
    
    //文字显示
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = property.name;
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
- (void) actionChoose:(NSDictionary *)cellData
{
    PropertyEntity *property = [cellData objectForKey:@"data"];
    [self.delegate actionSelected:property];
}

@end
