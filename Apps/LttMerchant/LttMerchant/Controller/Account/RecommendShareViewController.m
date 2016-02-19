//
//  RecommendShareViewController.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/2/18.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "RecommendShareViewController.h"
#import "RecommendShareView.h"
#import "RecommendViewController.h"
#import "StaffHandler.h"
#import "RecommendMerchantViewController.h"
#import "UMSocial.h"

@interface RecommendShareViewController ()<RecommendShareViewDelegate>

@end

@implementation RecommendShareViewController
{
    RecommendShareView *recommendShareView;
}

- (void)viewDidLoad {
    isMenuEnabled = YES;
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    recommendShareView = [[RecommendShareView alloc] init];
    recommendShareView.delegate = self;
    self.view = recommendShareView;

    self.navigationItem.title = @"推荐与分享";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //检查用户权限
    StaffHandler *staffHandler = [[StaffHandler alloc] init];
    [staffHandler userPermissions:nil success:^(NSArray *result) {
        StaffEntity *staffEntity = [result firstObject];
        [recommendShareView assign:@"is_admin" value:staffEntity.is_admin];
        [recommendShareView display];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

- (void)actionRecommend
{
    RecommendViewController *viewController = [[RecommendViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionMerchant
{
    RecommendMerchantViewController *viewController = [[RecommendMerchantViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)actionShare
{
    //设置标题
    [UMSocialData defaultData].extConfig.wechatSessionData.title = UMENG_SHARE_TITLE;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = UMENG_SHARE_TITLE;
    [UMSocialData defaultData].extConfig.qqData.title = UMENG_SHARE_TITLE;
    [UMSocialData defaultData].extConfig.qzoneData.title = UMENG_SHARE_TITLE;
    
    //设置消息
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UMENG_SHARE_APPKEY
                                      shareText:UMENG_SHARE_TEXT
                                     shareImage:[UIImage imageNamed:@"icon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToSms,UMShareToEmail,nil]
                                       delegate:nil];
}

@end
