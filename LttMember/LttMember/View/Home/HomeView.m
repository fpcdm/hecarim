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

@interface HomeView () <SpringBoardButtonDelegate, UIScrollViewDelegate, TAPageControlDelegate, CasePropertyViewDelegate>

@end

@implementation HomeView
{
    UILabel *addressLabel;
    UIButton *cityButton;
    
    UIImageView *topView;
    UIImageView *middleView;
    UIImageView *bottomView;
    
    UIView *recommendView;
    UIScrollView *categoryView;
    CasePropertyView *propertyView;
    
    NSMutableArray *recommendBtns;
    NSMutableArray *categoryBtns;
    NSMutableArray *typeBtns;
    
    BOOL isLogin;
    NSNumber *categoryId;
    CategoryEntity *categoryEntity;
    UIButton *categoryButton;
    NSMutableArray *categories;
    NSMutableArray *types;
    TAPageControl *pageControl;
}

@synthesize typeView;

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    [self topView];
    [self middleView];
    [self bottomView];
    
    return self;
}

- (void) topView
{
    //计算参数
    CGFloat imageHeight = SCREEN_WIDTH * 0.548;
    CGFloat statusHeight = SCREEN_STATUSBAR_HEIGHT;
    
    //顶部容器
    topView = [[UIImageView alloc] init];
    topView.image = [UIImage imageNamed:@"homeAd"];
    topView.userInteractionEnabled = YES;
    [self addSubview:topView];
    
    UIView *superview = self;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@(imageHeight));
    }];
    
    //菜单图标
    UIButton *menuButton = [[UIButton alloc] init];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"homeMenu"] forState:UIControlStateNormal];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"homeMenu"] forState:UIControlStateHighlighted];
    [menuButton addTarget:self action:@selector(actionMenu) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview: menuButton];
    
    superview = topView;
    [menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(statusHeight + 7);
        make.left.equalTo(superview.mas_left).offset(10);
        make.width.equalTo(@20);
        make.height.equalTo(@16);
    }];
    
    //城市切换按钮
    cityButton = [[UIButton alloc] init];
    cityButton.titleLabel.font = FONT_MIDDLE;
    [cityButton setTitleColor:COLOR_MAIN_WHITE forState:UIControlStateNormal];
    [cityButton setTitle:@"切换城市" forState:UIControlStateNormal];
    [cityButton.titleLabel sizeToFit];
    [cityButton addTarget:self action:@selector(actionCity) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cityButton];
    
    superview = topView;
    [cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(statusHeight + 2.5 + 5.5);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@14);
    }];
    
    //当前位置
    UIButton *locationButton = [[UIButton alloc] init];
    locationButton.backgroundColor = [UIColor clearColor];
    [locationButton addTarget:self action:@selector(actionGps) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:locationButton];
    
    superview = topView;
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(statusHeight + 2.5);
        make.left.equalTo(menuButton.mas_right).offset(10);
        make.right.equalTo(cityButton.mas_left).offset(-10);
        make.height.equalTo(@25);
    }];
    
    UIImageView *pointView = [[UIImageView alloc] init];
    pointView.image = [UIImage imageNamed:@"homePoint"];
    pointView.contentMode = UIViewContentModeScaleAspectFit;
    [locationButton addSubview:pointView];
    
    superview = locationButton;
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left);
        make.centerY.equalTo(superview.mas_centerY);
        make.height.equalTo(@13.5);
        make.width.equalTo(@18);
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
    addressLabel.font = FONT_SMALL;
    addressLabel.textColor = COLOR_MAIN_WHITE;
    [addressView addSubview:addressLabel];
    
    superview = addressView;
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(superview.mas_height);
    }];
}

