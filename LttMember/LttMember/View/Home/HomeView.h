//
//  HomeView.h
//  LttMember
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"

@protocol HomeViewDelegate <NSObject>

@required
- (void)actionLogin;
- (void)actionMenu;
- (void)actionGps;
- (void)actionCategory: (NSNumber *) id;
- (void)actionCase: (NSNumber *) type;
- (void)actionError: (NSString *) message;
- (void)actionAddCategory;
- (void)actionAddType: (NSNumber *) categoryId;

@end

@interface HomeView : AppView

@property (retain, nonatomic) id<HomeViewDelegate> delegate;

@property (retain, nonatomic) UIScrollView *typeView;

- (void) setLogin: (BOOL) login;
- (void) reloadRecommends;
- (void) reloadCategories;
- (void) reloadTypes;

@end
