//
//  RecommendViewController.m
//  LttMember
//
//  Created by wuyong on 15/12/1.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendView.h"
#import "UserHandler.h"

@interface RecommendViewController () <RecommendViewDelegate, UIActionSheetDelegate>

@end

@implementation RecommendViewController
{
    RecommendView *recommendView;
    NSString *recommendMobile;
}

- (void)loadView
{
    recommendView = [[RecommendView alloc] init];
    recommendView.delegate = self;
    self.view = recommendView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐人信息";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //查询推荐人
    [self showLoading:[LocaleUtil system:@"Loading.Start"]];
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler getReferee:nil success:^(NSArray *result) {
        [self hideLoading];
        
        NSString *referee = nil;
        if ([result count] > 0) {
            UserEntity *refereeEntity = [result firstObject];
            referee = refereeEntity.mobile;
        }
        
        [recommendView assign:@"mobile" value:referee];
        [recommendView display];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

#pragma mark - Action
- (void)actionRecommend:(NSString *)mobile
{
    if (![ValidateUtil isRequired:mobile]) {
        [self showError:[LocaleUtil error:@"Mobile.Required"]];
        return;
    }
    if (![ValidateUtil isMobile:mobile]) {
        [self showError:[LocaleUtil error:@"Mobile.Format"]];
        return;
    }
    
    //缓存数据
    recommendMobile = mobile;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"你输入的推荐人手机为\n%@\n推荐人一旦提交就不能修改，你确认提交吗？",recommendMobile]
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    sheet.tag = 1;
    [sheet showInView:self.view];
}

//弹出sheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag != 1) return;
    
    switch (buttonIndex) {
        //确定
        case 0:
        {
            [self showLoading:[LocaleUtil system:@"Request.Start"]];
            //调用添加推荐人手机号接口
            UserHandler *userHandler = [[UserHandler alloc] init];
            [userHandler setReferee:recommendMobile success:^(NSArray *result) {
                [self hideLoading];
                
                //刷新视图
                [recommendView assign:@"mobile" value:recommendMobile];
                [recommendView display];
            } failure:^(ErrorEntity *error) {
                [self showError:error.message];
            }];
        }
            break;
        //取消
        default:
            NSLog(@"取消");
            break;
    }
}

@end
