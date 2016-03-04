//
//  HomeView.m
//  LttMember
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeView.h"
#import "CategoryEntity.h"
#import "SpringBoardButton.h"
#import "TAPageControl.h"
#import "CasePropertyView.h"
#import "AdvertEntity.h"

@interface HomeView () <SpringBoardButtonDelegate, UIScrollViewDelegate, TAPageControlDelegate, CasePropertyViewDelegate>

@end

@implementation HomeView
{
    CGFloat statusBarHeight;
    CGFloat navigationBarHeight;
    CGFloat tabBarHeight;
    
    //顶部(定位+幻灯片)总高度
    CGFloat topHeight;
    //中间(服务)总高度
    CGFloat middleHeight;
    
    UIScrollView *adView;
    NSMutableArray *imagesData;
    TAPageControl *adPageControl;
    
    UILabel *addressLabel;
    UIButton *cityButton;
    
    UIView *topView;
    UIView *middleView;
    
    CasePropertyView *propertyView;
    
    NSMutableArray *typeBtns;
    
    NSMutableArray *types;
}

@synthesize typeView;

- (id) initWithData:(NSDictionary *)data
{
    self = [super initWithData:data];
    if (!self) return nil;
    
    //获取状态，导航栏高度
    NSNumber *statusBarNumber = [data objectForKey:@"statusBarHeight"];
    NSNumber *navigationBarNumber = [data objectForKey:@"navigationBarHeight"];
    NSNumber *tabBarNumber = [data objectForKey:@"tabBarHeight"];
    statusBarHeight = statusBarNumber && statusBarNumber.floatValue > 0 ? statusBarNumber.floatValue : 20;
    navigationBarHeight = navigationBarNumber && navigationBarNumber.floatValue > 0 ? navigationBarNumber.floatValue : 44;
    tabBarHeight = tabBarNumber && tabBarNumber.floatValue > 0 ? tabBarNumber.floatValue : 49;
    
    //计算高度
    topHeight = SCREEN_WIDTH * 0.548;
    middleHeight = SCREEN_HEIGHT - topHeight - tabBarHeight;
    
    [self topView];
    [self middleView];
    
    return self;
}

- (void) topView
{
    //顶部容器
    topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHex:@"#474955"];
    [self addSubview:topView];
    
    UIView *superview = self;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@(topHeight));
    }];
    
    //城市切换按钮
    cityButton = [[UIButton alloc] init];
    cityButton.backgroundColor = COLOR_MAIN_CLEAR;
    cityButton.titleLabel.font = FONT_MIDDLE;
    [cityButton setTitle:@"切换城市" forState:UIControlStateNormal];
    [cityButton setTitleColor:COLOR_MAIN_WHITE forState:UIControlStateNormal];
    [cityButton addTarget:self action:@selector(actionCity) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cityButton];
    
    superview = topView;
    [cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_top).offset(statusBarHeight + navigationBarHeight / 2);
        make.right.equalTo(superview.mas_right).offset(-4);
        make.height.equalTo(@30);
    }];
    
    UIImageView *chooseCityImage = [[UIImageView alloc] init];
    chooseCityImage.image = [UIImage imageNamed:@"homeChooseCity"];
    [cityButton addSubview:chooseCityImage];
    
    superview = cityButton;
    [chooseCityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview.mas_right).offset(-6);
        make.centerY.equalTo(superview.mas_centerY);
        make.height.equalTo(@7);
        make.width.equalTo(@7);
    }];
    [self adjustCityButton];
    
    //当前位置
    UIButton *locationButton = [[UIButton alloc] init];
    locationButton.backgroundColor = [UIColor clearColor];
    [locationButton addTarget:self action:@selector(actionGps) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:locationButton];
    
    superview = topView;
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_top).offset(statusBarHeight + navigationBarHeight / 2);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(cityButton.mas_left).offset(5);
        make.height.equalTo(@30);
    }];
    
    UIImageView *pointView = [[UIImageView alloc] init];
    pointView.image = [UIImage imageNamed:@"homePoint"];
    pointView.contentMode = UIViewContentModeScaleAspectFit;
    [locationButton addSubview:pointView];
    
    superview = locationButton;
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left).offset(5);
        make.centerY.equalTo(superview.mas_centerY);
        make.height.equalTo(@15);
        make.width.equalTo(@20);
    }];
    
    //地址视图
    UIScrollView *addressView = [[UIScrollView alloc] init];
    addressView.showsHorizontalScrollIndicator = NO;
    addressView.showsVerticalScrollIndicator = NO;
    [locationButton addSubview:addressView];
    
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(pointView.mas_right);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@20);
    }];
    
    //地址文本
    addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"正在定位";
    addressLabel.font = FONT_MIDDLE;
    addressLabel.textColor = COLOR_MAIN_WHITE;
    [addressView addSubview:addressLabel];
    
    superview = addressView;
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(superview.mas_height);
    }];
    
    //幻灯片
    [self adView];
}

