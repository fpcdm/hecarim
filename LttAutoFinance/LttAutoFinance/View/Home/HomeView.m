//
//  HomeView.m
//  LttAutoFinance
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeView.h"
#import "iCarousel.h"
#import "TAPageControl.h"
#import "ReflectionView.h"
#import "CategoryEntity.h"

@interface HomeView () <iCarouselDataSource, iCarouselDelegate, UIScrollViewDelegate, TAPageControlDelegate>

@end

@implementation HomeView
{
    UILabel *cityLabel;
    UILabel *addressLabel;
    UILabel *infoLabel;
    
    UIView *topView;
    UIView *middleView;
    UIView *bottomView;
    
    //屏幕可用高度
    CGFloat screenHeight;
    
    //图片轮播
    UIScrollView *scrollView;
    TAPageControl *pageControl;
    
    //3D动画
    NSMutableArray *cardData;
    
    //需求类型
    NSArray *caseTypes;
    NSMutableArray *typeViews;
}

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (!self) return nil;
    
    //初始化数据
    typeViews = [[NSMutableArray alloc] init];
    
    //初始化屏幕高度
    screenHeight = [((NSNumber *)[data objectForKey:@"height"]) floatValue];
    
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
    //参数定制
    CGFloat topHeight = screenHeight * 3 / 8;
    CGFloat imageHeight = topHeight * 0.63;
    CGFloat logoHeight = 30;
    CGFloat scrollHeight = imageHeight + logoHeight / 2;
    CGFloat gpsCenterY = topHeight * 0.15;
    
    //顶部视图
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topHeight)];
    [self addSubview:topView];
    
    //定位图标
    UIImageView *pointView = [[UIImageView alloc] init];
    pointView.image = [UIImage imageNamed:@"point"];
    [topView addSubview:pointView];
    
    UIView *superview = topView;
    [pointView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(15);
        make.centerY.equalTo(superview.mas_top).offset(gpsCenterY);
        
        make.width.equalTo(@11);
        make.height.equalTo(@16);
    }];
    
    //定位城市
    cityLabel = [[UILabel alloc] init];
    cityLabel.textColor = COLOR_MAIN_WHITE;
    cityLabel.text = @"定位";
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont boldSystemFontOfSize:16];
    [topView addSubview:cityLabel];
    
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(pointView.mas_right).offset(5);
        make.centerY.equalTo(pointView.mas_centerY);
        
        make.height.equalTo(@20);
    }];
    
    //地址视图
    UIButton *addressView = [[UIButton alloc] init];
    addressView.titleLabel.text = nil;
    [addressView setBackgroundImage:[UIImage imageNamed:@"homeButtonGps"] forState:UIControlStateNormal];
    [addressView setBackgroundImage:[UIImage imageNamed:@"homeButtonGps"] forState:UIControlStateHighlighted];
    [addressView addTarget:self action:@selector(actionGps) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:addressView];
    
    [addressView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(pointView.mas_centerY);
        make.left.equalTo(cityLabel.mas_right).offset(10);
        make.right.equalTo(superview.mas_right).offset(-30);
        
        make.height.equalTo(@40);
    }];
    
    //地址标签
    addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"正在为您定位：定位中";
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor = COLOR_MAIN_WHITE;
    addressLabel.font = FONT_SMALL_BOLD;
    [addressView addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(addressView.mas_top).offset(5);
        make.left.equalTo(addressView.mas_left).offset(20);
        make.right.equalTo(addressView.mas_right).offset(-10);
    }];
    
    //信息标签
    infoLabel = [[UILabel alloc] init];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = FONT_SMALL_BOLD;
    [addressView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(addressView.mas_bottom).offset(-5);
        make.left.equalTo(addressView.mas_left).offset(20);
        make.right.equalTo(addressView.mas_right).offset(-10);
    }];
    
    //幻灯片
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topHeight - imageHeight - logoHeight / 2, SCREEN_WIDTH, scrollHeight)];
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    [topView addSubview:scrollView];
    
    //添加图片
    NSArray *imagesData = @[@"homeAd"];
    [imagesData enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop){
        //图片容器
        UIView *imageContainer = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, scrollHeight)];
        [scrollView addSubview:imageContainer];
        
        //图片内容
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, logoHeight / 2, SCREEN_WIDTH - 30, imageHeight)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:imageName];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10;
        [imageContainer addSubview:imageView];
        
        //添加logo
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - logoHeight / 2, 0, logoHeight, logoHeight)];
        logoView.image = [UIImage imageNamed:@"logo"];
        logoView.layer.masksToBounds = YES;
        logoView.layer.cornerRadius = logoHeight / 2;
        [imageContainer addSubview:logoView];
    }];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * imagesData.count, scrollHeight);
    
    //图片控件
    pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, topHeight - 30, SCREEN_WIDTH, 30)];
    pageControl.numberOfPages = imagesData.count;
    pageControl.delegate = self;
    [topView addSubview:pageControl];
}

