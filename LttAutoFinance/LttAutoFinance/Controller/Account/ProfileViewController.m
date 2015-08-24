//
//  SettingViewController.m
//  LttAutoFInance
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileView.h"
#import "ProfileNicknameViewController.h"
#import "UserHandler.h"

@interface ProfileViewController () <ProfileViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
    
    self.navigationItem.title = @"个人资料";
}

#pragma mark - Sheet
//弹出sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        //修改性别
        case 1:
        {
            if (buttonIndex == 2) return;
            
            NSNumber *sex = [NSNumber numberWithInt:(buttonIndex == 0 ? 1 : 2)];
            
            UserEntity *requestUser = [[UserEntity alloc] init];
            requestUser.sex = sex;
            
            UserEntity *currentUser = [[StorageUtil sharedStorage] getUser];
            if (currentUser) {
                requestUser.nickname = currentUser.nickname;
                requestUser.id = currentUser.id;
            }
            
            NSLog(@"用户数据：%@", [requestUser toDictionary]);
            
            UserHandler *userHandler = [[UserHandler alloc] init];
            [userHandler editUser:requestUser success:^(NSArray *result){
                UserEntity *user = [[StorageUtil sharedStorage] getUser];
                user.sex = [NSNumber numberWithInt:(buttonIndex == 0 ? 1 : 2)];
                [[StorageUtil sharedStorage] setUser:user];
                
                [profileView setData:@"user" value:user];
                [profileView renderData];
            } failure:^(ErrorEntity *error){
                [self showError:error.message];
            }];
        }
            break;
        //头像
        case 2:
        {
            NSUInteger sourceType = 0;
            //检查照相机是否可用
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) {
                if (buttonIndex == 2) return;
                if (buttonIndex == 0) {
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                } else if (buttonIndex == 1) {
                    sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                }
            } else {
                if (buttonIndex == 1) return;
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = sourceType;
            picker.delegate = self;
            picker.allowsEditing = YES;
            
            [self presentViewController:picker animated:YES completion:^(void){}];
        }
            break;
        default:
            break;
    }
}

// 选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion: ^(void){}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //上传头像
    FileEntity *avatarEntity = [[FileEntity alloc] initWithImage:image compression:0.3];
    avatarEntity.field = @"file";
    avatarEntity.name = @"avatar.jpg";
    
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler uploadAvatar:avatarEntity success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            FileEntity *imageEntity = [result firstObject];
            NSLog(@"头像上传成功：%@", imageEntity.url);
            
            //保存头像
            UserEntity *user = [[StorageUtil sharedStorage] getUser];
            user.avatar = imageEntity.url;
            [[StorageUtil sharedStorage] setUser:user];
            
            [profileView setData:@"user" value:user];
            [profileView renderData];
            
            //刷新菜单
            [self refreshMenu];
            
            //回调上级
            if (self.callbackBlock) {
                self.callbackBlock(user);
            }
        }];
    } failure:^(ErrorEntity *error){
        NSLog(@"头像上传失败：%@", error.message);
        [self showError:error.message];
    }];
}

#pragma mark - Action
- (void)actionSex
{
    UIActionSheet *sheet = [UIActionSheet alloc];
    
    sheet = [sheet initWithTitle:nil delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    
    sheet.tag = 1;
    [sheet showInView:self.view];
}

- (void)actionNickname
{
    ProfileNicknameViewController *viewController = [[ProfileNicknameViewController alloc] init];
    
    //初始化昵称
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    viewController.nickname = user.nickname;
    viewController.callbackBlock = ^(id object){
        //保存昵称
        UserEntity *user = [[StorageUtil sharedStorage] getUser];
        user.nickname = (NSString *) object;
        [[StorageUtil sharedStorage] setUser:user];
        
        [profileView setData:@"user" value:user];
        [profileView renderData];
        
        //刷新菜单
        [self refreshMenu];
        
        //回调上级
        if (self.callbackBlock) {
            self.callbackBlock(user);
        }
    };
    
    [self pushViewController:viewController animated:YES];
}

- (void)actionAvatar
{
    UIActionSheet *sheet = [UIActionSheet alloc];
    
    //检查照相机是否可用
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) {
        sheet = [sheet initWithTitle:nil delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    } else {
        sheet = [sheet initWithTitle:nil delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:nil];
    }
    
    sheet.tag = 2;
    [sheet showInView:self.view];
}

@end
