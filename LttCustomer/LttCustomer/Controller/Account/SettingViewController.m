//
//  SettingViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingView.h"
#import "AboutViewController.h"
#import "SDImageCache.h"

@interface SettingViewController () <SettingViewDelegate, UIActionSheetDelegate>

@end

@implementation SettingViewController
{
    SettingView *settingView;
}

- (void)loadView
{
    settingView = [[SettingView alloc] init];
    settingView.delegate = self;
    self.view = settingView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    NSUInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
    NSLog(@"缓存大小: %ld", cacheSize);
    [settingView setData:@"cacheSize" value:[NSNumber numberWithInteger:cacheSize]];
    [settingView renderData];
}

#pragma mark - Sheet
//弹出sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag != 1) return;
    
    switch (buttonIndex) {
            //确定
        case 0:
            //清除缓存
            [[SDImageCache sharedImageCache] clearDisk];
            
            //刷新视图
            [settingView setData:@"cacheSize" value:@0];
            [settingView renderData];
            break;
            //取消
        default:
            break;
    }
}

#pragma mark - Action
- (void)actionClear
{
    UIActionSheet *sheet = [UIActionSheet alloc];
    
    sheet = [sheet initWithTitle:@"确定清除缓存吗" delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
    
    sheet.tag = 1;
    [sheet showInView:self.view];
}

- (void)actionAbout
{
    AboutViewController *viewController = [[AboutViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

@end