//中部视图
- (void)middleView
{
    CGFloat middleHeight = screenHeight * 3 / 8;
    
    middleView = [UIView new];
    [self addSubview:middleView];
    
    UIView *superview = self;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@(middleHeight));
    }];
    
    //卡片数据（3D旋转）
    cardData = [[NSMutableArray alloc] init];
    [cardData addObject:@{@"icon":@"homeIconFinance", @"tag": @0}];
    [cardData addObject:@{@"icon":@"homeIconProtect", @"tag": @1}];
    [cardData addObject:@{@"icon":@"homeIconFix", @"tag": @2}];
    [cardData addObject:@{@"icon":@"homeIconCheck", @"tag": @3}];
    [cardData addObject:@{@"icon":@"homeIconBuy", @"tag": @4}];
    [cardData addObject:@{@"icon":@"homeIconFinance", @"tag": @0}];
    [cardData addObject:@{@"icon":@"homeIconProtect", @"tag": @1}];
    [cardData addObject:@{@"icon":@"homeIconFix", @"tag": @2}];
    [cardData addObject:@{@"icon":@"homeIconCheck", @"tag": @3}];
    [cardData addObject:@{@"icon":@"homeIconBuy", @"tag": @4}];
    
    //初始化视图
    iCarousel *carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, middleHeight)];
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.viewpointOffset = CGSizeMake(0, middleHeight * 1 / 20);
    carousel.type = iCarouselTypeRotary;
    [middleView addSubview:carousel];
}

//底部视图
- (void)bottomView
{
    CGFloat bottomHeight = screenHeight * 2 / 8.0;
    CGFloat buttonHeight = bottomHeight * 5 / 16;
    
    bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    
    UIView *superview = self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
        make.height.equalTo(@(bottomHeight));
    }];
    
    //两条腿转车
    UIButton *carButton = [[UIButton alloc] init];
    [carButton setBackgroundImage:[UIImage imageNamed:@"homeButtonCar"] forState:UIControlStateNormal];
    [carButton setBackgroundImage:[UIImage imageNamed:@"homeButtonCar"] forState:UIControlStateHighlighted];
    carButton.tag = 5;
    [carButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:carButton];
    [typeViews addObject:carButton];
    
    superview = bottomView;
    [carButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_top).offset(buttonHeight * 1.2);
        make.centerX.equalTo(superview.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH * 4 / 10));
        make.height.equalTo(@(SCREEN_WIDTH * 4 / 10 * 0.44));
    }];
    
    //分期商城
    UIButton *firstButton = [[UIButton alloc] init];
    [firstButton setBackgroundImage:[UIImage imageNamed:@"homeButtonFinance"] forState:UIControlStateNormal];
    [firstButton setBackgroundImage:[UIImage imageNamed:@"homeButtonFinance"] forState:UIControlStateHighlighted];
    firstButton.tag = 6;
    [firstButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:firstButton];
    [typeViews addObject:firstButton];
    
    [firstButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(carButton.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH * 1 / 3));
        make.height.equalTo(@(buttonHeight));
    }];
    
    //车友部落
    UIButton *secondButton = [[UIButton alloc] init];
    [secondButton setBackgroundImage:[UIImage imageNamed:@"homeButtonClub"] forState:UIControlStateNormal];
    [secondButton setBackgroundImage:[UIImage imageNamed:@"homeButtonClub"] forState:UIControlStateHighlighted];
    secondButton.tag = 7;
    [secondButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:secondButton];
    [typeViews addObject:secondButton];
    
    [secondButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(carButton.mas_bottom);
        make.centerX.equalTo(superview.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH * 1 / 3));
        make.height.equalTo(@(buttonHeight));
    }];
    
    //汽车商城
    UIButton *thirdButton = [[UIButton alloc] init];
    [thirdButton setBackgroundImage:[UIImage imageNamed:@"homeButtonMall"] forState:UIControlStateNormal];
    [thirdButton setBackgroundImage:[UIImage imageNamed:@"homeButtonMall"] forState:UIControlStateHighlighted];
    thirdButton.tag = 8;
    [thirdButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:thirdButton];
    [typeViews addObject:thirdButton];
    
    superview = bottomView;
    [thirdButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(carButton.mas_bottom);
        make.right.equalTo(superview.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH * 1 / 3));
        make.height.equalTo(@(buttonHeight));
    }];
    
    //一键救援
    UIButton *helpButton = [[UIButton alloc] init];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"homeButtonHelp"] forState:UIControlStateNormal];
    [helpButton setBackgroundImage:[UIImage imageNamed:@"homeButtonHelp"] forState:UIControlStateHighlighted];
    helpButton.tag = 9;
    [helpButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:helpButton];
    [typeViews addObject:helpButton];
    
    superview = bottomView;
    [helpButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@(buttonHeight));
    }];
}

#pragma mark - TAPageControl
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    NSInteger pageIndex = _scrollView.contentOffset.x / SCREEN_WIDTH;
    pageControl.currentPage = pageIndex;
}

- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index
{
    [scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, 120) animated:YES];
}

