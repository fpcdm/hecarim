//
//  HomeView.m
//  LttAutoFinance
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeView.h"
#import "InfiniteScrollPicker.h"
#import "iCarousel.h"

@interface HomeView () <iCarouselDataSource, iCarouselDelegate>

@end

@implementation HomeView
{
    UILabel *addressLabel;
    UILabel *infoLabel;
    
    UIView *topView;
    UIView *middleView;
    UIView *bottomView;
    
    iCarousel *carousel;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //背景图片
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"homeBg"];
    [self addSubview:bgView];
    
    UIView *superview = self;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
    }];
    
    //顶部视图
    [self topView];
    
    //中部视图
    [self middleView];
    
    //底部视图
    [self bottomView];
    
    return self;
}

- (void) topView
{
    //顶部视图
    topView = [[UIView alloc] init];
    [self addSubview:topView];
    
    UIView *superview = self;
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
    }];
}

//中部视图
- (void)middleView
{
    middleView = [UIView new];
    [self addSubview:middleView];
    
    NSMutableArray *set1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        [set1 addObject:[UIImage imageNamed:@"homeButton"]];
    }
    
    InfiniteScrollPicker *isp = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 190)];
    [isp setItemSize:CGSizeMake(100, 150)];
    [isp setImageAry:set1];
    [isp setHeightOffset:20];
    [isp setPositionRatio:2];
    [isp setAlphaOfobjs:1];
    [self addSubview:isp];
    
    carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, 200)];
    carousel.delegate = self;
    carousel.dataSource = self;
    [self addSubview:carousel];
    
    carousel.type = iCarouselTypeCoverFlow;
    
    UIView *superview = self;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make){
    }];
}

//底部视图
- (void)bottomView
{
    bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    
    UIView *superview = self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
    }];
}

#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 30;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homeButton"]];
    
    view.frame = CGRectMake(70, 80, 180, 260);
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 30;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 200;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}

#pragma mark - RenderData
- (void) renderData
{
    NSString *address = [self getData:@"address"];
    addressLabel.text = address;
    
    NSNumber *count = [self getData:@"count"];
    if (!count || [@-1 isEqualToNumber:count]) {
        infoLabel.text = @"";
    } else {
        infoLabel.text = [NSString stringWithFormat:@"有%@个信使等待为您服务", count];
    }
}

- (void) actionCase: (UIButton *)sender
{
    NSNumber *type = [NSNumber numberWithInteger:sender.tag];
    [self.delegate actionCase:type];
}

- (void)actionGps
{
    [self.delegate actionGps];
}

@end
