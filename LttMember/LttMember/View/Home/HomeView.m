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

@interface HomeView () <SpringBoardButtonDelegate>

@end

@implementation HomeView
{
    UILabel *addressLabel;
    
    UIImageView *topView;
    UIImageView *middleView;
    UIImageView *bottomView;
    
    UIView *recommendView;
    UIScrollView *categoryView;
    UIScrollView *typeView;
    
    NSMutableArray *recommendBtns;
    NSMutableArray *categoryBtns;
    NSMutableArray *typeBtns;
}

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
        make.left.equalTo(superview.mas_left).offset(5);
        make.width.equalTo(@20);
        make.height.equalTo(@16);
    }];
    
    //当前位置
    UIButton *locationButton = [[UIButton alloc] init];
    locationButton.backgroundColor = [UIColor clearColor];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"homeAddress"] forState:UIControlStateNormal];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"homeAddress"] forState:UIControlStateHighlighted];
    [locationButton addTarget:self action:@selector(actionGps) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:locationButton];
    
    superview = topView;
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(statusHeight + 2.5);
        make.left.equalTo(menuButton.mas_right).offset(5);
        make.right.equalTo(superview.mas_right).offset(-5);
        make.height.equalTo(@25);
    }];
    
    UIImageView *pointView = [[UIImageView alloc] init];
    pointView.image = [UIImage imageNamed:@"homePoint"];
    pointView.contentMode = UIViewContentModeScaleAspectFit;
    [locationButton addSubview:pointView];
    
    superview = locationButton;
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left).offset(5);
        make.centerY.equalTo(superview.mas_centerY);
        make.height.equalTo(@13.5);
        make.width.equalTo(@18);
    }];
    
    addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"正在定位";
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.textColor = COLOR_MAIN_GRAY;
    [locationButton addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(pointView.mas_right).offset(2.5);
        make.height.equalTo(@20);
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
    
    /*
    //导航菜单
    menuView = [[UIView alloc] init];
    menuView.backgroundColor = COLOR_MAIN_WHITE;
    [self addSubview:menuView];
    
    UIView *superview = self;
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adView.mas_bottom).offset(2.5);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@50);
    }];
    
    //服务菜单
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = COLOR_MAIN_WHITE;
    scrollView.userInteractionEnabled = YES;
    [scrollView setPagingEnabled:NO];
    [scrollView setSpringBoardDelegate:self];
    [self addSubview:scrollView];
    
    superview = self;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(menuView.mas_bottom).offset(5);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom).offset(-(SCREEN_WIDTH * 0.22 * 0.8));
    }];
     */
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
    
    //加载新的分类列表
    NSMutableArray *recommends = [self getData:@"recommends"];
    
}

#pragma mark - reloadCategories
- (void) reloadCategories
{
    /*
    //移除旧的分类列表
    if (menuBtns && [menuBtns count] > 0) {
        for (UIButton *menuBtn in menuBtns) {
            menuBtn.hidden = YES;
            [menuBtn removeFromSuperview];
        }
    }
    
    //获取分类列表
    NSMutableArray *categories = [NSMutableArray arrayWithArray:[self getData:@"categories"]];
    //添加更多
    CategoryEntity *moreCategory = [[CategoryEntity alloc] init];
    moreCategory.icon = @"homeMore";
    moreCategory.id = @0;
    moreCategory.name = @"更多";
    [categories addObject:moreCategory];
    
    //菜单元素
    menuBtns = [NSMutableArray array];
    CGFloat btnWidth = SCREEN_WIDTH / 6;
    UIView *superview = menuView;
    separateView = nil;
    for (CategoryEntity *category in categories) {
        //菜单项
        UIButton *menuBtn = [[UIButton alloc] init];
        menuBtn.tag = [category.id integerValue];
        BOOL isMore = [@0 isEqualToNumber:category.id];
        //选择菜单
        if (!isMore) {
            [menuBtn addTarget:self action:@selector(actionCategory:) forControlEvents:UIControlEventTouchUpInside];
        //更多
        } else {
            [menuBtn addTarget:self action:@selector(actionMore) forControlEvents:UIControlEventTouchUpInside];
        }
        [superview addSubview:menuBtn];
        
        [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superview.mas_top);
            make.left.equalTo(separateView ? separateView.mas_right : superview.mas_left);
            make.bottom.equalTo(superview.mas_bottom);
            make.width.equalTo(@(btnWidth));
        }];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        if (!isMore) {
            [category groupIconView:iconView];
        } else {
            iconView.image = [UIImage imageNamed:category.icon];
        }
        [menuBtn addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(menuBtn.mas_centerX);
            make.centerY.equalTo(menuBtn.mas_top).offset(15);
            make.width.equalTo(@25);
            make.height.equalTo(@25);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.tag = -1;
        nameLabel.text = category.name;
        nameLabel.font = [UIFont systemFontOfSize:10];
        nameLabel.textColor = COLOR_MAIN_DARK;
        [menuBtn addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_bottom).offset(5);
            make.centerX.equalTo(menuBtn.mas_centerX);
            make.height.equalTo(@10);
        }];
        
        UIView *sepView = [[UIView alloc] init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
        [menuBtn addSubview:sepView];
        
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(menuBtn.mas_right).offset(1);
            make.centerY.equalTo(menuBtn.mas_centerY);
            make.width.equalTo(@1);
            make.height.equalTo(@40);
        }];
        
        UIView *selectedView = [[UIView alloc] init];
        selectedView.tag = -2;
        selectedView.backgroundColor = COLOR_MAIN_WHITE;
        [menuBtn addSubview:selectedView];
        
        [selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(menuBtn.mas_bottom);
            make.left.equalTo(menuBtn.mas_left);
            make.right.equalTo(menuBtn.mas_right);
            make.height.equalTo(@1.5);
        }];
        
        [menuBtns addObject:menuBtn];
        separateView = menuBtn;
    }
    
    //默认选中第一个
    if ([categories count] > 1) {
        [self actionCategory:[menuBtns firstObject]];
    }
    */
}

