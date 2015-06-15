//
//  SettingViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingView.h"

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
}

#pragma mark - Sheet
//弹出sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag != 1) return;
    
    switch (buttonIndex) {
            //确定
        case 0:
            DDLogDebug(@"todo: delegate 清除缓存");
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
    [sheet showFromTabBar:self.tabBarController.tabBar];
}

@end