- (void) adView
{
    //计算参数
    CGFloat imageHeight = topHeight - statusBarHeight - navigationBarHeight;
    
    //幻灯片
    adView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, statusBarHeight + navigationBarHeight, SCREEN_WIDTH, imageHeight)];
    adView.tag = 2;
    adView.scrollEnabled = YES;
    adView.pagingEnabled = YES;
    adView.showsHorizontalScrollIndicator = NO;
    adView.showsVerticalScrollIndicator = NO;
    adView.delegate = self;
    [topView addSubview:adView];
    
    //默认没有图片
    imagesData = [NSMutableArray arrayWithArray:@[@"homeAd.jpg"]];
    [imagesData enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop){
        //图片容器
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, imageHeight)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:imageName];
        imageView.layer.masksToBounds = YES;
        [adView addSubview:imageView];
    }];
    adView.contentSize = CGSizeMake(SCREEN_WIDTH * imagesData.count, imageHeight);
    
    //图片控件
    adPageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, topHeight - 30, SCREEN_WIDTH, 30)];
    adPageControl.tag = 2;
    adPageControl.alpha = 0.8;
    adPageControl.dotSize = CGSizeMake(5, 5);
    adPageControl.numberOfPages = imagesData.count;
    adPageControl.delegate = self;
    [topView addSubview:adPageControl];
}

- (void) middleView
{
    //中部背景
    UIImageView *middleBgView = [[UIImageView alloc] init];
    middleBgView.image = [UIImage imageNamed:@"homeBg"];
    middleBgView.alpha = 0.9;
    [self addSubview:middleBgView];
    
    UIView *superview = self;
    [middleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@(middleHeight));
    }];
    
    //中部容器
    middleView = [[UIView alloc] init];
    [self addSubview:middleView];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@(middleHeight));
    }];
    
    //服务菜单
    typeView = [[UIScrollView alloc] init];
    typeView.backgroundColor = COLOR_MAIN_CLEAR;
    typeView.tag = 2;
    typeView.showsHorizontalScrollIndicator = NO;
    typeView.showsVerticalScrollIndicator = NO;
    [typeView setPagingEnabled:NO];
    [typeView setSpringBoardDelegate:self];
    [middleView addSubview:typeView];
    
    superview = middleView;
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
    }];
}

- (void)adjustCityButton
{
    [cityButton.titleLabel sizeToFit];
    CGFloat buttonWidth = cityButton.titleLabel.frame.size.width + 30;
    
    [cityButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(buttonWidth));
    }];
}