- (void) middleView
{
    //中部容器
    middleView = [[UIImageView alloc] init];
    middleView.image = [UIImage imageNamed:@"homeBg"];
    middleView.alpha = 0.9;
    middleView.userInteractionEnabled = YES;
    [self addSubview:middleView];
    
    UIView *superview = self;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
    }];
    
    //推荐菜单
    recommendView = [[UIView alloc] init];
    recommendView.backgroundColor = COLOR_MAIN_CLEAR;
    [middleView addSubview:recommendView];
    
    superview = middleView;
    [recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@(100));
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
    
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recommendView.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom).offset(-80);
    }];
    
    //添加左右滑动事件
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [typeView addGestureRecognizer:leftRecognizer];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [typeView addGestureRecognizer:rightRecognizer];
}

- (void) bottomView
{
    //计算高度
    CGFloat bottomHeight = 80;
    
    //底部容器
    bottomView = [[UIImageView alloc] init];
    bottomView.image = [UIImage imageNamed:@"homeGroupBg"];
    bottomView.userInteractionEnabled = YES;
    [self addSubview:bottomView];
    
    UIView *superview = self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
        make.height.equalTo(@(bottomHeight));
    }];
    
    //分类菜单
    categoryView = [[UIScrollView alloc] init];
    categoryView.backgroundColor = COLOR_MAIN_CLEAR;
    categoryView.tag = 1;
    categoryView.delegate = self;
    categoryView.showsHorizontalScrollIndicator = NO;
    categoryView.showsVerticalScrollIndicator = NO;
    [categoryView setPagingEnabled:NO];
    [categoryView setSpringBoardDelegate:self];
    [bottomView addSubview:categoryView];
    
    superview = bottomView;
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
    }];
}

#pragma mark - setLogin
- (void) setLogin:(BOOL)login
{
    isLogin = login;
}

#pragma mark - RenderData
- (void) renderData
{
    //显示位置
    NSString *address = [self getData:@"address"];
    NSString *gps = [self getData:@"gps"];
    if (address) {
        NSNumber *count = [self getData:@"count"];
        if (count && ![@-1 isEqualToNumber:count]) {
            address = [NSString stringWithFormat:@"%@(有%@位信使为您服务)", address, count];
        }
        addressLabel.text = address;
    } else if (gps) {
        addressLabel.text = gps;
    }
    
    //显示城市
    NSString *city = [self getData:@"city"];
    if (city && [city length] > 0) {
        [cityButton setTitle:city forState:UIControlStateNormal];
        [cityButton.titleLabel sizeToFit];
    }
}

#pragma mark - reloadRecommends
- (void) reloadRecommends
{
    //移除旧的推荐列表
    if (recommendBtns && [recommendBtns count] > 0) {
        for (UIButton *button in recommendBtns) {
            button.hidden = YES;
            [button removeFromSuperview];
        }
    }
    
    //计算宽高
    CGFloat buttonWidth = 50;
    CGFloat buttonHeight = 100;
    NSInteger buttonSize = 4;
    CGFloat spaceWidth = (SCREEN_WIDTH - buttonSize * buttonWidth) / 4;
    
    //加载新的分类列表
    NSMutableArray *recommends = [self getData:@"recommends"];
    NSInteger recommendsCount = recommends ? [recommends count] : 0;
    
    recommendBtns = [NSMutableArray array];
    CGFloat frameX = 0;
    for (int i = 0; i < recommendsCount; i++) {
        CategoryEntity *recommend = [recommends objectAtIndex:i];
        
        //计算当前X坐标
        frameX += i == 0 ? spaceWidth / 2 : spaceWidth + buttonWidth;
        
        //推荐项
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, 0, buttonWidth, buttonHeight)];
        button.backgroundColor = COLOR_MAIN_CLEAR;
        button.tag = [recommend.id integerValue];
        [button addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
        [recommendView addSubview:button];
        [recommendBtns addObject:button];
        
        //添加图标
        UIImageView *iconView = [[UIImageView alloc] init];
        [recommend iconView:iconView placeholder:[UIImage imageNamed:@"homeRecommend"]];
        [button addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_top).offset(10);
            make.left.equalTo(button.mas_left);
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonWidth));
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = recommend.name;
        nameLabel.font = [UIFont systemFontOfSize:10];
        nameLabel.textColor = [UIColor colorWithHexString:@"FEFFFD"];
        [button addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_bottom).offset(5);
            make.centerX.equalTo(button.mas_centerX);
            make.height.equalTo(@15);
        }];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        detailLabel.text = recommend.remark;
        detailLabel.font = [UIFont systemFontOfSize:10];
        detailLabel.textColor = [UIColor colorWithHexString:@"D2D2D2" alpha:0.52];
        [button addSubview:detailLabel];
        
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom);
            make.centerX.equalTo(button.mas_centerX);
            make.height.equalTo(@15);
        }];
    }
}

