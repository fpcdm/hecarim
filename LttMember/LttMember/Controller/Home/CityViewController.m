//
//  CityViewController.m
//  LttMember
//
//  Created by wuyong on 15/11/12.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "CityViewController.h"
#import "CityView.h"
#import "HelperHandler.h"
#import "LocationUtil.h"
#import "UINavigationController+Vertical.h"

@interface CityViewController () <CityViewDelegate>

@end

@implementation CityViewController
{
    CityView *cityView;
    NSArray *openCities;
}

- (void)loadView
{
    cityView = [[CityView alloc] init];
    cityView.delegate = self;
    self.view = cityView;
}

- (void)viewDidLoad {
    hideBackButton = YES;
    [super viewDidLoad];
    
    NSString *cityName = [[StorageUtil sharedStorage] getData:LTT_STORAGE_KEY_CITY_NAME];
    self.navigationItem.title = [NSString stringWithFormat:@"当前城市-%@", cityName ? cityName : @""];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menuClose"]
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(actionClose)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor redColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showLoading:[LocaleUtil system:@"Loading.Start"]];
    
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler queryOpenCities:nil success:^(NSArray *result) {
        [self hideLoading];
        
        openCities = result;
        [self reloadView];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)reloadView
{
    [cityView setData:@"cities" value:openCities];
    [cityView setData:@"gps" value:self.gpsLocation];
    [cityView renderData];
}

#pragma mark - Action
- (void)actionGps
{
    //刷新GPS
    [[LocationUtil sharedInstance] restartUpdate];
}

- (void)actionClose
{
    [self.navigationController popViewControllerAnimated:YES vertical:YES];
    
    if (self.callbackBlock) {
        self.callbackBlock(nil);
    }
}

- (void)actionCitySelected:(LocationEntity *)city
{
    [self.navigationController popViewControllerAnimated:YES vertical:YES];
    
    if (self.callbackBlock) {
        self.callbackBlock(city);
    }
}

@end
