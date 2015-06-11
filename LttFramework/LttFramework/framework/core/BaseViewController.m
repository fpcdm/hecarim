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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Public Methods
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
        [self showError:ERROR_MESSAGE_NETWORK];
    }
    
    return result;
}

@end
