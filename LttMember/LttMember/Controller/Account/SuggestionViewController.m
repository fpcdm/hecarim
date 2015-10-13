//
//  SuggestionViewController.m
//  LttMember
//
//  Created by wuyong on 15/6/29.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "SuggestionViewController.h"
#import "SuggestionView.h"
#import "UserHandler.h"
#import "ValidateUtil.h"

@interface SuggestionViewController () <SuggestionViewDelegate>

@end

@implementation SuggestionViewController
{
    SuggestionView *suggestionView;
}

- (void)loadView
{
    suggestionView = [[SuggestionView alloc] init];
    suggestionView.delegate = self;
    self.view = suggestionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"意见反馈";
}

#pragma mark - Action
- (void)actionSave:(NSString *)content
{
    if (![ValidateUtil isRequired:content]) {
        [self showError:@"请输入意见反馈"];
        return;
    }
    
    [self showLoading:TIP_REQUEST_MESSAGE];
    
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler addSuggestion:content success:^(NSArray *result){
        [self showSuccess:@"提交成功，感谢您的意见反馈" callback:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } failure:^(ErrorEntity *error){
        [self showError:error.message];
    }];
}

@end
