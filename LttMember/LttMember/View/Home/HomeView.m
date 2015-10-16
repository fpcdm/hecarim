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

#define Duration 0.2

@interface HomeView () <SpringBoardButtonDelegate>

@end

@implementation HomeView
{
    UILabel *addressLabel;
    UIView *separateView;
    
    UIImageView *adView;
    UIView *menuView;
    
    NSMutableArray *menuBtns;
    NSMutableArray *itemBtns;
}

@synthesize scrollView;

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    [self topView];
    [self middleView];
    [self bottomView];
    
    return self;
}

- (void) topView
{
    //计算参数
    CGFloat imageHeight = (SCREEN_WIDTH - 5) * 0.445;
    
    //顶部容器
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = COLOR_MAIN_WHITE;
    [self addSubview:topView];
    
    UIView *superview = self;
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.height.equalTo(@(25 + imageHeight));
    }];
    
    //当前位置
    UIButton *locationButton = [[UIButton alloc] init];
    locationButton.backgroundColor = [UIColor colorWithHexString:@"EFEFEF"];
    locationButton.layer.cornerRadius = 3.0f;
    [locationButton addTarget:self action:@selector(actionGps) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:locationButton];
    
    superview = topView;
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(2.5);
        make.left.equalTo(superview.mas_left).offset(2.5);
        make.right.equalTo(superview.mas_right).offset(-2.5);
        make.height.equalTo(@20);
    }];
    
    UIImageView *pointView = [[UIImageView alloc] init];
    pointView.image = [UIImage imageNamed:@"homePoint"];
    [locationButton addSubview:pointView];
    
    superview = locationButton;
    [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left).offset(5);
        make.centerY.equalTo(superview.mas_centerY);
        make.height.equalTo(@16);
        make.width.equalTo(@16);
    }];
    
    addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"正在定位";
    addressLabel.font = [UIFont systemFontOfSize:10];
    addressLabel.textColor = COLOR_MAIN_DARK;
    [locationButton addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(pointView.mas_right).offset(5);
        make.height.equalTo(@20);
    }];
    
    //图片
    adView = [[UIImageView alloc] init];
    adView.layer.cornerRadius = 3.0f;
    adView.image = [UIImage imageNamed:@"homeAd"];
    [topView addSubview:adView];
    
    superview = topView;
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(locationButton.mas_bottom).offset(2.5);
        make.left.equalTo(superview.mas_left).offset(2.5);
        make.right.equalTo(superview.mas_right).offset(-2.5);
        make.height.equalTo(@(imageHeight));
    }];
}

- (void) middleView
{
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
}

- (void) bottomView
{
    //计算参数
    CGFloat btnWidth = SCREEN_WIDTH  * 0.22;
    CGFloat btnHeight = btnWidth * 0.8;
    CGFloat spaceWidth = SCREEN_WIDTH * 0.12 / 7;
    
    //底部容器
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = COLOR_MAIN_WHITE;
    [self addSubview:bottomView];
    
    UIView *superview = self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
        make.height.equalTo(@(btnHeight));
    }];
    
    //底部按钮
    UIButton *caseBtn1 = [[UIButton alloc] init];
    caseBtn1.layer.cornerRadius = 3.0f;
    [caseBtn1 setBackgroundImage:[UIImage imageNamed:@"homeBtn1"] forState:UIControlStateNormal];
    [caseBtn1 setBackgroundImage:[UIImage imageNamed:@"homeBtn1"] forState:UIControlStateHighlighted];
    [bottomView addSubview:caseBtn1];
    
    superview = bottomView;
    [caseBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview.mas_left).offset(spaceWidth * 2);
        make.bottom.equalTo(superview.mas_bottom);
        make.width.equalTo(@(btnWidth));
        make.height.equalTo(@(btnHeight));
    }];
    
    UIButton *caseBtn2 = [[UIButton alloc] init];
    caseBtn2.layer.cornerRadius = 3.0f;
    [caseBtn2 setBackgroundImage:[UIImage imageNamed:@"homeBtn2"] forState:UIControlStateNormal];
    [caseBtn2 setBackgroundImage:[UIImage imageNamed:@"homeBtn2"] forState:UIControlStateHighlighted];
    [bottomView addSubview:caseBtn2];
    
    [caseBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(caseBtn1.mas_right).offset(spaceWidth);
        make.bottom.equalTo(superview.mas_bottom);
        make.width.equalTo(@(btnWidth));
        make.height.equalTo(@(btnHeight));
    }];
    
    UIButton *caseBtn3 = [[UIButton alloc] init];
    caseBtn3.layer.cornerRadius = 3.0f;
    [caseBtn3 setBackgroundImage:[UIImage imageNamed:@"homeBtn3"] forState:UIControlStateNormal];
    [caseBtn3 setBackgroundImage:[UIImage imageNamed:@"homeBtn3"] forState:UIControlStateHighlighted];
    [bottomView addSubview:caseBtn3];
    
    [caseBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(caseBtn2.mas_right).offset(spaceWidth);
        make.bottom.equalTo(superview.mas_bottom);
        make.width.equalTo(@(btnWidth));
        make.height.equalTo(@(btnHeight));
    }];
    
    UIButton *caseBtn4 = [[UIButton alloc] init];
    caseBtn4.layer.cornerRadius = 3.0f;
    [caseBtn4 setBackgroundImage:[UIImage imageNamed:@"homeBtn4"] forState:UIControlStateNormal];
    [caseBtn4 setBackgroundImage:[UIImage imageNamed:@"homeBtn4"] forState:UIControlStateHighlighted];
    [bottomView addSubview:caseBtn4];
    
    [caseBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(caseBtn3.mas_right).offset(spaceWidth);
        make.bottom.equalTo(superview.mas_bottom);
        make.width.equalTo(@(btnWidth));
        make.height.equalTo(@(btnHeight));
    }];
}

