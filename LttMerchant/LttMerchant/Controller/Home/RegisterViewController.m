//
//  RegisterViewController.m
//  LttMember
//
//  Created by wuyong on 15/7/6.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterMobileView.h"
#import "RegisterExistView.h"
#import "RegisterPasswordView.h"
#import "RegisterSuccessView.h"
#import "RegisterInfoView.h"
#import "ValidateUtil.h"
#import "UIViewController+BackButtonHandler.h"
#import "UserHandler.h"
#import "HelperHandler.h"
#import "TimerUtil.h"
#import "LoginActivity.h"
#import "MerchantHandler.h"
@interface RegisterViewController () <RegisterMobileViewDelegate, RegisterExistViewDelegate, RegisterPasswordViewDelegate,RegisterInfoViewDelegate, RegisterSuccessViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation RegisterViewController
{
    NSString *mobile;
    NSString *mobileStatus;
    NSString *password;
    
    UIButton *sendButton;
    TimerUtil *timerUtil;
    NSString *vCode;
    
    NSString *imageTag;
    
    NSString *licenseUrl;
    NSString *cardUrl;
}

- (void)loadView
{
    self.view = [self mobileInputView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_MAIN_BG;
    
    self.navigationItem.title = @"注册";
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //自动关闭定时器
    [self clearTimer];
}

#pragma mark - View
- (RegisterMobileView *) mobileInputView
{
    RegisterMobileView *currentView = [[RegisterMobileView alloc] init];
    currentView.delegate = self;
    sendButton = currentView.sendButton;
    self.navigationItem.title = @"商户注册";
    [self checkButton];
    return currentView;
}

- (RegisterExistView *) mobileExistView
{
    RegisterExistView *currentView = [[RegisterExistView alloc] init];
    currentView.delegate = self;
    self.navigationItem.title = @"注册";
    return currentView;
}

- (RegisterInfoView *) infoInputView
{
    RegisterInfoView *currentView = [[RegisterInfoView alloc] init];
    currentView.delegate = self;
    [currentView setTipViewHide:NO];
    self.navigationItem.title = @"设置商户信息";
    return currentView;
}

- (RegisterPasswordView *) mobilePasswordView
{
    RegisterPasswordView *currentView = [[RegisterPasswordView alloc] init];
    currentView.delegate = self;
    self.navigationItem.title = @"帐号密码";
    return currentView;
}

- (RegisterSuccessView *) mobileSuccessView
{
    RegisterSuccessView *currentView = [[RegisterSuccessView alloc] init];
    currentView.delegate = self;
    self.navigationItem.title = @"注册成功";
    return currentView;
}

//发送短信
- (void) sendSms: (CallbackBlock) success failure: (CallbackBlock) failure
{
    int timeLeft = [self getSmsTimeLeft];
    if (timeLeft == -1) {
        HelperHandler *helperHandler = [[HelperHandler alloc] init];
        [helperHandler sendMobileCode:mobile success:^(NSArray *result){
            NSLog(@"给手机号%@发送短信：%@", mobile, [NSDate date]);
            [[StorageUtil sharedStorage] setSmsTime:[NSDate date]];
            success(nil);
        } failure:^(ErrorEntity *error){
            failure(error);
        }];
    } else {
        ErrorEntity *error = [[ErrorEntity alloc] init];
        error.message = [NSString stringWithFormat:@"%d秒后才能再次发送", timeLeft];
        failure(error);
    }
}

//清空定时器
- (void) clearTimer
{
    if (timerUtil) {
        [timerUtil invalidate];
        timerUtil = nil;
    }
}

//计算短信发送剩余间隔
- (int) getSmsTimeLeft
{
    NSDate *lastDate = [[StorageUtil sharedStorage] getSmsTime];
    if (lastDate && lastDate != nil) {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastDate];
        int timeLeft = (int) (USER_SMS_INTERVAL - timeInterval);
        if (timeLeft >= 1) {
            return timeLeft;
        }
    }
    
    return -1;
}

//检查短信发送状态（自动发送短信）
- (BOOL) checkButton
{
    UIButton *button = sendButton;
    if (!button) return NO;
    
    //发送短信间隔
    int timeLeft = [self getSmsTimeLeft];
    if (timeLeft != -1) {
        NSLog(@"不能发送短信，还差%d秒", timeLeft);
        
        //初始化定时器
        [self clearTimer];
        timerUtil = [TimerUtil repeatTimer:1.0f block:^{
            int smsLeft = [self getSmsTimeLeft];
            if (smsLeft == -1) {
                [self clearTimer];
                
                [button setTitle:@"重新获取" forState:UIControlStateNormal];
                button.backgroundColor = COLOR_MAIN_WHITE;
            } else {
                [button setTitle:[NSString stringWithFormat:@"%d秒后重发", smsLeft] forState:UIControlStateNormal];
                button.backgroundColor = COLOR_MAIN_BG;
            }
        } queue:dispatch_get_main_queue()];
            
        return NO;
    }
    
    //发送短信
    [button setTitle:@"重新获取" forState:UIControlStateNormal];
    button.backgroundColor = COLOR_MAIN_WHITE;
    return YES;
}

