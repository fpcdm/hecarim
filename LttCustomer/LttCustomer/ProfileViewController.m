//
//  SettingViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileView.h"

@interface ProfileViewController () <ProfileViewDelegate>

@end

@implementation ProfileViewController
{
    ProfileView *profileView;
}

- (void)loadView
{
    profileView = [[ProfileView alloc] init];
    profileView.delegate = self;
    self.view = profileView;
    
    //加载数据
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    [profileView setData:@"user" value:user];
    [profileView renderData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人资料";
}

@end