#pragma mark - RenderData
- (void) renderData
{
    //渲染分类
    [self renderMenu];
    
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

- (void) renderMenu
{
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
            [category iconView:iconView];
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
}

- (void) renderItems
{
    //服务选项
    itemBtns = [NSMutableArray array];
    NSArray *itemArray = @[
                           @{@"icon":@"homeItem", @"category":@1, @"name":@"一键便利店", @"detail": @"便利店到家"},
                           @{@"icon":@"homeItem", @"category":@1, @"name":@"一键便利店", @"detail": @"便利店到家"},
                           @{@"icon":@"homeItem", @"category":@1, @"name":@"一键便利店", @"detail": @"便利店到家"},
                           @{@"icon":@"homeItem", @"category":@1, @"name":@"一键便利店", @"detail": @"便利店到家"},
                           @{@"icon":@"homeItem", @"category":@1, @"name":@"一键便利店", @"detail": @"便利店到家"},
                           @{@"icon":@"homeItem", @"category":@1, @"name":@"一键便利店", @"detail": @"便利店到家"},
                           @{@"icon":@"homeItem", @"category":@1, @"name":@"一键便利店", @"detail": @"便利店到家"},
                           @{@"icon":@"homeItem", @"category":@1, @"name":@"一键便利店", @"detail": @"便利店到家"},
                           @{@"icon":@"homeAdd", @"category":@0, @"name":@"添加", @"detail": @"添加你想要的服务"}
                           ];
    
    //计算宽高
    CGFloat itemWidth = 50;
    CGFloat itemHeight = 60;
    NSInteger itemLine = 4;
    CGFloat itemSpaceW = (SCREEN_WIDTH - itemLine * itemWidth) / (itemLine + 1);
    CGFloat itemSpaceH = 20;
    
    //添加元素
    int i = 0;
    CGFloat contentHeight = 0;
    for (NSDictionary *itemDict in itemArray) {
        i++;
        
        //计算位置
        NSInteger itemRow = (i % 4) == 0 ? (i / 4) : ((int)(i / 4)) + 1;
        NSInteger itemCol = (i % 4) == 0 ? 4 : (i % 4);
        CGFloat itemX = itemSpaceW + (itemWidth + itemSpaceW) * (itemCol - 1);
        CGFloat itemY = itemSpaceH + (itemHeight + itemSpaceH) * (itemRow - 1);
        CGRect itemFrame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        contentHeight = itemY + itemHeight + itemSpaceH;
        
        //初始化按钮
        SpringBoardButton *editButton = [[SpringBoardButton alloc] initWithFrame:itemFrame];
        editButton.backgroundColor = COLOR_MAIN_DARK;
        [editButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        editButton.delegate = self;
        //添加按钮
        if ([@0 isEqualToNumber:[itemDict objectForKey:@"category"]]) {
            editButton.isEditable = NO;
        }
        [scrollView addSubview:editButton];
        [itemBtns addObject:editButton];
    }
    
    //设置scrollView容器宽高
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, contentHeight);
}

- (NSArray *) dataSourceForBoardItems
{
    return itemBtns;
}

- (void) actionBoardItemsStartEditing
{
    NSLog(@"startEditing");
}

- (void) actionBoardItemsEndEditing
{
    NSLog(@"endEditing");
}

- (void) actionBoardItemClicked:(SpringBoardButton *)item
{
    NSLog(@"clicked");
}

- (void) actionBoardItemMoved:(SpringBoardButton *)item toIndex:(NSInteger)index
{
    NSInteger fromIndex = [itemBtns indexOfObject:item];
    [itemBtns exchangeObjectAtIndex:fromIndex withObjectAtIndex:index];
}

- (BOOL) shouldBoardItemDeleted:(SpringBoardButton *)item
{
    return [itemBtns count] > 2 ? YES : NO;
}

- (void) actionBoardItemDeleted:(SpringBoardButton *)item
{
    [itemBtns removeObject:item];
}

#pragma mark - Action
- (void) actionCategory: (UIButton *)sender
{
    //取消选择其它
    for (UIButton *menuBtn in menuBtns) {
        UILabel *nameLabel = (UILabel *) [menuBtn viewWithTag:-1];
        nameLabel.textColor = COLOR_MAIN_DARK;
        
        UIView *selectedView = [menuBtn viewWithTag:-2];
        selectedView.backgroundColor = COLOR_MAIN_WHITE;
    }
    
    UILabel *nameLabel = (UILabel *) [sender viewWithTag:-1];
    nameLabel.textColor = COLOR_MAIN_HIGHLIGHT;
    
    UIView *selectedView = [sender viewWithTag:-2];
    selectedView.backgroundColor = COLOR_MAIN_HIGHLIGHT;
    
    [self.delegate actionCategory:@(sender.tag)];
}

- (void) actionMore
{
    [self.delegate actionMore];
}

- (void) actionCase: (UIButton *)sender
{
    
}

- (void)actionGps
{
    [self.delegate actionGps];
}

@end