#pragma mark - Back
- (BOOL) navigationShouldPopOnBackButton
{
    if ([self.view isMemberOfClass:[RegisterMobileView class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.view isMemberOfClass:[RegisterExistView class]]) {
        [self popView:[self mobileInputView] animated:YES completion:nil];
    } else if ([self.view isMemberOfClass:[RegisterInfoView class]]) {
        [self popView:[self mobileInputView] animated:YES completion:nil];
    } else if ([self.view isMemberOfClass:[RegisterPasswordView class]]) {
        [self popView:[self mobileInputView] animated:YES completion:nil];
    } else if ([self.view isMemberOfClass:[RegisterSuccessView class]]) {
        [self actionLogin];
    }
    return NO;
}

#pragma mark - Action
- (void) actionCheckMobile:(NSString *)inputMobile code:(NSString *)code
{
    //参数检查
    if (![ValidateUtil isRequired:inputMobile]) {
        [self showError:ERROR_MOBILE_REQUIRED];
        return;
    }
    if (![ValidateUtil isMobile:inputMobile]) {
        [self showError:ERROR_MOBILE_FORMAT];
        return;
    }
    if (![ValidateUtil isRequired:code]) {
        [self showError:ERROR_MOBILECODE_REQUIRED];
        return;
    }
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //检查手机号是否已经注册
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler checkMobile:inputMobile success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            ResultEntity *checkResult = [result firstObject];
            
            mobile = inputMobile;
            mobileStatus = checkResult.data;
            NSLog(@"check mobile result: %@", checkResult.data);
            if ([@"registered" isEqualToString:mobileStatus]) {
                RegisterExistView *existView = [self mobileExistView];
                [self pushView:existView animated:YES completion:^{
                    [existView setData:@"mobile" value:mobile];
                    [existView renderData];
                }];
            } else {
                //检查校验码是否正确
                HelperHandler *helperHandler = [[HelperHandler alloc] init];
                [helperHandler verifyMobileCode:inputMobile code:code success:^(NSArray *result){
                    [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
                        ResultEntity *verifyResult = [result firstObject];
                        vCode = verifyResult.data;
                        NSLog(@"安全码是：%@",vCode);
                        
                        [self userType];
                    }];
                } failure:^(ErrorEntity *error){
                    [self showError:error.message];
                }];
            }
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void)userType
{
    //未注册,去到填写密码视图
    if ([@"unregistered" isEqualToString:mobileStatus]) {
        [self pushView:[self mobilePasswordView] animated:YES completion:nil];
    } else {
        RegisterInfoView *infoView = [self infoInputView];
        [self pushView:infoView animated:YES completion:nil];
        [infoView setTipViewHide:YES];
    }
}

