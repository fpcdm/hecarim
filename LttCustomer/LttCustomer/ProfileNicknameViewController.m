//
//  ProfileNicknameViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/18.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ProfileNicknameViewController.h"
#import "ProfileNicknameView.h"

@interface ProfileNicknameViewController () <ProfileNicknameDelegate>

@end

@implementation ProfileNicknameViewController
{
    ProfileNicknameView *nicknameView;
}

- (void)loadView
{
    nicknameView = [[ProfileNicknameView alloc] init];
    nicknameView.delegate = self;
    self.view = nicknameView;
    
    [nicknameView setData:@"nickname" value:self.nickname];
    [nicknameView renderData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改昵称";
}

#pragma mark - Action
- (void)actionSave:(NSString *)nickname
{
    //执行回调
    if (self.callbackBlock) {
        self.callbackBlock(nickname);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
