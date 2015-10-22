//
//  RootViewController.m
//  LttMember
//
//  Created by wuyong on 15/4/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeView.h"
#import "CaseFormViewController.h"
#import "LoginViewController.h"
#import "CaseEntity.h"
#import "CaseHandler.h"
#import "HelperHandler.h"
#import "LocationUtil.h"
#import "TimerUtil.h"
#import "UIView+Loading.h"
#import "LttNavigationController.h"

//GPS数据缓存，优化GPS耗电
static NSString *lastAddress = nil;
static NSNumber *lastService = nil;
static NSDate   *lastDate = nil;
static NSMutableArray *caseRecommends = nil;
static NSMutableArray *caseCategories = nil;
static NSMutableDictionary *caseTypes = nil;

@interface HomeViewController () <HomeViewDelegate, LocationUtilDelegate>

@end

@implementation HomeViewController
{
    HomeView *homeView;
    BOOL viewRendered;
    
    TimerUtil *gpsTimer;
    NSString *gpsStatus;
    
    NSNumber *categoryId;
}

- (void)loadView
{
    homeView = [[HomeView alloc] init];
    homeView.delegate = self;
    self.view = homeView;
}

- (void)viewDidLoad
{
    isIndexNavBar = YES;
    isIndexStatusBar = YES;
    isMenuEnabled = [self isLogin];
    disableMenuGesture = YES;
    hideBackButton = YES;
    hideNavigationBar = YES;
    [super viewDidLoad];
    
    //是否登陆
    [homeView setLogin:[self isLogin]];
    
    self.navigationItem.title = @"两条腿";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //定位失败，重新定位
    if (!lastAddress) {
        [LocationUtil sharedInstance].delegate = self;
        [[LocationUtil sharedInstance] restartUpdate];
    }
    
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //释放定时器
    if (gpsTimer) {
        [gpsTimer invalidate];
        gpsTimer = nil;
    }
}

