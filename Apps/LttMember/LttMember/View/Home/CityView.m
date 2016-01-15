//
//  CityView.m
//  LttMember
//
//  Created by wuyong on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CityView.h"

@implementation CityView
{
    UIButton *gpsButton;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //设置滚动视图
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = COLOR_MAIN_BG;
    
    UIView *superview = self;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(100);
    }];
    
    //已定位城市
    UILabel *gpsLabel = [[UILabel alloc] init];
    gpsLabel.text = @"定位城市";
    gpsLabel.textColor = COLOR_MAIN_DARK;
    gpsLabel.font = FONT_MAIN;
    [self addSubview:gpsLabel];
    
    [gpsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.height.equalTo(@16);
    }];
    
    //定位城市
    gpsButton = [[UIButton alloc] init];
    gpsButton.backgroundColor = COLOR_MAIN_WHITE;
    gpsButton.layer.cornerRadius = 3.0f;
    gpsButton.layer.borderColor = CGCOLOR_MAIN_BORDER;
    gpsButton.layer.borderWidth = 0.5f;
    gpsButton.titleLabel.font = FONT_MAIN;
    gpsButton.tag = 0;
    [gpsButton setTitle:@"定位失败，请点击重试" forState:UIControlStateNormal];
    [gpsButton setTitleColor:COLOR_MAIN_DARK forState:UIControlStateNormal];
    [gpsButton addTarget:self action:@selector(actionGps) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:gpsButton];
    
    [gpsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gpsLabel.mas_bottom).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.height.equalTo(@36);
    }];
    [self adjustGpsButton];
    
    //已定位城市
    UILabel *cityLabel = [[UILabel alloc] init];
    cityLabel.text = @"全部城市";
    cityLabel.textColor = COLOR_MAIN_DARK;
    cityLabel.font = FONT_MAIN;
    [self addSubview:cityLabel];
    
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gpsButton.mas_bottom).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.height.equalTo(@16);
    }];
    
    return self;
}

- (void)adjustGpsButton
{
    [gpsButton.titleLabel sizeToFit];
    
    CGFloat buttonWidth = gpsButton.titleLabel.frame.size.width + 20;
    CGFloat minWidth = (int) ((SCREEN_WIDTH - 40) / 3);
    if (buttonWidth < minWidth) buttonWidth = minWidth;
    
    [gpsButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
    }];
}

- (void)renderData
{
    //所有城市列表
    NSArray *cities = [self getData:@"cities"];
    
    //定位城市
    LocationEntity *gps = [self getData:@"gps"];
    if (gps && gps.cityCode) {
        //是否在开通城市列表中
        BOOL isOpenCity = NO;
        for (LocationEntity *city in cities) {
            if (city.cityCode && [city.cityCode isEqualToString:gps.cityCode]) {
                isOpenCity = YES;
                break;
            }
        }
        
        [gpsButton setTitle:gps.city forState:UIControlStateNormal];
        if (isOpenCity) {
            gpsButton.tag = 1;
            gpsButton.enabled = YES;
            gpsButton.backgroundColor = COLOR_MAIN_WHITE;
        } else {
            gpsButton.tag = -1;
            gpsButton.enabled = NO;
            gpsButton.backgroundColor = [UIColor colorWithHexString:@"#CDCDCC"];
        }
    } else {
        gpsButton.tag = 0;
        gpsButton.enabled = YES;
        gpsButton.backgroundColor = COLOR_MAIN_WHITE;
        [gpsButton setTitle:@"定位失败，请点击重试" forState:UIControlStateNormal];
    }
    [self adjustGpsButton];
    
    //所有城市
    NSMutableArray *section = [NSMutableArray array];
    CGFloat cellWidth = (int) ((SCREEN_WIDTH - 40) / 3);
    if (cities) {
        for (LocationEntity *city in cities) {
            [section addObject:@{@"id" : @"city", @"type" : @"custom", @"view": @"cellCity:cellData:", @"action": @"actionChoose:", @"height":@36, @"width": @(cellWidth), @"data": city}];
        }
    }
    
    self.collectionData = [[NSMutableArray alloc] initWithObjects:section,nil];
    [self.collectionView reloadData];
}

#pragma mark - CollectionView
- (UICollectionViewCell *)cellCity: (UICollectionViewCell *)cell cellData:(NSDictionary *)cellData
{
    //移除子视图
    for (UIView *subview in cell.subviews) {
        subview.hidden = YES;
        [subview removeFromSuperview];
    }
    
    LocationEntity *city = [cellData objectForKey:@"data"];
    
    //按钮
    UILabel *cityLabel = [[UILabel alloc] init];
    cityLabel.backgroundColor = COLOR_MAIN_WHITE;
    cityLabel.layer.cornerRadius = 3.0f;
    cityLabel.layer.borderColor = CGCOLOR_MAIN_BORDER;
    cityLabel.layer.borderWidth = 0.5f;
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.font = FONT_MAIN;
    cityLabel.text = city.city;
    cityLabel.textColor = COLOR_MAIN_DARK;
    [cell addSubview:cityLabel];
    
    UIView *superview = cell;
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    return cell;
}

#pragma mark - Action
- (void) actionGps
{
    //禁用
    if (gpsButton.tag < 0) {
    //重新定位
    } else if (gpsButton.tag == 0) {
        [self.delegate actionGps];
    //设置
    } else {
        LocationEntity *gps = [self getData:@"gps"];
        [self.delegate actionCitySelected:gps];
    }
}

- (void) actionChoose:(NSDictionary *)cellData
{
    LocationEntity *city = [cellData objectForKey:@"data"];
    
    [self.delegate actionCitySelected:city];
}

@end