#pragma mark - iCarousel
- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[cardData count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        //高度适配
        CGFloat carouselHeight = carousel.frame.size.height;
        CGFloat cardHeight = carouselHeight * 4 / 5;
        CGFloat cardWidth = cardHeight * 2 / 3;
        
        //容器
        CGRect viewFrame = CGRectMake(0, 0, cardWidth, cardHeight);
        view = [[UIView alloc] initWithFrame:viewFrame];
        
        //阴影
        CGRect reflectionFrame = CGRectMake(10, 0, cardWidth - 20, cardHeight);
        ReflectionView *reflectionView = [[ReflectionView alloc] initWithFrame:reflectionFrame];
        reflectionView.backgroundColor = COLOR_MAIN_WHITE;
        reflectionView.layer.cornerRadius = 5.0f;
        reflectionView.reflectionScale = 0.2;
        reflectionView.reflectionAlpha = 0.3;
        reflectionView.reflectionGap = 8;
        [view addSubview:reflectionView];
        
        //图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:viewFrame];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 5.0f;
        imageView.image = [UIImage imageNamed:@"homeCard"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:imageView];
        
        //数据
        NSDictionary *cardDict = [cardData objectAtIndex:index];
        NSNumber *tagNumber = [cardDict objectForKey:@"tag"];
        view.tag = [tagNumber integerValue];
        [typeViews addObject:view];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 101;
        titleLabel.text = @" ";
        titleLabel.textColor = [UIColor colorWithHexString:@"FF9D03"];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [view addSubview:titleLabel];
        
        UIView *superview = view;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(superview.mas_centerX);
            make.centerY.equalTo(superview.mas_centerY);
        }];
        
        //图标
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.image = [UIImage imageNamed:[cardDict objectForKey:@"icon"]];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make){
            make.bottom.equalTo(titleLabel.mas_top).offset(-10);
            make.centerX.equalTo(superview.mas_centerX);
            
            make.width.equalTo(@50);
            make.height.equalTo(@30);
        }];
        
        //分割线
        UIView *sepView = [[UIView alloc] init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"dcc080"];
        [view addSubview:sepView];
        
        [sepView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(titleLabel.mas_bottom).offset(2);
            make.left.equalTo(superview.mas_left).offset(10);
            make.right.equalTo(superview.mas_right).offset(-10);
            make.height.equalTo(@0.5);
        }];
        
        //子标题
        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.tag = 102;
        subtitleLabel.text = @" ";
        subtitleLabel.textColor = [UIColor colorWithHexString:@"454545"];
        subtitleLabel.font = [UIFont systemFontOfSize:8];
        [view addSubview:subtitleLabel];
        
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(sepView.mas_bottom).offset(5);
            make.centerX.equalTo(superview.mas_centerX);
        }];
    }
    
    return view;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //启用循环
    if (option == iCarouselOptionWrap) {
        return YES;
        //返回默认值
    } else {
        return value;
    }
}

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    //选择的是当前跳转需求发表页面
    if (index == carousel.currentItemIndex) {
        UIView *view = [carousel itemViewAtIndex:index];
        if (!caseTypes || [caseTypes count] < (view.tag + 1)) return;
        
        //获取需求类型
        CategoryEntity *category = [caseTypes objectAtIndex:view.tag];
        if (category) {
            [self.delegate actionCase:category.id];
        }
    }
}

#pragma mark - RenderData
- (void) renderData
{
    //需求类型
    caseTypes = [self getData:@"types"];
    for (UIView *view in typeViews) {
        if ([caseTypes count] < (view.tag + 1)) continue;
        
        CategoryEntity *category = [caseTypes objectAtIndex:view.tag];
        //标题
        UIView *titleView = [view viewWithTag:101];
        if (titleView && [titleView isKindOfClass:[UILabel class]]) {
            ((UILabel *)titleView).text = category.name;
        }
        //子标题
        UIView *subtitleView = [view viewWithTag:102];
        if (subtitleView && [subtitleView isKindOfClass:[UILabel class]]) {
            ((UILabel *)subtitleView).text = category.remark;
        }
    }
    
    NSString *city = [self getData:@"city"];
    cityLabel.text = city;
    
    NSString *address = [self getData:@"address"];
    addressLabel.text = [NSString stringWithFormat:@"正在为您定位：%@", address];
    
    NSNumber *count = [self getData:@"count"];
    if (!count || [@-1 isEqualToNumber:count]) {
        infoLabel.text = @"";
    } else {
        infoLabel.text = [NSString stringWithFormat:@"有%@位信使为您服务", count];
    }
}

- (void) actionCase: (UIButton *)sender
{
    //参数检查
    if (!caseTypes || [caseTypes count] < (sender.tag + 1)) return;
    
    //获取需求类型
    CategoryEntity *category = [caseTypes objectAtIndex:sender.tag];
    if (category) {
        [self.delegate actionCase:category.id];
    }
}

- (void)actionGps
{
    [self.delegate actionGps];
}

@end
