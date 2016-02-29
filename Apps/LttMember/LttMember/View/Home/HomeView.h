//
//  HomeView.h
//  LttMember
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppView.h"
#import "PropertyEntity.h"

@protocol HomeViewDelegate <NSObject>

@required
- (void)actionLogin;
- (void)actionMenu;
- (void)actionGps;
- (void)actionCity;
- (void)actionTypes;
- (void)actionCase: (NSNumber *) type;
- (void)actionError: (NSString *) message;
- (void)actionAddType;
- (void)actionSaveTypes: (NSArray *) types;
- (void)actionProperty:(PropertyEntity *)property;

@end

@interface HomeView : AppView

@property (retain, nonatomic) id<HomeViewDelegate> delegate;

@property (retain, nonatomic) UIScrollView *typeView;

- (void) setLogin: (BOOL) login;
- (void) reloadTypes;

- (void) reloadAds;

//切换二级分类
- (void) showProperties;
- (void) clearProperties;

//重新保存当前的服务列表
- (void) saveTypes;

@end