#pragma mark - reloadCategories
- (void) reloadCategories
{
    //移除旧的分类列表
    if (categoryBtns && [categoryBtns count] > 0) {
        for (UIButton *button in categoryBtns) {
            button.hidden = YES;
            [button removeFromSuperview];
        }
    }
    
    //获取分类列表
    categories = [NSMutableArray arrayWithArray:[self getData:@"categories"]];
    //添加
    CategoryEntity *addCategory = [[CategoryEntity alloc] init];
    addCategory.icon = @"homeGroupAdd";
    addCategory.id = @-1;
    addCategory.name = @"增加";
    [categories addObject:addCategory];
    //减少
    CategoryEntity *deleteCategory = [[CategoryEntity alloc] init];
    deleteCategory.icon = @"homeGroupDelete";
    deleteCategory.id = @-2;
    deleteCategory.name = @"减少";
    [categories addObject:deleteCategory];
    
    //计算宽高
    CGFloat buttonWidth = 50;
    CGFloat buttonHeight = 80;
    NSInteger buttonSize = 4;
    CGFloat spaceWidth = (SCREEN_WIDTH - buttonSize * buttonWidth) / 4;
    
    //分类列表
    NSInteger categoriesCount = [categories count];
    
    categoryBtns = [NSMutableArray array];
    CGFloat frameX = 0;
    for (int i = 0; i < categoriesCount; i++) {
        CategoryEntity *category = [categories objectAtIndex:i];
        
        //计算当前X坐标
        frameX += i == 0 ? spaceWidth / 2 : spaceWidth + buttonWidth;
        
        //初始化按钮
        SpringBoardButton *button = [[SpringBoardButton alloc] initWithFrame:CGRectMake(frameX, 0, buttonWidth, buttonHeight)];
        button.backgroundColor = COLOR_MAIN_CLEAR;
        button.tag = [category.id integerValue];
        button.delegate = self;
        button.boardView = categoryView;
        //是否可编辑
        if ([category.id integerValue] < 1) {
            button.isEditable = NO;
        }
        if (!isLogin) {
            button.isEditable = NO;
        }
        [categoryView addSubview:button];
        [categoryBtns addObject:button];
        
        //添加图标
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.tag = -9;
        //图片
        if ([category.id integerValue] < 1) {
            iconView.image = [UIImage imageNamed:category.icon];
        } else {
            [category iconView:iconView placeholder:[UIImage imageNamed:@"homeGroup"]];
        }
        [button addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_top).offset(10);
            make.left.equalTo(button.mas_left);
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonWidth));
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = category.name;
        nameLabel.font = FONT_SMALL;
        nameLabel.textColor = COLOR_MAIN_WHITE;
        [button addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_bottom);
            make.centerX.equalTo(button.mas_centerX);
            make.height.equalTo(@20);
        }];
    }
    
    //计算容器宽高
    CGFloat contentX = frameX + buttonWidth + spaceWidth / 2;
    categoryView.contentSize = CGSizeMake(contentX, buttonHeight);
    
    //移除旧控件
    if (pageControl) {
        [pageControl removeFromSuperview];
        pageControl = nil;
    }
    
    //切换控件
    pageControl = [[TAPageControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    pageControl.alpha = 0.8;
    pageControl.dotSize = CGSizeMake(5, 5);
    pageControl.numberOfPages = (int)((categoriesCount - 1) / buttonSize) + 1;
    pageControl.delegate = self;
    [bottomView addSubview:pageControl];
    
    //默认选中第一个
    if ([categories count] > 2) {
        [self actionCategory:[categoryBtns firstObject]];
    }
}

#pragma mark - TAPageControl
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    NSInteger pageIndex = _scrollView.contentOffset.x / SCREEN_WIDTH;
    pageControl.currentPage = pageIndex;
}

