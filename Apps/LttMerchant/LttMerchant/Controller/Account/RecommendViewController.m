//
//  RecommendViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/2/18.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendView.h"
#import "UserHandler.h"

@interface RecommendViewController ()<RecommendViewDelegate,UIActionSheetDelegate>

@end

@implementation RecommendViewController
{
    RecommendView *recommendView;
    NSString *mobile;
}

- (void)viewDidLoad {
    isMenuEnabled = NO;
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    recommendView = [[RecommendView alloc] init];
    recommendView.delegate = self;
    self.view = recommendView;
    
    self.navigationItem.title = @"我的推荐人";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //调用查询推荐人手机号接口
    UserEntity *userEntity = [[StorageUtil sharedStorage] getUser];
    UserHandler *userHandler = [[UserHandler alloc] init];
    [userHandler getUserRecommendInfo:userEntity param:nil success:^(NSArray *result) {
        [self hideLoading];
        
        //重新加载视图
        UserEntity *userEntity = [result firstObject];
        [FWLog log:@"我的推荐人是：%@",userEntity.mobile];
        [recommendView assign:@"recommendMobile" value:userEntity.mobile];
        [recommendView display];
        
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];

}

//添加我的推荐人
- (void)actionRecommend:(NSString *)recommendMobile
{
    if (![ValidateUtil isRequired:recommendMobile]) {
        [self showError:[FWLocale error:@"RecommendMobile.Required"]];
        return;
    }
    if (![ValidateUtil isMobile:recommendMobile]) {
        [self showError:[FWLocale error:@"Mobile.Format"]];
        return;
    }
    mobile = recommendMobile;
    [recommendView hideKeyboard];
    [self showSheet:recommendMobile];
    
}

- (void)showSheet:(NSString *)recommendMobile
{
    UIActionSheet *sheet = [UIActionSheet alloc];
    
    sheet = [sheet initWithTitle:[NSString stringWithFormat:@"你输入的推荐人手机为\n%@\n推荐人一旦提交就不能修改，你确认提交吗？",recommendMobile] delegate:self cancelButtonTitle: @"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil];
    
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
            [self showLoading:[FWLocale system:@"Request.Start"]];
            //调用添加推荐人手机号接口
            UserEntity *userEntity = [[StorageUtil sharedStorage] getUser];
            UserHandler *userHandler = [[UserHandler alloc] init];
            NSDictionary *param = @{@"reference" : mobile};
            [userHandler setRecommend:userEntity param:param success:^(NSArray *result) {
                [self hideLoading];
                
                //重新加载视图
                [recommendView assign:@"recommendMobile" value:mobile];
                [recommendView display];
                
            } failure:^(ErrorEntity *error) {
                [self showError:error.message];
            }];
            
        }
            break;
            //取消
        default:
            [FWLog log:@"取消设置我的推荐人"];
            break;
    }
}


@end