#pragma mark - Ads
- (void) reloadAds
{
    //重新设置数据
    imagesData = [NSMutableArray arrayWithArray:[self fetch:@"adverts"]];
    if (!imagesData || [imagesData count] < 1) return;
    
    //删除原图片
    for (UIView *imageView in adView.subviews) {
        [imageView removeFromSuperview];
    }
    
    //多添加首尾图片循环滚动
    AdvertEntity *firstAdvert = [imagesData firstObject];
    AdvertEntity *lastAdvert = [imagesData lastObject];
    [imagesData insertObject:lastAdvert atIndex:0];
    [imagesData addObject:firstAdvert];
    
    //添加图片
    CGFloat imageHeight = topHeight - statusBarHeight - navigationBarHeight;
    [imagesData enumerateObjectsUsingBlock:^(AdvertEntity *advert, NSUInteger idx, BOOL *stop){
        //图片容器
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, imageHeight)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.layer.masksToBounds = YES;
        [adView addSubview:imageView];
        
        //异步加载图片
        [advert imageView:imageView];
    }];
    adView.contentSize = CGSizeMake(SCREEN_WIDTH * imagesData.count, imageHeight);
    //默认滚动一屏，实现左循环滚动
    adView.contentOffset = CGPointMake(SCREEN_WIDTH, adView.contentOffset.y);
    adPageControl.numberOfPages = imagesData.count - 2;
}

#pragma mark - isLogin
- (BOOL)isLogin
{
    return [self.delegate actionIsLogin];
}

#pragma mark - RenderData
- (void) display
{
    //显示位置
    NSString *address = [self fetch:@"address"];
    NSString *gps = [self fetch:@"gps"];
    if (address) {
        NSNumber *count = [self fetch:@"count"];
        if (count && ![@-1 isEqualToNumber:count]) {
            //address = [NSString stringWithFormat:@"%@(有%@位信使为您服务)", address, count];
        }
        addressLabel.text = address;
    } else if (gps) {
        addressLabel.text = gps;
    }
    
    //显示城市
    NSString *city = [self fetch:@"city"];
    if (city && [city length] > 0) {
        [cityButton setTitle:city forState:UIControlStateNormal];
        [self adjustCityButton];
    }
}

#pragma mark - TAPageControl
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    //幻灯片，循环滚动
    if (_scrollView.tag == 2) {
        CGFloat pageIndex = _scrollView.contentOffset.x / SCREEN_WIDTH - 1;
        //左循环滚动
        if (pageIndex < 0) {
            if (pageIndex > -1) return;
            
            //设置当前页数并滚动
            adPageControl.currentPage = adPageControl.numberOfPages - 1;
            [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * adPageControl.numberOfPages, _scrollView.contentOffset.y) animated:NO];
        //右循环滚动
        } else if (pageIndex > adPageControl.numberOfPages -1) {
            if (pageIndex < adPageControl.numberOfPages) return;
            
            //设置当前页数并滚动，默认滚动一屏
            adPageControl.currentPage = 0;
            [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, _scrollView.contentOffset.y) animated:NO];
        } else {
            adPageControl.currentPage = (int) pageIndex;
        }
    }
}

- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index
{
    //幻灯片，循环滚动
    if (pageControl.tag == 2) {
        [adView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * index + SCREEN_WIDTH, 0, SCREEN_WIDTH, 120) animated:YES];
    }
}

