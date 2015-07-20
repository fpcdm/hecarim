//
//  RootViewController.m
//  LttMerchant
//
//  Created by wuyong on 15/4/23.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeViewController.h"
#import "ApplyDetailViewController.h"
#import "IntentionEntity.h"
#import "IntentionHandler.h"
#import "LocationUtil.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    //抢单数据缓存，防止定时器清空正在抢的数据
    IntentionEntity *currentIntention;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"两条腿商户端";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyListViewCell" bundle:nil] forCellReuseIdentifier:@"ApplyListViewCell"];
    
    [self initView];
}

//加载数据
- (void) initView
{
    [self showLoading:LocalString(@"TIP_LOADING_MESSAGE")];
    
    CLLocationCoordinate2D position = [[LocationUtil sharedInstance] position];
    NSDictionary *param = @{@"location":[NSString stringWithFormat:@"%f,%f", position.longitude, position.latitude]};
    
    //调用接口
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    [intentionHandler queryIntentions:param success:^(NSArray *result){
        [self hideLoading];
        
        //刷新表格
        self.tableData = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
        
        //无数据提示
        [self showEmpty:@"暂无可抢的订单"];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        [self showError:error.message];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ApplyListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identify];
    }
    
    IntentionEntity *intention = [self.tableData objectAtIndex:[indexPath row]];
    
    UILabel *remarkLabel = (UILabel *) [cell viewWithTag:102];
    NSString *remark = (intention.remark ? intention.remark : @"未填写");
    NSString *createTime = intention.createTime ? [NSString stringWithFormat:@"%@", [intention.createTime substringFromIndex:5]] : @"";
    remarkLabel.text = [NSString stringWithFormat:@"留言：%@    %@", remark, createTime];
    
    UIButton *detailButton = (UIButton *) [cell viewWithTag:103];
    detailButton.tag = [indexPath row];
    [detailButton addTarget:self action:@selector(doIntention:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//抢单
- (void) doIntention: (UIButton *) sender
{
    currentIntention = (IntentionEntity *) [self.tableData objectAtIndex:sender.tag];
    
    //开始抢单
    [self showLoading:LocalString(@"TIP_CHALLENGE_START")];
    
    //调用接口
    IntentionHandler *intentionHandler = [[IntentionHandler alloc] init];
    [intentionHandler competeIntention:currentIntention success:^(NSArray *result){
        [self loadingSuccess:LocalString(@"TIP_CHALLENGE_SUCCESS")];
        
        [self performSelector:@selector(success:) withObject:currentIntention afterDelay:1];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        
        [self showError:LocalString(@"TIP_CHALLENGE_FAIL")];
        
        //刷新表格
        [self.tableData removeObjectAtIndex:sender.tag];
        [self.tableView reloadData];
        
        //无数据提示
        [self showEmpty:@"暂无可抢的订单"];
    }];
}

- (void) success: (IntentionEntity *) intention
{
    [self hideLoading];
    
    //跳转需求详情
    ApplyDetailViewController *viewController = [[ApplyDetailViewController alloc] init];
    viewController.intentionId = intention.id;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