- (void)initData
{
    //获取推荐列表
    if (!caseRecommends) {
        CaseHandler *caseHandler = [[CaseHandler alloc] init];
        NSDictionary *param = @{@"recommend": @1};
        [caseHandler queryTypes:param success:^(NSArray *result) {
            caseRecommends = [NSMutableArray arrayWithArray:result];
            
            //重载推荐
            [homeView setData:@"recommends" value:caseRecommends];
            [homeView reloadRecommends];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    } else {
        //重载推荐
        [homeView setData:@"recommends" value:caseRecommends];
        [homeView reloadRecommends];
    }
    
    //获取分类列表
    if (!caseCategories) {
        [self showLoading:TIP_LOADING_MESSAGE];
        
        CaseHandler *caseHandler = [[CaseHandler alloc] init];
        [caseHandler queryCategories:nil success:^(NSArray *result) {
            [self hideLoading];
            
            caseCategories = [NSMutableArray arrayWithArray:result];
            
            //重新加载菜单
            [homeView setData:@"categories" value:caseCategories];
            [homeView reloadCategories];
            viewRendered = YES;
            
            //设置定时器
            [self setTimer];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    } else {
        //重新加载菜单
        if (!viewRendered) {
            [homeView setData:@"categories" value:caseCategories];
            [homeView reloadCategories];
        }
        
        //设置定时器
        [self setTimer];
    }
}

//渲染视图
- (void) renderView
{
    [homeView setData:@"address" value:lastAddress];
    [homeView setData:@"gps" value:gpsStatus];
    [homeView setData:@"count" value:lastService ? lastService : @-1];
    [homeView renderData];
}

- (void) setTimer
{
    //定时器间隔：30秒钟，GPS刷新间隔：1分钟，因为手工GPS会重置最后刷新时间
    gpsTimer = [TimerUtil repeatTimer:(USER_LOCATION_INTERVAL / 2) block:^{
        //定位成功检查GPS刷新间隔
        if (lastAddress) {
            NSTimeInterval timeInterval = [TimerUtil timeInterval:lastDate];
            if (timeInterval > 0 && timeInterval < (USER_LOCATION_INTERVAL - 1)) {
                NSLog(@"未到GPS刷新时间");
                
                //加载缓存数据视图
                [self renderView];
                return;
            }
        }
        
        //记录刷新时间
        lastDate = [NSDate date];
        
        //设置位置代理
        [LocationUtil sharedInstance].delegate = self;
        //刷新一次gps
        [[LocationUtil sharedInstance] restartUpdate];
    } queue:dispatch_get_main_queue()];
}

#pragma mark - GPS
- (void) updateLocationSuccess:(CLLocationCoordinate2D)position
{
    //停止监听GPS
    [[LocationUtil sharedInstance] stopUpdate];
    
    //查询位置
    LocationEntity *locationEntity = [[LocationEntity alloc] init];
    locationEntity.longitude = [NSNumber numberWithFloat:position.longitude];
    locationEntity.latitude = [NSNumber numberWithFloat:position.latitude];
    
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler queryLocation:locationEntity success:^(NSArray *result){
        LocationEntity *location = [result firstObject];
        
        //获取位置
        if (location.detailAddress && [location.detailAddress length] > 0) {
            lastAddress = location.detailAddress;
            gpsStatus = nil;
        } else {
            gpsStatus = @"获取位置失败";
        }
        
        //查询信使数量
        [helperHandler queryServiceNumber:locationEntity success:^(NSArray *result){
            LocationEntity *location = [result firstObject];
            
            //获取位置
            if (location.serviceNumber) {
                lastService = location.serviceNumber;
            }
            
            //刷新视图
            [self renderView];
        } failure:^(ErrorEntity *error){
            //刷新视图
            [self renderView];
        }];
    } failure:^(ErrorEntity *error){
        gpsStatus = @"查询位置失败";
        
        //刷新视图
        [self renderView];
    }];
}

- (void)updateLocationError:(NSError *)error
{
    if (lastAddress) return;
    
    //重置数据
    lastAddress = nil;
    lastService = nil;
    
    //失败原因
    if ([error code] == kCLErrorDenied) {
        gpsStatus = @"请打开手机定位";
    } else if ([error code] == kCLErrorLocationUnknown) {
        gpsStatus = @"无法获取位置";
    } else {
        gpsStatus = @"定位失败";
    }
    
    //刷新视图
    [self renderView];
}

#pragma mark - Action
- (void)actionLogin
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)actionMenu
{
    //已经登录，显示菜单
    [(LttNavigationController *) self.navigationController showMenu];
}

- (void)actionGps
{
    //记录刷新时间
    lastDate = [NSDate date];
    
    //设置位置代理
    [LocationUtil sharedInstance].delegate = self;
    //刷新GPS
    [[LocationUtil sharedInstance] restartUpdate];
}

- (void)actionCategory:(NSNumber *)id
{
    //初始化缓存
    if (!caseTypes) caseTypes = [NSMutableDictionary dictionary];
    
    //当前分类id
    categoryId = id;
    
    //缓存是否存在
    NSString *idStr = [NSString stringWithFormat:@"%@", id];
    NSArray *idTypes = [caseTypes objectForKey:idStr];
    if (idTypes != nil) {
        //重新加载项目
        NSMutableArray *categoryTypes = [NSMutableArray arrayWithArray:idTypes];
        [homeView setData:@"types" value:categoryTypes];
        [homeView reloadTypes];
    } else {
        [homeView.typeView showIndicator];
        
        CaseHandler *caseHandler = [[CaseHandler alloc] init];
        NSDictionary *param = @{@"category_id": id};
        [caseHandler queryTypes:param success:^(NSArray *result) {
            [homeView.typeView hideIndicator];
            
            //设置缓存
            [caseTypes setObject:result forKey:idStr];
            
            //重新加载项目
            NSMutableArray *categoryTypes = [NSMutableArray arrayWithArray:result];
            [homeView setData:@"types" value:categoryTypes];
            [homeView reloadTypes];
        } failure:^(ErrorEntity *error) {
            [homeView.typeView hideIndicator];
            
            [self showError:error.message];
        }];
    }
}

- (void)actionCase:(NSNumber *)type
{
    //获取参数
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.typeId = type;
    intentionEntity.buyerAddress = lastAddress;
    
    NSLog(@"intention: %@", [intentionEntity toDictionary]);
    
    //跳转表单页面
    CaseFormViewController *viewController = [[CaseFormViewController alloc] init];
    viewController.caseEntity = intentionEntity;
    [self pushViewController:viewController animated:YES];
}

- (void)actionAddCategory
{
    
}

- (void)actionAddType:(NSNumber *)categoryId
{
    
}

- (void)actionSaveCategories:(NSArray *)categories
{
    //不显示请求效果
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler saveCategories:categories success:^(NSArray *result) {
        if (!caseCategories) return;
        
        //更新缓存数据及顺序
        NSMutableArray *newCategories = [NSMutableArray array];
        for (CategoryEntity *category in categories) {
            for (CategoryEntity *cacheCategory in caseCategories) {
                if ([cacheCategory.id isEqualToNumber:category.id]) {
                    [newCategories addObject:cacheCategory];
                    break;
                }
            }
        }
        caseCategories = newCategories;
        
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)actionSaveTypes:(NSNumber *)categoryId types:(NSArray *)types
{
    //不显示请求效果
    CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
    categoryEntity.id = categoryId;
    
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler saveTypes:categoryEntity types:types success:^(NSArray *result) {
        if (!caseTypes) return;
        
        //清除缓存数据
        NSString *idStr = [NSString stringWithFormat:@"%@", categoryId];
        NSArray *idTypes = [caseTypes objectForKey:idStr];
        if (idTypes != nil) {
            [caseTypes removeObjectForKey:idStr];
        }
        
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)actionError:(NSString *)message
{
    [self showError:message];
}

@end
