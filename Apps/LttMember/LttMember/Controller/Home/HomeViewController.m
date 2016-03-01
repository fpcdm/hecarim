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
#import "CaseEntity.h"
#import "CaseHandler.h"
#import "HelperHandler.h"
#import "CaseCategoryViewController.h"
#import "CNPPopupController.h"
#import "CasePropertyView.h"
#import "AddressEntity.h"
#import "CityViewController.h"

//GPS数据缓存，优化GPS耗电
static LocationEntity *lastLocation = nil;
static NSDate *lastDate = nil;
static NSArray *cacheTypes = nil;
static NSArray *slideAdverts = nil;

@interface HomeViewController () <HomeViewDelegate, LocationUtilDelegate, CNPPopupControllerDelegate>

@end

@implementation HomeViewController
{
    HomeView *homeView;
    
    TimerUtil *gpsTimer;
    NSString *gpsStatus;
    
    NSNumber *typeId;
    NSNumber *propertyId;
    
    BOOL isFirstCity;
    NSArray *openCities;
    
    //二级分类
    CNPPopupController *popupController;
    
#if TARGET_IPHONE_SIMULATOR
    //模拟城市切换
    CLLocationCoordinate2D debugPosition;
#endif
    
    //选择城市
    CityViewController *cityViewController;
}

- (void)loadView
{
    homeView = [[HomeView alloc] initWithData:@{
                                                @"statusBarHeight": @(SCREEN_STATUSBAR_HEIGHT),
                                                @"navigationBarHeight": @(SCREEN_NAVIGATIONBAR_HEIGHT),
                                                @"tabBarHeight": @(self.tabBarController.tabBar.frame.size.height)
                                                }];
    homeView.delegate = self;
    self.view = homeView;
}

