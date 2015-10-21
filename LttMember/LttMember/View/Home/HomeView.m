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
    
    BOOL isLogin;
    NSNumber *categoryId;
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
    [typeView setPagingEnabled:NO];
    [typeView setSpringBoardDelegate:self];
    [middleView addSubview:typeView];
    
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recommendView.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom).offset(-80);
    }];
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
        if (recommend.icon && [recommend.icon length] > 0) {
            [recommend iconView:iconView];
        } else {
            iconView.image = [UIImage imageNamed:@"homeRecommend"];
        }
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
    NSMutableArray *categories = [NSMutableArray arrayWithArray:[self getData:@"categories"]];
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
        //图片
        if ([category.id integerValue] < 1) {
            iconView.image = [UIImage imageNamed:category.icon];
        } else {
            if (category.icon && [category.icon length] > 0) {
                [category iconView:iconView];
            } else {
                iconView.image = [UIImage imageNamed:@"homeGroup"];
            }
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
    
    //默认选中第一个
    if ([categories count] > 2) {
        [self actionCategory:[categoryBtns firstObject]];
    }
}

#pragma mark - reloadTypes
- (void) reloadTypes
{
    //todo: 未登录不能编辑菜单
    
    //移除旧的服务列表
    if (typeBtns && [typeBtns count] > 0) {
        for (SpringBoardButton *button in typeBtns) {
            button.hidden = YES;
            [button removeFromSuperview];
        }
    }
    
    //加载服务列表
    NSMutableArray *types = [NSMutableArray arrayWithArray:[self getData:@"types"]];
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
    CGFloat buttonHeight = 80;
    NSInteger buttonSize = 4;
    CGFloat spaceWidth = (SCREEN_WIDTH - buttonSize * buttonWidth) / 4;
    
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
            if (type.icon && [type.icon length] > 0) {
                [type iconView:iconView];
            } else {
                iconView.image = [UIImage imageNamed:@"homeItem"];
            }
        }
        [button addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_top).offset(10);
            make.left.equalTo(button.mas_left);
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@(buttonWidth));
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = type.name;
        nameLabel.font = [UIFont systemFontOfSize:10];
        nameLabel.textColor = COLOR_MAIN_WHITE;
        [button addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconView.mas_bottom);
            make.centerX.equalTo(button.mas_centerX);
            make.height.equalTo(@20);
        }];
    }
    
    //计算容器宽高
    CGFloat contentY = frameY + buttonHeight;
    typeView.contentSize = CGSizeMake(SCREEN_WIDTH, contentY);
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
        NSLog(@"startEditing");
    //类型
    } else {
        NSLog(@"startEditing");
    }
}

- (void) actionBoardItemsEndEditing:(UIView *)boardView
{
    //分类
    if (boardView.tag == 1) {
        NSLog(@"endEditing");
    //类型
    } else {
        NSLog(@"endEditing");
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
                
                for (SpringBoardButton *button in categoryBtns) {
                    button.isEditing = YES;
                }
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
                
                for (SpringBoardButton *button in typeBtns) {
                    button.isEditing = YES;
                }
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
        [categoryBtns removeObject:item];
        
        //自适应滚动视图
        CGSize contentSize = categoryView.contentSize;
        NSInteger categoriesCount = [categoryBtns count];
        
        CGFloat buttonWidth = 50;
        NSInteger buttonSize = 4;
        CGFloat spaceWidth = (SCREEN_WIDTH - buttonSize * buttonWidth) / 4;
        contentSize.width = (spaceWidth + buttonWidth) * categoriesCount;
        categoryView.contentSize = contentSize;
    //类型
    } else {
        [typeBtns removeObject:item];
        
        //自适应滚动视图
        CGSize contentSize = typeView.contentSize;
        NSInteger typesCount = [typeBtns count];
        
        CGFloat buttonHeight = 80;
        NSInteger buttonSize = 4;
        contentSize.height = ((int)((typesCount - 1) / buttonSize) + 1) * buttonHeight;
        typeView.contentSize = contentSize;
    }
}

- (CGRect) deleteFrameForBoardItem:(SpringBoardButton *)item
{
    //调整删除按钮位置
    return CGRectMake(-10, 0, 20, 20);
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
    categoryId = @(sender.tag);
    
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

- (void)actionError: (NSString *) message
{
    [self.delegate actionError:message];
}

- (void)actionAddCategory
{
    
}

- (void)actionAddType
{
    
}

@end
