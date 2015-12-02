//
//  RecommendShareViewController.m
//  LttMember
//
//  Created by wuyong on 15/12/1.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "RecommendShareViewController.h"
#import "RecommendShareView.h"
#import "RecommendViewController.h"
#import "UMSocial.h"

@interface RecommendShareViewController () <RecommendShareViewDelegate>

@end

@implementation RecommendShareViewController
{
    RecommendShareView *recommendShareView;
}

- (void)loadView
{
    recommendShareView = [[RecommendShareView alloc] init];
    recommendShareView.delegate = self;
    self.view = recommendShareView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"推荐与分享";
}

#pragma mark - Action
- (void)actionRecommend
{
    RecommendViewController *viewController = [[RecommendViewController alloc] init];
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
