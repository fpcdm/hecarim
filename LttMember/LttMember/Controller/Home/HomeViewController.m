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
#import "CaseCategoryViewController.h"
#import "CNPPopupController.h"
#import "CasePropertyView.h"

//GPS数据缓存，优化GPS耗电
static NSString *lastAddress = nil;
static NSNumber *lastService = nil;
static NSDate   *lastDate = nil;
static NSMutableArray *caseRecommends = nil;
static NSMutableArray *caseCategories = nil;
static NSMutableDictionary *caseTypes = nil;

@interface HomeViewController () <HomeViewDelegate, LocationUtilDelegate, CNPPopupControllerDelegate>

@end

@implementation HomeViewController
{
    HomeView *homeView;
    BOOL viewRendered;
    
    TimerUtil *gpsTimer;
    NSString *gpsStatus;
    
    NSNumber *categoryId;
    NSNumber *typeId;
    NSNumber *propertyId;
    
    //二级分类
    CNPPopupController *popupController;
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
    
    //清除属性
    [homeView clearProperties];
    
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
        [homeView.typeView showIndicator];
        
        CaseHandler *caseHandler = [[CaseHandler alloc] init];
        [caseHandler queryCategories:nil success:^(NSArray *result) {
            [homeView.typeView hideIndicator];
            
            caseCategories = [NSMutableArray arrayWithArray:result];
            
            //重新加载菜单
            [homeView setData:@"categories" value:caseCategories];
            [homeView reloadCategories];
            viewRendered = YES;
            
            //设置定时器
            [self setTimer];
        } failure:^(ErrorEntity *error) {
            [homeView.typeView hideIndicator];
            
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

#pragma mark - Case
- (void)actionCase:(NSNumber *)type
{
    //查询属性列表
    [homeView.typeView showIndicator];
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    CategoryEntity *categoryEntity = [[CategoryEntity alloc] init];
    categoryEntity.id = type;
    [caseHandler queryProperties:categoryEntity success:^(NSArray *result) {
        [homeView.typeView hideIndicator];
        
        //当前所选类型
        typeId = type;
        propertyId = @0;
        
        //判断是否启用属性
        NSArray *properties = result ? result : @[];
        if ([properties count] > 0) {
            //当前区域切换
            [self showProperties:properties];
        } else {
            [self showCaseForm];
        }
    } failure:^(ErrorEntity *error) {
        [homeView.typeView hideIndicator];
        
        [self showError:error.message];
    }];
}

- (void)showCaseForm
{
    //获取参数
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.typeId = typeId;
    intentionEntity.propertyId = propertyId ? propertyId : @0;
    intentionEntity.buyerAddress = lastAddress;
    
    NSLog(@"intention: %@", [intentionEntity toDictionary]);
    
    //跳转表单页面
    CaseFormViewController *viewController = [[CaseFormViewController alloc] init];
    viewController.caseEntity = intentionEntity;
    [self pushViewController:viewController animated:YES];
}

- (void)showProperties:(NSArray *)properties
{
    [homeView setData:@"properties" value:properties];
    [homeView showProperties];
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
    
    //加载效果
    [homeView.typeView showIndicator];
    NSTimeInterval totalInterval = 0.3;
    
    //缓存是否存在
    NSString *idStr = [NSString stringWithFormat:@"%@", id];
    NSArray *idTypes = [caseTypes objectForKey:idStr];
    if (idTypes != nil) {
        //重新加载项目
        NSMutableArray *categoryTypes = [NSMutableArray arrayWithArray:idTypes];
        [self performSelector:@selector(reloadTypes:) withObject:categoryTypes afterDelay:totalInterval];
    } else {
        NSDate *beginDate = [NSDate date];
        
        CaseHandler *caseHandler = [[CaseHandler alloc] init];
        NSDictionary *param = @{@"category_id": id};
        [caseHandler queryTypes:param success:^(NSArray *result) {
            //设置缓存
            [caseTypes setObject:result forKey:idStr];
            
            //重新加载项目
            NSMutableArray *categoryTypes = [NSMutableArray arrayWithArray:result];
            
            //延迟显示
            NSTimeInterval loadInterval = [TimerUtil timeInterval:beginDate];
            NSTimeInterval loadDelay = loadInterval >= totalInterval ? 0.001 : totalInterval - loadInterval;
            [self performSelector:@selector(reloadTypes:) withObject:categoryTypes afterDelay:loadDelay];
        } failure:^(ErrorEntity *error) {
            [homeView.typeView hideIndicator];
            
            [self showError:error.message];
        }];
    }
}

- (void)reloadTypes: (NSMutableArray *)types
{
    [homeView.typeView hideIndicator];
    
    [homeView setData:@"types" value:types];
    [homeView reloadTypes];
}

- (void)actionAddCategory
{
    CaseCategoryViewController *viewController = [[CaseCategoryViewController alloc] init];
    viewController.categoryId = nil;
    viewController.callbackBlock = ^(NSArray *categories){
        if (!caseCategories) return;
        
        //添加到缓存数据
        BOOL hasNew = NO;
        for (CategoryEntity *category in categories) {
            //检查重复数据
            BOOL isExist = NO;
            for (CategoryEntity *cacheCategory in caseCategories) {
                if ([cacheCategory.id isEqualToNumber:category.id]) {
                    isExist = YES;
                    break;
                }
                
            }
            
            if (!isExist) {
                [caseCategories addObject:category];
                hasNew = YES;
            }
        }
        if (!hasNew) return;
        
        //有新数据重新渲染视图并保存
        [homeView setData:@"categories" value:caseCategories];
        [homeView reloadCategories];
        
        //重新保存场景
        [homeView saveCategories];
    };
    
    [self pushViewController:viewController animated:YES];
}

- (void)actionAddType:(NSNumber *)id
{
    CaseCategoryViewController *viewController = [[CaseCategoryViewController alloc] init];
    viewController.categoryId = id;
    viewController.callbackBlock = ^(NSArray *types){
        if (!caseTypes) return;
        
        //添加到缓存数据
        NSString *idStr = [NSString stringWithFormat:@"%@", id];
        NSArray *idTypes = [caseTypes objectForKey:idStr];
        if (idTypes == nil) return;
        
        NSMutableArray *result = [NSMutableArray arrayWithArray:idTypes];
        BOOL hasNew = NO;
        for (CategoryEntity *type in types) {
            //检查重复数据
            BOOL isExist = NO;
            for (CategoryEntity *cacheType in result) {
                if ([cacheType.id isEqualToNumber:type.id]) {
                    isExist = YES;
                    break;
                }
                
            }
            
            if (!isExist) {
                [result addObject:type];
                hasNew = YES;
            }
        }
        if (!hasNew) return;
        
        //有新数据重新渲染视图并保存
        [caseTypes setObject:result forKey:idStr];
        
        NSMutableArray *categoryTypes = [NSMutableArray arrayWithArray:result];
        [homeView setData:@"types" value:categoryTypes];
        [homeView reloadTypes];
        
        //重新保存服务列表
        [homeView saveTypes];
    };
    
    [self pushViewController:viewController animated:YES];
}

- (void)actionSaveCategories:(NSArray *)categories
{
    //不显示请求效果
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler saveCategories:categories success:^(NSArray *result) {
        //更新缓存数据及顺序
        caseCategories = [NSMutableArray arrayWithArray:categories];
        
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)actionSaveTypes:(NSNumber *)id types:(NSArray *)types
{
    //不显示请求效果
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler saveTypes:id types:types success:^(NSArray *result) {
        if (!caseTypes) return;
        
        //更新缓存数据
        NSString *idStr = [NSString stringWithFormat:@"%@", id];
        [caseTypes setObject:types forKey:idStr];
        
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)actionError:(NSString *)message
{
    [self showError:message];
}

@end
