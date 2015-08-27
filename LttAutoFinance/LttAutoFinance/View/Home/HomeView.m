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
    
    //图片轮播
    UIScrollView *scrollView;
    TAPageControl *pageControl;
    
    //3D动画
    NSMutableArray *carouselItems;
    
    //适配比例
    CGFloat widthRadio;
    CGFloat heightRadio;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //初始化
    widthRadio = SCREEN_WIDTH / 320.0f;
    heightRadio = SCREEN_HEIGHT / 570.0f;
    
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
    CGFloat topHeight = 180;
    CGFloat logoHeight = 30;
    CGFloat imageHeight = 120;
    CGFloat scrollHeight = imageHeight + logoHeight / 2;
    
    //顶部视图
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topHeight)];
    [self addSubview:topView];
    
    //定位图标
    UIImageView *pointView = [[UIImageView alloc] init];
    pointView.image = [UIImage imageNamed:@"point"];
    [topView addSubview:pointView];
    
    UIView *superview = topView;
    [pointView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(20);
        make.centerY.equalTo(superview.mas_top).offset(25);
        
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
        make.centerY.equalTo(superview.mas_top).offset(25);
        
        make.height.equalTo(@20);
    }];
    
    //地址视图
    UIView *addressView = [[UIView alloc] init];
    addressView.layer.cornerRadius = 3.0f;
    addressView.layer.backgroundColor = [UIColor colorWithHexString:@"A2A3A4"].CGColor;
    addressView.layer.borderColor = [UIColor colorWithHexString:@"B2B3B3"].CGColor;
    addressView.layer.borderWidth = 1;
    addressView.userInteractionEnabled = YES;
    //点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionGps)];
    [addressView addGestureRecognizer:singleTap];
    [topView addSubview:addressView];
    
    [addressView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(cityLabel.mas_right).offset(10);
        make.right.equalTo(superview.mas_right).offset(-30);
        
        make.height.equalTo(@30);
    }];
    
    //地址标签
    addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"正在为您定位";
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor = [UIColor colorWithHexString:@"EBEDED"];
    addressLabel.font = FONT_SMALL;
    [addressView addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(addressView.mas_top).offset(2);
        make.left.equalTo(addressView.mas_left).offset(20);
        make.height.equalTo(@12);
    }];
    
    //信息标签
    infoLabel = [[UILabel alloc] init];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = FONT_SMALL_BOLD;
    [addressView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(addressView.mas_bottom).offset(-2);
        make.left.equalTo(addressView.mas_left).offset(20);
        make.height.equalTo(@12);
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
    NSArray *imagesData = @[@"homeImage", @"homeImage", @"homeImage"];
    [imagesData enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop){
        //图片容器
        UIView *imageContainer = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, scrollHeight)];
        [scrollView addSubview:imageContainer];
        
        //图片内容
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, logoHeight / 2, SCREEN_WIDTH - 40, imageHeight)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:imageName];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 10;
        [imageContainer addSubview:imageView];
        
        //添加logo
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - logoHeight / 2, 0, logoHeight, logoHeight)];
        logoView.image = [UIImage imageNamed:@"homeIcon"];
        logoView.layer.masksToBounds = YES;
        logoView.layer.cornerRadius = logoHeight / 2;
        [imageContainer addSubview:logoView];
    }];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * imagesData.count, scrollHeight);
    
    //图片控件
    pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, topHeight - 20, SCREEN_WIDTH, 20)];
    pageControl.numberOfPages = imagesData.count;
    pageControl.delegate = self;
    [topView addSubview:pageControl];
}

//中部视图
- (void)middleView
{
    middleView = [UIView new];
    [self addSubview:middleView];
    
    UIView *superview = self;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topView.mas_bottom).offset(10);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@(SCREEN_WIDTH / 320 * 150));
    }];
    
    //初始化数据
    carouselItems = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [carouselItems addObject:[UIImage imageNamed:@"homeButton"]];
    }
    
    //初始化视图
    iCarousel *carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / 320 * 150)];
    carousel.delegate = self;
    carousel.dataSource = self;
    carousel.type = iCarouselTypeRotary;
    [middleView addSubview:carousel];
}

