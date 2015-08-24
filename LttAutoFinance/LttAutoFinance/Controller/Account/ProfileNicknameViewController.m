//
//  ProfileNicknameViewController.m
//  LttAutoFInance
//
//  Created by wuyong on 15/6/18.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ProfileNicknameViewController.h"
#import "ProfileNicknameView.h"
#import "UserHandler.h"

@interface ProfileNicknameViewController () <ProfileNicknameViewDelegate>

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
    if (!nickname || [nickname length] < 1) {
        [self showError:@"请填写昵称"];
        return;
    }
    
    UserEntity *requestUser = [[UserEntity alloc] init];
    requestUser.nickname = nickname;
    
    UserEntity *currentUser = [[StorageUtil sharedStorage] getUser];
    if (currentUser) {
        requestUser.sex = currentUser.sex;
        requestUser.id = currentUser.id;
    }
    
    NSLog(@"用户数据：%@", [requestUser toDictionary]);
    
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler editUser:requestUser success:^(NSArray *result){
        //执行回调
        if (self.callbackBlock) {
            self.callbackBlock(nickname);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

@end
