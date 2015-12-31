//
//  StaffDetailViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/29.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "StaffDetailViewController.h"
#import "StaffEntity.h"
#import "StaffDetailView.h"
#import "StaffFormViewController.h"
#import "StaffHandler.h"

@interface StaffDetailViewController ()<StaffDetailViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

@end


@implementation StaffDetailViewController
{
    StaffDetailView *detailView;
    StaffEntity *staffEntity;
}

@synthesize staffId;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    detailView = [[StaffDetailView alloc] init];
    detailView.delegate = self;
    self.view = detailView;
    
    self.navigationItem.title = @"员工详情";
    
    UIBarButtonItem *rightBtn = [AppUIUtil makeBarButtonItem:@"编辑" highlighted:isIndexNavBar];
    rightBtn.target = self;
    rightBtn.action = @selector(actionEdit);
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showLoading:TIP_LOADING_MESSAGE];
    
    staffEntity = [[StaffEntity alloc] init];
    staffEntity.id = staffId;
    
    StaffHandler *staffHandler = [[StaffHandler alloc] init];
    [staffHandler staffDetail:staffEntity param:nil success:^(NSArray *result) {
        [self hideLoading];
        
        staffEntity = [result firstObject];
        
        [detailView setData:@"staff" value:staffEntity];
        [detailView renderData];
        NSLog(@"员工ID是：%@",self.staffId);
        
    } failure:^(ErrorEntity *error) {
        
    }];
}

- (void)actionEdit
{
    StaffFormViewController *formViewController = [[StaffFormViewController alloc] init];
    formViewController.staffId = staffId;
    [self pushViewController:formViewController animated:YES];
}

- (void)actionUploadAvatar
{
    UIActionSheet *sheet = [UIActionSheet alloc];
    
    //判断是否可用照相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) {
        sheet = [sheet initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    } else {
        sheet = [sheet initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:nil, nil];
    }
    sheet.tag = 1;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 1:
        {
            NSUInteger sourceType = 0;
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) {
                if (buttonIndex == 2) return;
                if (buttonIndex == 0) {
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                } else if (buttonIndex == 1){
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
        case 2:
        {
            if (buttonIndex == 1) return;
            [self showLoading:TIP_REQUEST_MESSAGE];
            
            StaffHandler *staffHandler = [[StaffHandler alloc] init];
            
            NSDictionary *param = @{
                                    @"newpass" : @"888888",
                                    @"type" : @"reset"
                                    };
            
            [staffHandler resetStaffPassword:staffEntity param:param success:^(NSArray *result) {
                [self hideLoading];
                [self showSuccess:@"重置密码成功"];
            } failure:^(ErrorEntity *error) {
                [self showError:error.message];
            }];

        }
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion: ^(void){}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
   
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //上传头像
    FileEntity *avatarEntity = [[FileEntity alloc] initWithImage:image compression:0.3];
    avatarEntity.field = @"file";
    avatarEntity.name = @"avatar.jpg";
    avatarEntity.id = [NSString stringWithFormat:@"%@",staffId];
    
    StaffHandler *staffHandler = [[StaffHandler alloc] init];
    [staffHandler uploadAvatar:avatarEntity success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            [self showSuccess:@"上传头像成功"];
            FileEntity *imageEntity = [result firstObject];
            NSLog(@"头像上传成功：%@", imageEntity.url);
            staffEntity = [[StaffEntity alloc] init];
            staffEntity.avatar = imageEntity.url;
            
            [detailView setData:@"avatar" value:staffEntity];
            [detailView setUploadAvatar];
            
        }];
    } failure:^(ErrorEntity *error){
        NSLog(@"员工头像上传失败：%@", error.message);
        [self showError:error.message];
    }];
}

- (void)actionRestPassword
{
    UIActionSheet *sheet = [UIActionSheet alloc];
    sheet = [sheet initWithTitle:@"您是否确认要重置密码？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil, nil];
    sheet.tag = 2;
    [sheet showInView:self.view];
}

@end
