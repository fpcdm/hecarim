//
//  SettingViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/6/11.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileView.h"
#import "ProfileNicknameViewController.h"

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
    hasNavBack = YES;
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
            
            UserEntity *user = [[StorageUtil sharedStorage] getUser];
            user.sex = [NSNumber numberWithInt:(buttonIndex == 0 ? 1 : 2)];
            [[StorageUtil sharedStorage] setUser:user];
                
            [profileView setData:@"user" value:user];
            [profileView renderData];
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
    
    //todo: 保存并上传头像
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //头像路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imagePath = [NSString stringWithFormat:@"%@/avatar.jpg", documentPath];
    if ([fileManager fileExistsAtPath:imagePath]) {
        NSError *error;
        [fileManager removeItemAtPath:imagePath error:&error];
    }
    if (![fileManager fileExistsAtPath:imagePath]) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        BOOL status = [imageData writeToFile:imagePath atomically:YES];
        if (status) {
            //保存头像
            UserEntity *user = [[StorageUtil sharedStorage] getUser];
            user.avatar = imagePath;
            [[StorageUtil sharedStorage] setUser:user];
            
            [profileView setData:@"user" value:user];
            [profileView renderData];
            
            //刷新菜单
            [self refreshMenu];
            
            //回调上级
            if (self.callbackBlock) {
                self.callbackBlock(user);
            }
        }
    }
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