//底部视图
- (void)bottomView
{
    bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    
    CGFloat bottomHeight = 120;
    
    UIView *superview = self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
        make.height.equalTo(@(bottomHeight));
    }];
    
    //一键救援
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"homeHelp"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = LTT_TYPE_AUTOFINANCE;
    imageView.userInteractionEnabled = YES;
    //点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionCase:)];
    [imageView addGestureRecognizer:singleTap];
    [bottomView addSubview:imageView];
    
    superview = bottomView;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(25);
        make.right.equalTo(superview.mas_right).offset(-25);
        make.bottom.equalTo(superview.mas_bottom);
        
        make.height.equalTo(@60);
    }];
    
    //按钮列表
    UIView *buttonsView = [[UIView alloc] init];
    [bottomView addSubview:buttonsView];
    
    [buttonsView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@35);
    }];
    
    //按钮总长度
    CGFloat buttonsWidth = SCREEN_WIDTH - 40;
    
    //分期商城
    UIButton *firstButton = [[UIButton alloc] init];
    firstButton.tag = LTT_TYPE_AUTOFINANCE;
    [firstButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:firstButton];
    
    superview = buttonsView;
    [firstButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.bottom.equalTo(superview.mas_bottom);
        
        make.left.equalTo(superview.mas_left).offset(10);
        make.width.equalTo(@(buttonsWidth * 2 / 7));
    }];
    
    [self makeButtonView:firstButton title:@"分期商城" subtitle:@"0首付，2小时送达"];
    
    //车友部落
    UIButton *secondButton = [[UIButton alloc] init];
    secondButton.tag = LTT_TYPE_AUTOFINANCE;
    [secondButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:secondButton];
    
    [secondButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.bottom.equalTo(superview.mas_bottom);
        
        make.centerX.equalTo(superview.mas_centerX);
        make.width.equalTo(@(buttonsWidth * 3 / 7));
    }];
    
    [self makeButtonView:secondButton title:@"车友部落" subtitle:@"登记我的爱车,寻找同城的那个TA"];
    
    //汽车商城
    UIButton *thirdButton = [[UIButton alloc] init];
    thirdButton.tag = LTT_TYPE_AUTOFINANCE;
    [thirdButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:thirdButton];
    
    [thirdButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.bottom.equalTo(superview.mas_bottom);
        
        make.right.equalTo(superview.mas_right).offset(-10);
        make.width.equalTo(@(buttonsWidth * 2 / 7));
    }];
    
    [self makeButtonView:thirdButton title:@"汽车商城" subtitle:@"Auto mall"];
}

- (void)makeButtonView:(UIButton *)button title:(NSString *)title subtitle:(NSString *)subtitle
{
    //按钮样式
    button.layer.backgroundColor = [UIColor colorWithHexString:@"C7C8C9"].CGColor;
    button.layer.cornerRadius = 3.0f;
    button.layer.borderColor = (COLOR_MAIN_WHITE).CGColor;
    button.layer.borderWidth = 0.5f;
    button.titleLabel.text = nil;
    
    UILabel *label = [[UILabel alloc] init];
    //文字下划线
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange titleRange = NSMakeRange(0, [title length]);
    [titleText addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    label.attributedText = titleText;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = COLOR_MAIN_BLACK;
    label.font = FONT_MIDDLE_BOLD;
    [button addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(button.mas_centerX);
        make.bottom.equalTo(button.mas_centerY).offset(3);
        make.height.equalTo(@14);
    }];
    
    UILabel *firstDescLabel = [[UILabel alloc] init];
    firstDescLabel.backgroundColor = [UIColor clearColor];
    firstDescLabel.text = subtitle;
    firstDescLabel.textColor = [UIColor colorWithHexString:@"6F6766"];
    firstDescLabel.font = [UIFont systemFontOfSize:8];
    [button addSubview:firstDescLabel];
    
    [firstDescLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(button.mas_centerX);
        make.top.equalTo(button.mas_centerY).offset(5);
        make.height.equalTo(@8);
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
    return (NSInteger)[carouselItems count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 320 * 100, SCREEN_WIDTH / 320 * 150)];
        ((UIImageView *)view).image = [carouselItems objectAtIndex:index];
        view.contentMode = UIViewContentModeScaleAspectFill;
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
        [self.delegate actionCase:@(LTT_TYPE_AUTOFINANCE)];
    }
}

#pragma mark - RenderData
- (void) renderData
{
    //todo
    cityLabel.text = @"城市";
    
    NSString *address = [self getData:@"address"];
    addressLabel.text = [NSString stringWithFormat:@"%@", address];
    
    NSNumber *count = [self getData:@"count"];
    if (!count || [@-1 isEqualToNumber:count]) {
        infoLabel.text = @"";
    } else {
        infoLabel.text = [NSString stringWithFormat:@"有%@位信使为您服务", count];
    }
}

- (void) actionCase: (id)sender
{
    UIView *view = nil;
    if ([sender isKindOfClass:[UIView class]]) {
        view = sender;
    } else if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
        view = ((UIGestureRecognizer *)sender).view;
    }
    //检查参数
    if (!view || !view.tag) return;
    
    NSNumber *type = [NSNumber numberWithInteger:view.tag];
    [self.delegate actionCase:type];
}

- (void)actionGps
{
    [self.delegate actionGps];
}

@end
