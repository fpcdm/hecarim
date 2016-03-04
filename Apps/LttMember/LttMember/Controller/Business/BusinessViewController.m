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
#import "LocationEntity.h"
#import "AddressEntity.h"
#import "CaseEntity.h"
#import "CaseFormViewController.h"

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
    //当前定位地址
    AddressEntity *currentAddress = [self currentAddress];
    
    //获取参数
    CaseEntity *intentionEntity = [[CaseEntity alloc] init];
    intentionEntity.typeId = business.typeId;
    intentionEntity.propertyId = business.propertyId ? business.propertyId : @0;
    intentionEntity.buyerAddress = [@1 isEqualToNumber:currentAddress.isEnable] ? currentAddress.address : nil;
    intentionEntity.source = CASE_SOURCE_BUSINESS;
    intentionEntity.sourceId = business.id;
    intentionEntity.merchantId = business.merchantId;
    
    NSLog(@"intention: %@", [intentionEntity toDictionary]);
    
    //跳转表单页面
    CaseFormViewController *viewController = [[CaseFormViewController alloc] init];
    viewController.caseEntity = intentionEntity;
    viewController.currentAddress = currentAddress;
    [self pushViewController:viewController animated:YES];
}

//获取当前定位地址对象
- (AddressEntity *) currentAddress
{
    //读取当前地址缓存
    LocationEntity *lastLocation = [[FWRegistry sharedInstance] get:@"location"];
    if (!lastLocation) lastLocation = [[LocationEntity alloc] init];
    
    UserEntity *user = [[StorageUtil sharedStorage] getUser];
    
    AddressEntity *currentAddress = [[AddressEntity alloc] init];
    currentAddress.name = [user displayName];
    currentAddress.mobile = user.mobile;
    currentAddress.address = lastLocation.detailAddress;
    
    //定位城市是否可用
    NSString *cityCode = [[StorageUtil sharedStorage] getCityCode];
    //没有设置城市，则可以使用定位地址
    if (!cityCode) {
        currentAddress.isEnable = @1;
    //定位城市和设置的城市相同，可以使用定位地址
    } else if (lastLocation.cityCode && [cityCode isEqualToString:lastLocation.cityCode]) {
        currentAddress.isEnable = @1;
    } else {
        currentAddress.isEnable = @0;
    }
    
    return currentAddress;
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
    navigationController.navigationBar.titleTextAttributes = @{
                                          NSFontAttributeName:[UIFont systemFontOfSize:20],
                                          NSForegroundColorAttributeName: COLOR_MAIN_WHITE
                                          };
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