- (void)TAPageControl:(TAPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index
{
    [categoryView scrollRectToVisible:CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, 120) animated:YES];
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
    types = [NSMutableArray arrayWithArray:[self getData:@"types"]];
    //添加
    CategoryEntity *addType = [[CategoryEntity alloc] init];
    addType.icon = @"homeItemAdd";
    addType.id = @-1;
    addType.name = @"增加";
    [types addObject:addType];
    //减少
    CategoryEntity *deleteType = [[CategoryEntity alloc] init];
    deleteType.icon = @"homeItemDelete";
    deleteType.id = @-2;
    deleteType.name = @"减少";
    [types addObject:deleteType];
    
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
        if (!isLogin) {
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
    typeView.contentOffset = CGPointMake(0, 0);
}

//计算高度，解决图标显示一半问题
- (CGFloat) heightForTypeButton
{
    //计算滚动视图总高度
    CGFloat totalHeight = SCREEN_HEIGHT - SCREEN_WIDTH * 0.548 - 100 - 80;
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
    //分类
    if (boardView.tag == 1) {
        return categoryBtns;
    //类型
    } else {
        return typeBtns;
    }
}

- (void) actionBoardItemsStartEditing:(UIView *)boardView
{
    //分类
    if (boardView.tag == 1) {
        NSLog(@"开始编辑分类");
    //类型
    } else {
        NSLog(@"开始编辑服务");
    }
}

- (void) actionBoardItemsEndEditing:(UIView *)boardView
{
    //分类
    if (boardView.tag == 1) {
        [self saveCategories];
    //类型
    } else {
        [self saveTypes];
    }
}

- (void) actionBoardItemClicked:(SpringBoardButton *)item
{
    //分类
    if (item.boardView.tag == 1) {
        //添加或减少
        if (item.tag < 1) {
            //未登录
            if (!isLogin) {
                [self actionLogin];
                return;
            }
            
            //添加或减少
            if (item.tag == -1) {
                [self actionAddCategory];
            } else {
                if ([categoryBtns count] < 3) return;
                
                //切换编辑模式
                item.boardView.isSpringBoardEditing = !item.boardView.isSpringBoardEditing;
            }
        } else {
            [self actionCategory:item];
        }
    //服务
    } else {
        //未登录
        if (!isLogin) {
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
}

- (void) actionBoardItemMoved:(SpringBoardButton *)item toIndex:(NSInteger)index
{
    //分类
    if (item.boardView.tag == 1) {
        NSInteger fromIndex = [categoryBtns indexOfObject:item];
        [categoryBtns exchangeObjectAtIndex:fromIndex withObjectAtIndex:index];
    //类型
    } else {
        NSInteger fromIndex = [typeBtns indexOfObject:item];
        [typeBtns exchangeObjectAtIndex:fromIndex withObjectAtIndex:index];
    }
}

- (BOOL) shouldBoardItemDeleted:(SpringBoardButton *)item
{
    //分类
    if (item.boardView.tag == 1) {
        if ([categoryBtns count] > 3) {
            return YES;
        } else {
            [self actionError:@"请至少保留一个场景哦~亲！"];
            return NO;
        }
    //类型
    } else {
        if ([typeBtns count] > 3) {
            return YES;
        } else {
            [self actionError:@"请至少保留一个服务哦~亲！"];
            return NO;
        }
    }
}

- (void) actionBoardItemDeleted:(SpringBoardButton *)item
{
    //分类
    if (item.boardView.tag == 1) {
        //是否删除当前分类
        BOOL isCurrent = NO;
        if (categoryId && [categoryId isEqualToNumber:@(item.tag)]) {
            isCurrent = YES;
        }
        
        [categoryBtns removeObject:item];
        
        //自适应滚动视图
        CGSize contentSize = categoryView.contentSize;
        NSInteger categoriesCount = [categoryBtns count];
        
        CGFloat buttonWidth = 50;
        NSInteger buttonSize = 4;
        CGFloat spaceWidth = (SCREEN_WIDTH - buttonSize * buttonWidth) / 4;
        contentSize.width = (spaceWidth + buttonWidth) * categoriesCount;
        categoryView.contentSize = contentSize;
        
        //删除当前分类重新加载服务列表
        if (isCurrent) {
            [self actionCategory:[categoryBtns firstObject]];
        }
    //类型
    } else {
        [typeBtns removeObject:item];
        
        //自适应滚动视图
        CGSize contentSize = typeView.contentSize;
        NSInteger typesCount = [typeBtns count];
        
        CGFloat buttonHeight = [self heightForTypeButton];
        NSInteger buttonSize = 4;
        contentSize.height = ((int)((typesCount - 1) / buttonSize) + 1) * buttonHeight;
        typeView.contentSize = contentSize;
    }
}

- (CGRect) deleteFrameForBoardItem:(SpringBoardButton *)item
{
    //分类
    if (item.boardView.tag == 1) {
        //调整删除按钮位置
        return CGRectMake(-10, 0, 30, 30);
    //类型
    } else {
        //计算宽高
        CGFloat buttonHeight = [self heightForTypeButton];
        CGFloat spaceHeight = (buttonHeight - 70) / 2;
        
        //调整删除按钮位置
        return CGRectMake(-10, spaceHeight - 10, 30, 30);
    }
}

#pragma mark - handleSwipeGesture
- (void)handleSwipeGesture:(UISwipeGestureRecognizer *)recognizer
{
    //是否处于编辑模式
    if (typeView.isSpringBoardEditing || categoryView.isSpringBoardEditing) return;
    
    //未选择分类，返回
    if (!categoryButton) return;
    if (![categoryBtns containsObject:categoryButton]) return;
    
    //获取当前索引
    NSInteger index = [categoryBtns indexOfObject:categoryButton];
    NSInteger maxIndex = [categoryBtns count] - 3;
    
    //左滑动
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (index == maxIndex) return;
        
        NSInteger newIndex = index + 1;
        if (newIndex > maxIndex) return;
        
        UIButton *button = [categoryBtns objectAtIndex:newIndex];
        if (button) {
            [self actionCategory:button];
            
            //自动滚动菜单
            CGFloat buttonWidth = 50;
            NSInteger buttonSize = 4;
            CGFloat spaceWidth = (SCREEN_WIDTH - buttonSize * buttonWidth) / 4;
            
            CGPoint contentOffset = categoryView.contentOffset;
            contentOffset.x += (buttonWidth + spaceWidth);
            if (contentOffset.x > categoryView.contentSize.width - SCREEN_WIDTH) {
                contentOffset.x = categoryView.contentSize.width - SCREEN_WIDTH;
            }
            [categoryView setContentOffset:contentOffset animated:YES];
        }
    //右滑动
    } else {
        if (index < 1) return;
        
        NSInteger newIndex = index - 1;
        if (newIndex < 0) return;
        
        UIButton *button = [categoryBtns objectAtIndex:newIndex];
        if (button) {
            [self actionCategory:button];
            
            //自动滚动菜单
            CGFloat buttonWidth = 50;
            NSInteger buttonSize = 4;
            CGFloat spaceWidth = (SCREEN_WIDTH - buttonSize * buttonWidth) / 4;
            
            CGPoint contentOffset = categoryView.contentOffset;
            contentOffset.x -= (buttonWidth + spaceWidth);
            if (contentOffset.x < 0) {
                contentOffset.x = 0;
            }
            [categoryView setContentOffset:contentOffset animated:YES];
        }
    }
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
    NSArray *properties = [self getData:@"properties"];
    
    //属性容器
    propertyView = [[CasePropertyView alloc] init];
    propertyView.delegate = self;
    propertyView.backgroundColor = COLOR_MAIN_CLEAR;
    [middleView addSubview:propertyView];
    
    UIView *superview = middleView;
    [propertyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recommendView.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom).offset(-80);
    }];
    
    [propertyView setData:@"properties" value:properties];
    [propertyView renderData];
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

- (void) actionMenu
{
    if (!isLogin) {
        [self actionLogin];
        return;
    }
    
    [self.delegate actionMenu];
}

- (void) actionCategory: (UIButton *)sender
{
    if (sender.tag < 1) return;
    
    //未修改分类
    NSNumber *newCategoryId = @(sender.tag);
    if (categoryId && [categoryId isEqualToNumber:newCategoryId]) {
        if (categoryEntity) {
            //选中效果
            UIImageView *iconView = (UIImageView *) [sender viewWithTag:-9];
            [categoryEntity selectedIconView:iconView placeholder:[UIImage imageNamed:@"homeGroupSelected"]];
        }
        return;
    }
    
    //获取分类
    CategoryEntity *newCategory = nil;
    for (CategoryEntity *category in categories) {
        if (category.id && [category.id isEqualToNumber:newCategoryId]) {
            newCategory = category;
            break;
        }
    }
    
    //选择新按钮，取消选择旧按钮
    UIImageView *iconView = (UIImageView *) [sender viewWithTag:-9];
    [newCategory selectedIconView:iconView placeholder:[UIImage imageNamed:@"homeGroupSelected"]];
    
    //取消选择旧按钮
    if (categoryEntity && categoryButton) {
        UIImageView *iconView = (UIImageView *) [categoryButton viewWithTag:-9];
        [categoryEntity iconView:iconView placeholder:[UIImage imageNamed:@"homeGroup"]];
    }
    
    //加载新的分类
    categoryId = newCategoryId;
    categoryEntity = newCategory;
    categoryButton = sender;
    
    //移除旧的服务列表
    if (typeBtns && [typeBtns count] > 0) {
        for (SpringBoardButton *button in typeBtns) {
            button.hidden = YES;
            [button removeFromSuperview];
        }
    }
    
    [self.delegate actionCategory:categoryId];
}

- (void) actionCase: (UIButton *)sender
{
    if (!isLogin) {
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

- (void)actionAddCategory
{
    //编辑模式不能添加
    if (categoryView.isSpringBoardEditing) {
        [self actionError:@"请编辑完成后再添加哦~亲！"];
        return;
    }
    
    [self.delegate actionAddCategory];
}

- (void)actionAddType
{
    //编辑模式不能添加
    if (typeView.isSpringBoardEditing) {
        [self actionError:@"请编辑完成后再添加哦~亲！"];
        return;
    }
    
    if (!categoryId) return;
    
    [self.delegate actionAddType:categoryId];
}

- (void)saveCategories
{
    NSMutableArray *newCategories = [[NSMutableArray alloc] init];
    
    int sort = 0;
    for (SpringBoardButton *button in categoryBtns) {
        if (button.tag < 1) continue;
        
        sort++;
        for (CategoryEntity *category in categories) {
            if ([category.id isEqualToNumber:@(button.tag)]) {
                category.sort = @(sort);
                [newCategories addObject:category];
                break;
            }
        }
    }
    
    [self.delegate actionSaveCategories:newCategories];
}

- (void)saveTypes
{
    if (!categoryId) return;
    
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
    
    [self.delegate actionSaveTypes:categoryId types:newTypes];
}

@end