- (void) actionLogin
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) actionSend: (NSString *)inputMobile
{
    //未到发送时间
    int timeLeft = [self getSmsTimeLeft];
    if (timeLeft != -1) {
        return;
    }
    
    if (![ValidateUtil isRequired:inputMobile]) {
        [self showError:ERROR_MOBILE_REQUIRED];
        return;
    }
    if (![ValidateUtil isMobile:inputMobile]) {
        [self showError:ERROR_MOBILE_FORMAT];
        return;
    }
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //检查手机号是否已经注册
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler checkMobile:inputMobile success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            ResultEntity *checkResult = [result firstObject];
            
            mobile = inputMobile;
            mobileStatus = checkResult.data;
            NSLog(@"check mobile result: %@", checkResult.data);
            if ([@"registered" isEqualToString:mobileStatus]) {
                RegisterExistView *existView = [self mobileExistView];
                [self pushView:existView animated:YES completion:^{
                    [existView setData:@"mobile" value:mobile];
                    [existView renderData];
                }];
            } else {
                //发送短信验证码
                [self sendSms:^(id object){
                    [self checkButton];
                } failure:^(ErrorEntity *error){
                    [self checkButton];
                    [self showError:error.message];
                }];
            }
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

- (void)actionSendPassword:(NSString *)pwd confirmPwd:(NSString *)confirmPwd
{
    if (![ValidateUtil isRequired:pwd]) {
        [self showError:ERROR_PASSWORD_REQUIRED];
        return;
    }
    if (![ValidateUtil isLengthBetween:pwd from:6 to:20]) {
        [self showError:ERROR_PASSWORD_LENGTH];
        return;
    }
    if (![confirmPwd isEqualToString:pwd]) {
        [self showError:@"两次密码不相等哦~亲！"];
        return;
    }
    password = pwd;
    RegisterInfoView *infoView = [self infoInputView];
    [self pushView:infoView animated:YES completion:nil];
    [infoView setTipViewHide:NO];
}


//商户注册验证
- (void)actoinRegister:(MerchantEntity *)merchant
{
    NSString *merchantName = [merchant.merchant_name trim];
    if (![ValidateUtil isRequired:merchantName]) {
        [self showError:ERROR_MERCHANT_REQUIRED];
        return;
    }
    NSString *merchantAddress = [merchant.merchant_address trim];
    if (![ValidateUtil isRequired:merchantAddress]) {
        [self showError:ERROR_MERCHANTADDRESS_REQUIRED];
        return;
    }
    NSString *contactName = [merchant.contacter trim];
    if (![ValidateUtil isRequired:contactName]) {
        [self showError:ERROR_CONTACT_REQUIRED];
        return;
    }
    NSString *contacterId = [merchant.contacter_id trim];
    if (![ValidateUtil isRequired:contacterId]) {
        [self showError:ERROR_CONTACTID_REQUIRED];
        return;
    }
    
    if (![ValidateUtil isRequired:licenseUrl]) {
        [self showError:@"营业执照不能为空哦~亲！"];
        return;
    }
    if (![ValidateUtil isRequired:cardUrl]) {
        [self showError:@"身份证正面照不能为空哦~亲！"];
        return;
    }
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    merchant.mobile = mobile;
    merchant.password = password;
    merchant.licenseUrl = licenseUrl;
    merchant.cardUrl = cardUrl;
    
    //注册用户
    
    MerchantHandler *merchantHandler = [[MerchantHandler alloc] init];
    [merchantHandler registerWithUser:merchant vCode:vCode success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            
            [self pushView:[self mobileSuccessView] animated:YES completion:nil];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
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
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    //上传图片
    FileEntity *imageEntity = [[FileEntity alloc] initWithImage:image compression:0.3];
    imageEntity.field = @"file";
    imageEntity.name = @"upload.jpg";

    
    HelperHandler *helperHandler = [[HelperHandler alloc] init];
    [helperHandler uploadImage:imageEntity success:^(NSArray *result){
        [self loadingSuccess:TIP_REQUEST_SUCCESS callback:^{
            FileEntity *imageEntity = [result firstObject];
            NSLog(@"图片上传成功：%@", imageEntity.url);
            
            //保存头像
            MerchantEntity *merEntity = [[MerchantEntity alloc] init];
            merEntity.avatar = imageEntity.url;
            merEntity.type = imageTag;
            if ([@"license" isEqualToString:imageTag]) {
                licenseUrl = imageEntity.url;
            } else if ([@"card" isEqualToString:imageTag]) {
                cardUrl = imageEntity.url;
            }

            RegisterInfoView *infoView = (RegisterInfoView *) self.view;
            [infoView setData:@"merEntity" value:merEntity];
            [infoView renderData];
            
            //回调上级
            if (self.callbackBlock) {
                self.callbackBlock(merEntity);
            }
        }];
    } failure:^(ErrorEntity *error){
        NSLog(@"图片上传失败：%@", error.message);
        [self showError:error.message];
    }];
}


- (void)actionUploadImage:(NSString *)imgTag
{
    UIActionSheet *sheet = [UIActionSheet alloc];
    
    //检查照相机是否可用
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == YES) {
        sheet = [sheet initWithTitle:nil delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    } else {
        sheet = [sheet initWithTitle:nil delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:nil];
    }
    imageTag = imgTag;
    [sheet showInView:self.view];

}


//切换视图,类似push效果
- (void) pushView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion
{
    if (animated) {
        [UIView animateWithDuration:0.1f
                         animations:^{
                             self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             self.view = view;
                             self.view.backgroundColor = COLOR_MAIN_BG;
                             self.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                             [UIView animateWithDuration:0.2f
                                              animations:^{
                                                  self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  if (completion) completion();
                                              }
                              ];
                         }
         ];
    } else {
        self.view = view;
        self.view.backgroundColor = COLOR_MAIN_BG;
        if (completion) completion();
    }
}

//切换视图,类似pop效果
- (void) popView:(UIView *)view animated:(BOOL)animated completion:(void (^)())completion
{
    if (animated) {
        [UIView animateWithDuration:0.1f
                         animations:^{
                             self.view.frame = CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             self.view = view;
                             self.view.backgroundColor = COLOR_MAIN_BG;
                             self.view.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                             [UIView animateWithDuration:0.2f
                                              animations:^{
                                                  self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  if (completion) completion();
                                              }
                              ];
                         }
         ];
    } else {
        self.view = view;
        self.view.backgroundColor = COLOR_MAIN_BG;
        if (completion) completion();
    }
}


@end