- (void)viewDidLoad
{
    showTabBar = YES;
    isIndexNavBar = YES;
    isIndexStatusBar = YES;
    hideBackButton = YES;
    hideNavigationBar = YES;
    [super viewDidLoad];
    
    //是否登陆
    [homeView setLogin:[self isLogin]];
    
    self.navigationItem.title = @"两条腿";
    
    //初始化缓存数据
    if (!lastLocation) {
        lastLocation = [[LocationEntity alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //定位失败，重新定位
    if (!lastLocation.detailAddress) {
        [LocationUtil sharedInstance].delegate = self;
        [[LocationUtil sharedInstance] restartUpdate];
    }
    
    //清除属性
    [homeView clearProperties];
    
    //查询默认城市
    NSString *cityCode = [[StorageUtil sharedStorage] getCityCode];
    if (!cityCode || [cityCode length] < 1) {
        HelperHandler *helperHandler = [[HelperHandler alloc] init];
        [helperHandler queryOpenCities:nil success:^(NSArray *result) {
            //标记第一次加载，定位城市会覆盖
            isFirstCity = YES;
            openCities = result;
            
            //获取默认城市
            for (LocationEntity *location in result) {
                if (location.isDefault && [@1 isEqualToNumber:location.isDefault]) {
                    [self saveCity:location.cityCode cityName:location.city];
                    break;
                }
            }
            
            [self initData];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    } else {
        isFirstCity = NO;
        
        [self initData];
    }
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
    //获取广告列表
    if (!slideAdverts) {
        HelperHandler *helperHandler = [[HelperHandler alloc] init];
        NSDictionary *param = @{@"position": @"slide"};
        [helperHandler queryAdverts:param success:^(NSArray *result) {
            slideAdverts = result;
            
            [homeView assign:@"adverts" value:slideAdverts];
            [homeView reloadAds];
        } failure:^(ErrorEntity *error) {
            [self showError:error.message];
        }];
    } else {
        [homeView assign:@"adverts" value:slideAdverts];
        [homeView reloadAds];
    }
    
    //获取收藏列表
    if (!cacheTypes) {
        [self actionTypes];
        
        //设置定时器
        [self setTimer];
    } else {
        [self reloadTypes:[NSMutableArray arrayWithArray:cacheTypes]];
        
        //设置定时器
        [self setTimer];
    }
}

//渲染视图
- (void) renderView
{
    //城市名称
    NSString *cityName = [[StorageUtil sharedStorage] getData:LTT_STORAGE_KEY_CITY_NAME];
    NSNumber *count = lastLocation.serviceNumber ? lastLocation.serviceNumber : @-1;
    
    [homeView assign:@"city" value:cityName];
    [homeView assign:@"address" value:lastLocation.address];
    [homeView assign:@"gps" value:gpsStatus];
    [homeView assign:@"count" value:count];
    [homeView display];
}

- (void) setTimer
{
    //定时器间隔：30秒钟，GPS刷新间隔：1分钟，因为手工GPS会重置最后刷新时间
    gpsTimer = [TimerUtil repeatTimer:(USER_LOCATION_INTERVAL / 2) block:^{
        //定位成功检查GPS刷新间隔
        if (lastLocation.detailAddress) {
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
//模拟城市切换
#if TARGET_IPHONE_SIMULATOR
    if (IS_DEBUG) {
        [self debugGps];
        position = debugPosition;
    }
#endif
    
    //停止监听GPS
    [[LocationUtil sharedInstance] stopUpdate];
    
    //查询位置
    LocationEntity *locationEntity = [[LocationEntity alloc] init];
    locationEntity.longitude = [NSNumber numberWithFloat:position.longitude];
    locationEntity.latitude = [NSNumber numberWithFloat:position.latitude];
    
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler queryLocation:locationEntity success:^(NSArray *result){
        LocationEntity *location = [result firstObject];
        
        //首次检查定位城市是否不同
        if (isFirstCity && location.cityCode && [location.cityCode length] > 0) {
            //定位位置仅在第一次使用为当前城市
            isFirstCity = NO;
            
            //是否在开通城市列表中
            BOOL isOpenCity = NO;
            for (LocationEntity *openCity in openCities) {
                if (openCity.cityCode && [openCity.cityCode isEqualToString:location.cityCode]) {
                    isOpenCity = YES;
                    break;
                }
            }
            
            //在开通城市列表并且城市有变化
            if (isOpenCity) {
                NSString *oldCity = [[StorageUtil sharedStorage] getCityCode];
                if (!oldCity || ![oldCity isEqualToString:location.cityCode]) {
                    //记录城市缓存
                    [self saveCity:location.cityCode cityName:location.city];
                    
                    //重新加载城市
                    [self refreshCityView];
                }
            }
        }
        
        //获取位置
        if (location.address && [location.address length] > 0) {
            lastLocation.address = location.address;
            lastLocation.detailAddress = location.detailAddress;
            lastLocation.cityCode = location.cityCode;
            lastLocation.city = location.city;
            gpsStatus = nil;
            
            //刷新选择城市
            if (cityViewController) {
                cityViewController.gpsLocation = lastLocation;
                [cityViewController reloadView];
            }
        } else {
            gpsStatus = [LocaleUtil info:@"Location.Fail"];
        }
        
        //查询信使数量
        [helperHandler queryServiceNumber:locationEntity success:^(NSArray *result){
            LocationEntity *location = [result firstObject];
            
            //获取位置
            if (location.serviceNumber) {
                lastLocation.serviceNumber = location.serviceNumber;
            }
            
            //刷新视图
            [self renderView];
        } failure:^(ErrorEntity *error){
            //刷新视图
            [self renderView];
        }];
    } failure:^(ErrorEntity *error){
        gpsStatus = [LocaleUtil info:@"FoundLocation.Fail"];
        
        //刷新视图
        [self renderView];
    }];
}

- (void)updateLocationError:(NSError *)error
{
//模拟城市切换
#if TARGET_IPHONE_SIMULATOR
    if (IS_DEBUG) {
        [self updateLocationSuccess:debugPosition];
        return;
    }
#endif
    
    if (lastLocation.detailAddress) return;
    
    //重置数据
    lastLocation.address = nil;
    lastLocation.detailAddress = nil;
    lastLocation.cityCode = nil;
    lastLocation.city = nil;
    lastLocation.serviceNumber = nil;
    
    //失败原因
    if ([error code] == kCLErrorDenied) {
        gpsStatus = [LocaleUtil info:@"Open.GPS"];
    } else if ([error code] == kCLErrorLocationUnknown) {
        gpsStatus = [LocaleUtil info:@"Location.Fail"];
    } else {
        gpsStatus = [LocaleUtil info:@"GPS.Fail"];
    }
    
    //刷新视图
    [self renderView];
}

//模拟城市切换
#if TARGET_IPHONE_SIMULATOR
- (void) debugGps
{
    if (IS_DEBUG) {
        //南宁
        if (debugPosition.latitude == 29.587263) {
            debugPosition = CLLocationCoordinate2DMake(22.818677, 108.371073);
        //北京
        } else if (debugPosition.latitude == 22.818677) {
            debugPosition = CLLocationCoordinate2DMake(39.915599, 116.426116);
        //安庆
        } else if (debugPosition.latitude == 39.915599) {
            debugPosition = CLLocationCoordinate2DMake(30.915599, 116.426116);
        //重庆
        } else {
            debugPosition = CLLocationCoordinate2DMake(29.587263, 106.493928);
        }
    }
}
#endif

#pragma mark - City
//设置城市
- (void)saveCity:(NSString *)cityCode cityName:(NSString *)cityName
{
    //记录城市缓存
    [[StorageUtil sharedStorage] setCityCode:cityCode];
    //记录城市缓存
    [[StorageUtil sharedStorage] setData:LTT_STORAGE_KEY_CITY_NAME object:cityName];
    //设置城市头
    [[RestKitUtil sharedClient] setCityCode:cityCode];
}

//切换城市视图
- (void)refreshCityView
{
    //刷新城市服务列表
    [self actionTypes];
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

//获取当前定位地址对象
- (AddressEntity *) currentAddress
{
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    
    AddressEntity *currentAddress = [[AddressEntity alloc] init];
    currentAddress.name = [user displayName];
    currentAddress.mobile = user.mobile;
    currentAddress.address = lastLocation.detailAddress;
    
    //定位城市是否可用
    NSString *cityCode = [[StorageUtil sharedStorage] getCityCode];
    //没有设置城市，则可以使用定位地址
    if (!cityCode) {
        currentAddress.isEnable = @1;
    //定位城市和设置的城市相同，可以使用定位地址
    } else if (lastLocation.cityCode && [cityCode isEqualToString:lastLocation.cityCode]) {
        currentAddress.isEnable = @1;
    } else {
        currentAddress.isEnable = @0;
    }
    
    return currentAddress;
}

- (void)showCaseForm
{
    //当前定位地址
    AddressEntity *currentAddress = [self currentAddress];
    
    //获取参数
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.typeId = typeId;
    intentionEntity.propertyId = propertyId ? propertyId : @0;
    intentionEntity.buyerAddress = [@1 isEqualToNumber:currentAddress.isEnable] ? currentAddress.address : nil;
    
    NSLog(@"intention: %@", [intentionEntity toDictionary]);
    
    //跳转表单页面
    CaseFormViewController *viewController = [[CaseFormViewController alloc] init];
    viewController.caseEntity = intentionEntity;
    viewController.currentAddress = currentAddress;
    [self pushViewController:viewController animated:YES];
}

- (void)showProperties:(NSArray *)properties
{
    [homeView assign:@"properties" value:properties];
    [homeView showProperties];
}

- (void)actionProperty:(PropertyEntity *)property
{
    propertyId = property.id;
    [self showCaseForm];
}

#pragma mark - Action
- (void)actionLogin
{
    [[TabbarViewController sharedInstance] gotoLogin];
}

- (void)actionMenu
{
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

- (void)actionCity
{
    cityViewController = [[CityViewController alloc] init];
    cityViewController.gpsLocation = lastLocation;
    
    //解决循环引用
    __block HomeViewController *homeViewController = self;
    cityViewController.callbackBlock = ^(LocationEntity *city){
        //关闭控制器
        cityViewController = nil;
        
        //选择城市
        if (city) {
            NSString *oldCity = [[StorageUtil sharedStorage] getCityCode];
            if (!oldCity || ![oldCity isEqualToString:city.cityCode]) {
                //记录城市缓存
                [homeViewController saveCity:city.cityCode cityName:city.city];
                
                //刷新城市显示
                [homeViewController renderView];
                
                //重新加载城市
                [homeViewController refreshCityView];
            }
        }
        
        //释放引用
        homeViewController = nil;
    };
    [self.navigationController pushViewController:cityViewController animated:YES vertical:YES];
}

- (void)actionTypes
{
    //加载效果
    [homeView.typeView showIndicator];
    NSTimeInterval totalInterval = 0.3;
    
    //切换城市换服务列表，不使用缓存
    NSDate *beginDate = [NSDate date];
    
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler queryFavoriteTypes:nil success:^(NSArray *result) {
        //设置缓存
        cacheTypes = result;
        
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

- (void)reloadTypes: (NSMutableArray *)types
{
    [homeView.typeView hideIndicator];
    
    [homeView assign:@"types" value:types];
    [homeView reloadTypes];
}

- (void)actionAddType
{
    CaseCategoryViewController *viewController = [[CaseCategoryViewController alloc] init];
    viewController.callbackBlock = ^(NSArray *types){
        if (!cacheTypes) return;
        
        //添加到缓存数据
        NSArray *idTypes = cacheTypes;
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
        cacheTypes = result;
        
        NSMutableArray *categoryTypes = [NSMutableArray arrayWithArray:result];
        [homeView assign:@"types" value:categoryTypes];
        [homeView reloadTypes];
        
        //重新保存服务列表
        [homeView saveTypes];
    };
    
    [self pushViewController:viewController animated:YES];
}

- (void)actionSaveTypes:(NSArray *)types
{
    //不显示请求效果
    CaseHandler *caseHandler = [[CaseHandler alloc] init];
    [caseHandler saveFavoriteTypes:types success:^(NSArray *result) {
        if (!cacheTypes) return;
        
        //更新缓存数据
        cacheTypes = types;
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)actionError:(NSString *)message
{
    [self showError:message];
}

@end
