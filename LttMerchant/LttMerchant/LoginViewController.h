//
//  LoginViewController.h
//  LttMerchant
//
//  Created by wuyong on 15/4/27.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"

@interface LoginViewController : AppViewController

@property (assign, nonatomic) BOOL tokenExpired;

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginSubmitAction:(id)sender;

@end