#pragma mark - reloadTypes
- (void) reloadTypes
{
    //去掉二级分类
    [self clearProperties];
    
    //移除旧的服务列表
    if (typeBtns && [typeBtns count] > 0) {
        for (SpringBoardButton *button in typeBtns) {
            button.hidden = YES;
            [button removeFromSuperview];
        }
    }
    
    //加载服务列表
    types = [NSMutableArray arrayWithArray:[self fetch:@"types"]];
    //添加
    CategoryEntity *addType = [[CategoryEntity alloc] init];
    addType.icon = @"homeItemAdd";
    addType.id = @-1;
    addType.name = @"增加";
    [types addObject:addType];
    /*
    //减少
    CategoryEntity *deleteType = [[CategoryEntity alloc] init];
    deleteType.icon = @"homeItemDelete";
    deleteType.id = @-2;
    deleteType.name = @"减少";
    [types addObject:deleteType];
    */
    
    //计算宽高
    CGFloat buttonWidth = 50;
    CGFloat buttonHeight = [self heightForTypeButton];
    NSInteger buttonSize = 4;
    CGFloat spaceWidth = (SCREEN_WIDTH - buttonSize * buttonWidth) / 4;
    CGFloat spaceHeight = (buttonHeight - 70) / 2;
    
    //服务选项
    typeBtns = [NSMutableArray array];
    
    //添加服务
    NSInteger typesCount = [types count];
    CGFloat frameX = 0;
    CGFloat frameY = 0;
    for (int i = 0; i < typesCount; i++) {
        CategoryEntity *type = [types objectAtIndex:i];
        
        //计算位置
        NSInteger itemRow = (int)(i / buttonSize) + 1;
        NSInteger itemCol = i % buttonSize + 1;
        frameX = spaceWidth / 2 + (buttonWidth + spaceWidth) * (itemCol - 1);
        frameY = buttonHeight * (itemRow - 1);
        
        //初始化按钮
        SpringBoardButton *button = [[SpringBoardButton alloc] initWithFrame:CGRectMake(frameX, frameY, buttonWidth, buttonHeight)];
        button.backgroundColor = COLOR_MAIN_CLEAR;
        button.tag = [type.id integerValue];
        button.delegate = self;
        button.boardView = typeView;
        //是否可编辑
        if ([type.id integerValue] < 1) {
            button.isEditable = NO;
        }
        if (![self isLogin]) {
            button.isEditable = NO;
        }
        [typeView addSubview:button];
        [typeBtns addObject:button];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        //图片
        if ([type.id integerValue] < 1) {
            iconView.image = [UIImage imageNamed:type.icon];
        } else {
            [type iconView:iconView placeholder:[UIImage imageNamed:@"homeItem"]];
        }
        [button addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_top).offset(spaceHeight + 2.5);
            make.centerX.equalTo(button.mas_centerX);
            make.width.equalTo(@(45));
            make.height.equalTo(@(45));
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = type.name;
        nameLabel.font = [UIFont systemFontOfSize:10];
        nameLabel.textColor = COLOR_MAIN_WHITE;
        [button addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_bottom).offset(2.5);
            make.centerX.equalTo(button.mas_centerX);
            make.height.equalTo(@20);
        }];
    }
    
    //计算容器宽高
    CGFloat contentY = frameY + buttonHeight;
    typeView.contentSize = CGSizeMake(SCREEN_WIDTH, contentY);
}

//计算高度，解决图标显示一半问题
- (CGFloat) heightForTypeButton
{
    //计算滚动视图总高度
    CGFloat totalHeight = middleHeight;
    //默认按钮高度
    CGFloat height = 80;
    
    //最小按钮高度
    if (totalHeight < height) {
        return height;
    }
    
    //剩下的高度平均分配
    NSInteger rowCount = (int)(totalHeight / 80);
    CGFloat spaceTotal = ((int)totalHeight) % 80;
    CGFloat spaceHeight = spaceTotal / rowCount;
    
    //默认高度+平均空隙
    return height + spaceHeight;
}

- (NSArray *) dataSourceForBoardItems:(UIView *)boardView
{
    return typeBtns;
}

- (void) actionBoardItemsStartEditing:(UIView *)boardView
{
    NSLog(@"开始编辑服务");
}

- (void) actionBoardItemsEndEditing:(UIView *)boardView
{
    [self saveTypes];
}

- (void) actionBoardItemClicked:(SpringBoardButton *)item
{
    //未登录
    if (![self isLogin]) {
        [self actionLogin];
        return;
    }
    
    //添加或减少
    if (item.tag < 1) {
        if (item.tag == -1) {
            [self actionAddType];
        } else {
            if ([typeBtns count] < 3) return;
            
            //切换编辑模式
            item.boardView.isSpringBoardEditing = !item.boardView.isSpringBoardEditing;
        }
    } else {
        [self actionCase:item];
    }
}