#pragma mark - reloadTypes
- (void) reloadTypes
{
    /*
    //todo: 未登录不能编辑菜单
    
    //移除旧的服务列表
    if (itemBtns && [itemBtns count] > 0) {
        for (SpringBoardButton *itemBtn in itemBtns) {
            itemBtn.hidden = YES;
            [itemBtn removeFromSuperview];
        }
    }
    
    //加载服务列表
    NSMutableArray *types = [self getData:@"types"];
    //添加服务
    CategoryEntity *addItem = [[CategoryEntity alloc] init];
    addItem.icon = @"homeAdd";
    addItem.id = @0;
    addItem.name = @"添加";
    addItem.detail = @"添加你想要的服务";
    [types addObject:addItem];
    
    //服务选项
    itemBtns = [NSMutableArray array];
    
    //计算宽高
    CGFloat itemWidth = 50;
    CGFloat itemHeight = 60;
    NSInteger itemLine = 4;
    CGFloat itemSpaceW = (SCREEN_WIDTH - itemLine * itemWidth) / (itemLine + 1);
    CGFloat itemSpaceH = 20;
    
    //添加元素
    int i = 0;
    CGFloat contentHeight = 0;
    for (CategoryEntity *type in types) {
        i++;
        BOOL isAdd = [@0 isEqualToNumber:type.id];
        
        //计算位置
        NSInteger itemRow = (i % itemLine) == 0 ? (i / itemLine) : ((int)(i / itemLine)) + 1;
        NSInteger itemCol = (i % itemLine) == 0 ? itemLine : (i % itemLine);
        CGFloat itemX = itemSpaceW + (itemWidth + itemSpaceW) * (itemCol - 1);
        CGFloat itemY = itemSpaceH + (itemHeight + itemSpaceH) * (itemRow - 1);
        CGRect itemFrame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        contentHeight = itemY + itemHeight + itemSpaceH;
        
        //初始化按钮
        SpringBoardButton *editButton = [[SpringBoardButton alloc] initWithFrame:itemFrame];
        editButton.tag = [type.id integerValue];
        editButton.delegate = self;
        //添加按钮
        if (isAdd) {
            editButton.isEditable = NO;
        }
        [scrollView addSubview:editButton];
        [itemBtns addObject:editButton];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        if (!isAdd) {
            [type itemIconView:iconView];
        } else {
            iconView.image = [UIImage imageNamed:type.icon];
        }
        [editButton addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(editButton.mas_centerX);
            make.centerY.equalTo(editButton.mas_top).offset(15);
            make.width.equalTo(@25);
            make.height.equalTo(@25);
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.tag = -1;
        nameLabel.text = type.name;
        nameLabel.font = [UIFont systemFontOfSize:10];
        nameLabel.textColor = COLOR_MAIN_DARK;
        [editButton addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_bottom).offset(5);
            make.centerX.equalTo(editButton.mas_centerX);
            make.height.equalTo(@10);
        }];
    }
    
    //设置scrollView容器宽高
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight);
    */
}

- (void) adjustScrollView
{
    //计算宽高
    CGFloat itemHeight = 60;
    NSInteger itemLine = 4;
    CGFloat itemSpaceH = 20;
    
    NSInteger i = [typeBtns count];
    NSInteger maxRow = (i % itemLine) == 0 ? (i / itemLine) : ((int)(i / itemLine)) + 1;
    CGFloat itemY = itemSpaceH + (itemHeight + itemSpaceH) * (maxRow - 1);
    CGFloat contentHeight = itemY + itemHeight + itemSpaceH;
    
    typeView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight);
}

- (NSArray *) dataSourceForBoardItems:(UIView *)boardView
{
    return typeBtns;
}

- (void) actionBoardItemsStartEditing:(UIView *)boardView
{
    NSLog(@"startEditing");
    
    //todo: 编辑模式禁用右滑菜单
}

- (void) actionBoardItemsEndEditing:(UIView *)boardView
{
    NSLog(@"endEditing");
    
    //todo: 非编辑模式启用右滑菜单
}

- (void) actionBoardItemClicked:(SpringBoardButton *)item
{
    //添加按钮
    if (item.tag < 1) {
        [self actionBoardItemAdd];
        return;
    }
    
    NSLog(@"clicked");
    [self actionCase:item];
}

- (void) actionBoardItemAdd
{
    NSLog(@"add");
}

- (void) actionBoardItemMoved:(SpringBoardButton *)item toIndex:(NSInteger)index
{
    NSInteger fromIndex = [typeBtns indexOfObject:item];
    [typeBtns exchangeObjectAtIndex:fromIndex withObjectAtIndex:index];
}

- (BOOL) shouldBoardItemDeleted:(SpringBoardButton *)item
{
    return [typeBtns count] > 2 ? YES : NO;
}

- (void) actionBoardItemDeleted:(SpringBoardButton *)item
{
    [typeBtns removeObject:item];
    
    //自适应滚动视图
    [self adjustScrollView];
}

#pragma mark - Action
- (void) actionMenu
{
    [self.delegate actionMenu];
}

- (void) actionCategory: (UIButton *)sender
{
    [self.delegate actionCategory:@(sender.tag)];
}

- (void) actionCase: (UIButton *)sender
{
    if (sender.tag < 1) return;
    
    [self.delegate actionCase:@(sender.tag)];
}

- (void)actionGps
{
    [self.delegate actionGps];
}

@end
