//
//  BusinessViewController.m
//  LttMember
//
//  Created by wuyong on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessViewController.h"
#import "BusinessView.h"
#import "BusinessEntity.h"
#import "BusinessHandler.h"
#import "MWPhotoBrowser.h"

@interface BusinessViewController () <BusinessViewDelegate, MWPhotoBrowserDelegate>

@end

@implementation BusinessViewController
{
    BusinessView *businessView;
    BusinessEntity *business;
    
    NSMutableArray *photos;
    NSMutableArray *thumbs;
    MWPhotoBrowser *photoBrowser;
}

- (void)loadView
{
    businessView = [[BusinessView alloc] init];
    businessView.delegate = self;
    self.view = businessView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"详情";
    
    [self showLoading:[FWLocale system:@"Loading.Start"]];
    [self loadData:^(id object) {
        [self hideLoading];
        
        [businessView assign:@"business" value:business];
        [businessView display];
    } failure:^(ErrorEntity *error) {
        [self showError:error.message];
    }];
}

//加载微商数据
- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    BusinessEntity *businessEntity = [[BusinessEntity alloc] init];
    businessEntity.id = self.businessId;
    
    BusinessHandler *businessHandler = [[BusinessHandler alloc] init];
    [businessHandler queryBusiness:businessEntity success:^(NSArray *result) {
        business = [result firstObject];
        
        success(nil);
    } failure:^(ErrorEntity *error) {
        failure(error);
    }];
}

#pragma mark - Action
- (void)actionBusiness
{
    
}

- (void)actionPreview:(NSUInteger)index
{
    //初始化数据
    if (!photos) {
        photos = [NSMutableArray array];
        thumbs = [NSMutableArray array];
        
        MWPhoto *photo, *thumb;
        if (business.images.isNotEmpty) {
            for (ImageEntity *image in business.images) {
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:image.imageUrl]];
                thumb = [MWPhoto photoWithURL:[NSURL URLWithString:image.thumbUrl]];
                [photos addObject:photo];
                [thumbs addObject:thumb];
            }
        }
    }
    
    //初始化图片浏览器
    if (!photoBrowser) {
        photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        photoBrowser.displayActionButton = YES;
        photoBrowser.displayNavArrows = YES;
        photoBrowser.displaySelectionButtons = NO;
        photoBrowser.alwaysShowControls = NO;
        photoBrowser.zoomPhotosToFill = NO;
        photoBrowser.enableGrid = NO;
        photoBrowser.startOnGrid = NO;
        photoBrowser.enableSwipeToDismiss = NO;
        photoBrowser.autoPlayOnAppear = NO;
    }
    
    //设置索引
    NSLog(@"preview: %ld", index);
    [photoBrowser setCurrentPhotoIndex:index];
    
    //Model弹出
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:photoBrowser];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - PhotoBrowser
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photos.count)
        return [photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < thumbs.count)
        return [thumbs objectAtIndex:index];
    return nil;
}

@end