- (void) actionBoardItemMoved:(SpringBoardButton *)item toIndex:(NSInteger)index
{
    //类型
    NSInteger fromIndex = [typeBtns indexOfObject:item];
    [typeBtns exchangeObjectAtIndex:fromIndex withObjectAtIndex:index];
}

- (BOOL) shouldBoardItemDeleted:(SpringBoardButton *)item
{
    //类型
    if ([typeBtns count] > 3) {
        return YES;
    } else {
        [self actionError:@"请至少保留一个服务哦~亲！"];
        return NO;
    }
}

- (void) actionBoardItemDeleted:(SpringBoardButton *)item
{
    //类型
    [typeBtns removeObject:item];
    
    //自适应滚动视图
    CGSize contentSize = typeView.contentSize;
    NSInteger typesCount = [typeBtns count];
    
    CGFloat buttonHeight = [self heightForTypeButton];
    NSInteger buttonSize = 4;
    contentSize.height = ((int)((typesCount - 1) / buttonSize) + 1) * buttonHeight;
    typeView.contentSize = contentSize;
}

- (CGRect) deleteFrameForBoardItem:(SpringBoardButton *)item
{
    //计算宽高
    CGFloat buttonHeight = [self heightForTypeButton];
    CGFloat spaceHeight = (buttonHeight - 70) / 2;
    
    //调整删除按钮位置
    return CGRectMake(-10, spaceHeight - 10, 30, 30);
}

#pragma mark - reloadProperties
- (void) showProperties
{
    //显示二级分类
    typeView.hidden = YES;
    if (propertyView) {
        [propertyView removeFromSuperview];
    }
    
    //获取参数
    NSArray *properties = [self fetch:@"properties"];
    
    //属性容器
    propertyView = [[CasePropertyView alloc] init];
    propertyView.delegate = self;
    propertyView.backgroundColor = COLOR_MAIN_CLEAR;
    [middleView addSubview:propertyView];
    
    UIView *superview = middleView;
    [propertyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleView.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
    }];
    
    [propertyView assign:@"properties" value:properties];
    [propertyView display];
}

- (void) clearProperties
{
    //隐藏二级分类
    if (propertyView) {
        [propertyView removeFromSuperview];
    }
    
    if (typeView) {
        typeView.hidden = NO;
    }
}

- (void) actionSelected:(PropertyEntity *)property
{
    //取消
    if ([@-1 isEqualToNumber:property.id]) {
        [self clearProperties];
    //非取消
    } else {
        [self.delegate actionProperty:property];
    }
}

#pragma mark - Action
- (void) actionLogin
{
    [self.delegate actionLogin];
}

- (void) actionCase: (UIButton *)sender
{
    if (![self isLogin]) {
        [self actionLogin];
        return;
    }
    
    if (sender.tag < 1) return;
    
    [self.delegate actionCase:@(sender.tag)];
}

- (void)actionGps
{
    [self.delegate actionGps];
}

- (void)actionCity
{
    [self.delegate actionCity];
}

- (void)actionError: (NSString *) message
{
    [self.delegate actionError:message];
}


- (void)actionAddType
{
    //编辑模式不能添加
    if (typeView.isSpringBoardEditing) {
        [self actionError:@"请编辑完成后再添加哦~亲！"];
        return;
    }
    
    [self.delegate actionAddType];
}

- (void)saveTypes
{
    NSMutableArray *newTypes = [[NSMutableArray alloc] init];
    
    int sort = 0;
    for (SpringBoardButton *button in typeBtns) {
        if (button.tag < 1) continue;
        
        sort++;
        for (CategoryEntity *type in types) {
            if ([type.id isEqualToNumber:@(button.tag)]) {
                type.sort = @(sort);
                [newTypes addObject:type];
                break;
            }
        }
    }
    
    [self.delegate actionSaveTypes:newTypes];
}

@end
