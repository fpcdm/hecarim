//
//  BusinessListViewController.m
//  LttMember
//
//  Created by wuyong on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessListViewController.h"
#import "BusinessListView.h"
#import "BusinessEntity.h"
#import "BusinessHandler.h"
#import "BusinessViewController.h"
#import "MWPhotoBrowser.h"

@interface BusinessListViewController () <BusinessListViewDelegate, MWPhotoBrowserDelegate>

@end

@implementation BusinessListViewController
{
    BusinessListView *listView;
    NSMutableArray *businessList;
    
    NSMutableArray *photos;
    NSMutableArray *thumbs;
    MWPhotoBrowser *photoBrowser;
    BusinessEntity *photoBusiness;
    
    //当前页数
    int page;
    BOOL hasMore;
    
    NSString *cityCode;
}

- (void)loadView
{
    listView = [[BusinessListView alloc] init];
    listView.delegate = self;
    self.view = listView;
}

- (void)viewDidLoad {
    showTabBar = YES;
    isIndexNavBar = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"微商";
    
    //默认值
    businessList = [NSMutableArray array];
    page = 0;
    hasMore = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //检查城市是否改变
    BOOL isCityChanged = NO;
    NSString *newCityCode = [[StorageUtil sharedStorage] getCityCode];
    if (cityCode && newCityCode && ![newCityCode isEqualToString:cityCode]) {
        isCityChanged = YES;
        cityCode = newCityCode;
    } else {
        cityCode = newCityCode;
    }
    
    //城市改变重新加载
    if (isCityChanged) {
        [self refreshData];
    }
}

- (void)handleUserChanged
{
    //切换用户重新加载
    [self refreshData];
}

- (void)refreshData
{
    //清空之前的数据
    if (businessList && [businessList count] > 0) {
        businessList = [[NSMutableArray alloc] init];
        [listView assign:@"businessList" value:businessList];
        [listView display];
    }
    
    //还原数据
    businessList = [[NSMutableArray alloc] init];
    page = 0;
    hasMore = YES;
    
    //加载数据
    [listView.tableView setRefreshLoadingState:RefreshLoadingStateMoreData];
    [listView.tableView startLoading];
}

- (void)loadData:(CallbackBlock)success failure:(CallbackBlock)failure
{
    //分页加载
    page++;
    
    BusinessHandler *businessHandler = [[BusinessHandler alloc] init];
    NSDictionary *param = @{@"page":[NSNumber numberWithInt:page], @"page_size":[NSNumber numberWithInt:LTT_PAGESIZE_DEFAULT]};
    [businessHandler queryBusinessList:param success:^(NSArray *result) {
        for (BusinessEntity *business in result) {
            [businessList addObject:business];
        }
        
        //是否还有更多
        hasMore = [result count] >= LTT_PAGESIZE_DEFAULT ? YES : NO;
        
        success(nil);
    } failure:^(ErrorEntity *error){
        failure(error);
    }];
}

#pragma mark - Action
- (void)actionRefresh:(UITableView *)tableView
{
    businessList = [NSMutableArray array];
    page = 0;
    hasMore = YES;
    
    [self loadData:^(id object){
        [listView.tableView stopRefreshLoading];
        
        [listView assign:@"businessList" value:businessList];
        [listView display];
        
        //根据数据切换刷新状态
        if (hasMore) {
            [listView.tableView setRefreshLoadingState:RefreshLoadingStateMoreData];
        } else if ([businessList count] < 1) {
            [listView.tableView setRefreshLoadingState:RefreshLoadingStateNoData];
        } else {
            [listView.tableView setRefreshLoadingState:RefreshLoadingStateNoMoreData];
        }
    } failure:^(ErrorEntity *error){
        [listView.tableView stopRefreshLoading];
        
        [self showError:error.message];
    }];
}

- (void)actionLoad:(UITableView *)tableView
{
    //加载数据
    [self loadData:^(id object){
        [tableView stopRefreshLoading];
        if (!hasMore) {
            [tableView setRefreshLoadingState:RefreshLoadingStateNoMoreData];
        }
        
        [listView assign:@"businessList" value:businessList];
        [listView display];
    } failure:^(ErrorEntity *error){
        [tableView stopRefreshLoading];
        
        [self showError:error.message];
    }];
}

- (void)actionDetail:(BusinessEntity *)business
{
    BusinessViewController *viewController = [[BusinessViewController alloc] init];
    viewController.businessId = business.id;
    [self pushViewController:viewController animated:YES];
}

- (void)actionPreview:(BusinessEntity *)business index:(NSUInteger)index
{
    //是否预览的同一个，不是同一个则重新加载图片
    BOOL isPreviewLast = photoBusiness && [business.id isEqualToNumber:photoBusiness.id] ? YES : NO;
    if (!isPreviewLast) {
        photos = nil;
        photoBrowser = nil;
    }
    
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
