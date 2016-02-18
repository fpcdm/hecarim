//
//  BaseViewController.m
//  LttFramework
//
//  Created by wuyong on 15/6/4.
//  Copyright (c) 2015年 Gilbert Intelligence Technology Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "FWHelperNetwork.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
{
    FailedBlock _errorHandler;
}

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

#pragma mark - ErrorHandler
- (void)setErrorHandler:(FailedBlock)errorHandler
{
    _errorHandler = errorHandler;
}

- (FailedBlock)errorHandler
{
    if (!_errorHandler) {
        //默认错误处理代码块
        __block BaseViewController *_self = self;
        _errorHandler = ^(ErrorEntity *error){
            [_self showError:error.message];
        };
    }
    return _errorHandler;
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
    BOOL result = [FWHelperNetwork sharedInstance].isAvailable;
    
    //错误提示
    if (!result) {
        [self showError:[LocaleUtil system:@"ApiError.Network"]];
    }
    
    return result;
}

@end
