//
//  BusinessAddViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessAddViewController.h"
#import "BusinessAddView.h"
#import "HelperHandler.h"
#import "BusinessHandler.h"
#import "BusinessServicesListViewController.h"

@interface BusinessAddViewController ()<BusinessAddViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@end

@implementation BusinessAddViewController
{
    BusinessAddView *addView;
    NSNumber *caseId;
    NSNumber *propertyId;
    NSMutableArray *newsImgs;
}

@synthesize businessEntity;

- (void)viewDidLoad {
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    addView = [[BusinessAddView alloc] init];
    addView.delegate = self;
    self.view = addView;
    
    self.navigationItem.title = @"写生意圈信息";
    
    UIBarButtonItem *sendMsgButton = [AppUIUtil makeBarButtonItem:@"发布" highlighted:isIndexNavBar];
    sendMsgButton.target = self;
    sendMsgButton.action = @selector(actionSendMsg);
    self.navigationItem.rightBarButtonItem = sendMsgButton;
    
    newsImgs = [[NSMutableArray alloc] init];
}

- (void)actionSendMsg
{
    NSString *content = addView.textView.text;
    
    if (![ValidateUtil isRequired:content]) {
        [self showError:[FWLocale error:@"BusinessContent.Required"]];
        return;
    }
    if (!caseId) {
        [self showError:[FWLocale error:@"CaseId.Required"]];
        return;
    }
    
    [self showLoading:[FWLocale system:@"Request.Start"]];
    
    BusinessHandler *businessHandler = [[BusinessHandler alloc] init];
    NSDictionary *param = @{
                            @"case_type":caseId,
                            @"case_type_property":propertyId,
                            @"content" : content,
                            @"img_list" : newsImgs
                            };
    FWDUMP(@"request data: %@", param);
    [businessHandler addBusiness:businessEntity param:param success:^(NSArray *result){
        [self hideLoading];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

//绑定服务
- (void)actionAddServices
{
    BusinessServicesListViewController *viewController = [[BusinessServicesListViewController alloc] init];
    viewController.callbackBlock = ^(NSDictionary *servicesData){
        caseId = [servicesData objectForKey:@"type_id"];
        propertyId = [servicesData objectForKey:@"propertyId"];
        [addView assign:@"selectServices" value:servicesData];
        [addView showServices];
    };
    [self pushViewController:viewController animated:YES];
}

//添加图片
- (void)actionAddImage
{
    UIActionSheet *sheet = [UIActionSheet alloc];
    
    //检查照相机是否可用
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) {
        sheet = [sheet initWithTitle:nil delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    } else {
        sheet = [sheet initWithTitle:nil delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:nil];
    }
    
    sheet.tag = 1;
    [sheet showInView:self.view];
}

- (void)actionDeletedItemImages:(NSInteger)imagesId
{
    [newsImgs removeObjectAtIndex:imagesId];
    [addView assign:@"newsImgs" value:newsImgs];
    [addView showImg];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
    picker.allowsEditing = NO;
    
    [self presentViewController:picker animated:YES completion:^(void){}];
}


// 选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion: ^(void){}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self showLoading:[FWLocale info:@"Upload.Start"]];
    
    //上传图片
    FileEntity *imageEntity = [[FileEntity alloc] initWithImage:image compression:0.3];
    imageEntity.field = @"file";
    imageEntity.name = @"upload.jpg";
    
    
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler uploadImage:imageEntity success:^(NSArray *result){
        [self loadingSuccess:[FWLocale info:@"Upload.Success"] callback:^{
            FileEntity *imageEntity = [result firstObject];
            NSLog(@"图片上传成功：%@", imageEntity.url);
            
            [newsImgs addObject:imageEntity.url];
            [addView assign:@"newsImgs" value:newsImgs];
            [addView showImg];
            
        }];
    } failure:^(ErrorEntity *error){
        NSLog(@"图片上传失败：%@", error.message);
        [self showError:error.message];
    }];
}

@end
