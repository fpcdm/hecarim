//
//  BaseViewController.m
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "Reachability.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //解决导航栏覆盖view
    if (IS_IOS7_PLUS) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    //第一次标记自动刷新
    self.shouldRefresh = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.shouldRefresh) {
        self.shouldRefresh = NO;
        [self refreshHandler];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public Methods
- (void) refreshHandler
{
    //子类重写
}

- (void) loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    success(nil);
}

- (BOOL) checkNetwork
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    BOOL result = NO;
    switch (status) {
            //WIFI
        case ReachableViaWiFi:
            result = YES;
            break;
            //WWAN
        case ReachableViaWWAN:
            result = YES;
            break;
            //不能访问
        case NotReachable:
        default:
            result = NO;
            break;
    }
    
    //错误提示
    if (!result) {
        [self showError:[LocaleUtil system:@"ApiError.Network"]];
    }
    
    return result;
}

//切换视图,类似push效果
- (void) pushView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion
{
    if (animated) {
        [UIView animateWithDuration:0.1f
                         animations:^{
                            self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             self.view = view;
                             self.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                             [UIView animateWithDuration:0.2f
                                              animations:^{
                                                  self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  if (completion) completion();
                                              }
                              ];
                         }
         ];
    } else {
        self.view = view;
        if (completion) completion();
    }
}

//切换视图,类似pop效果
- (void) popView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion
{
    if (animated) {
        [UIView animateWithDuration:0.1f
                         animations:^{
                             self.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             self.view = view;
                             self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                             [UIView animateWithDuration:0.2f
                                              animations:^{
                                                  self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  if (completion) completion();
                                              }
                              ];
                         }
         ];
    } else {
        self.view = view;
        if (completion) completion();
    }
}

@end
