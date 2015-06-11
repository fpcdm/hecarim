//
//  OrderListViewController.m
//  LttCustomer
//
//  Created by wuyong on 15/4/29.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderDetailViewController.h"
#import "OrderEntity.h"
#import "GoodsEntity.h"
#import "OrderHandler.h"

@interface OrderListViewController ()

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderListViewCell" bundle:nil] forCellReuseIdentifier:@"OrderListViewCell"];
    
    [self initView];
}

//加载数据
- (void) initView
{
    [self showLoading:LocalString(@"TIP_LOADING_MESSAGE")];
    
    //调用接口
    OrderHandler *orderHandler = [[OrderHandler alloc] init];
    [orderHandler queryOrders:nil success:^(NSArray *result){
        [self hideLoading];
        
        //刷新表格
        self.tableData = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
        
        //无数据提示
        [self showEmpty:@"暂无订单"];
    } failure:^(ErrorEntity *error){
        [self hideLoading];
        [self showError:error.message];
    }];
}

#pragma mark - Table Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"OrderListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identify];
    }
    
    OrderEntity *order = [self.tableData objectAtIndex:[indexPath row]];
    
    //初始化单元格
    UILabel *employeeLabel = (UILabel *) [cell viewWithTag:101];
    employeeLabel.text = (order.sellerName ? [order.sellerName stringByAppendingString:@" "] : @"");
    employeeLabel.text = [employeeLabel.text stringByAppendingString:order.sellerMobile];
    
    UITextView *textView = (UITextView *) [cell viewWithTag:102];
    NSString *goodsText = @"";
    GoodsEntity *goodsModel = [[GoodsEntity alloc] init];
    for (NSDictionary *goods in order.goods) {
        //转换为商品Model
        goodsModel.id = [goods objectForKey:@"goods_id"];
        goodsModel.name = [goods objectForKey:@"goods_name"];
        goodsModel.number = [goods objectForKey:@"goods_num"];
        goodsModel.price = [goods objectForKey:@"goods_price"];
        
        NSNumber *total = [goodsModel total];
        goodsText = [goodsText stringByAppendingFormat:@"%@：%@ x %@ = %@元\n", goodsModel.name, goodsModel.price, goodsModel.number, total];
    }
    textView.text = goodsText;
    textView.editable = NO;
    //禁用滚动
    if ([order.goods count] < 4) {
        textView.scrollEnabled = NO;
    }
    
    UILabel *amountLabel = (UILabel *) [cell viewWithTag:103];
    amountLabel.text = [[order.amount stringValue] stringByAppendingString:@"元"];
    
    UIButton *detailButton = (UIButton *) [cell viewWithTag:104];
    //索引值放到tag
    detailButton.tag = [indexPath row];
    [detailButton addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) showDetail: (UIButton *) sender
{
    OrderEntity *order = (OrderEntity *) [self.tableData objectAtIndex:sender.tag];
    
    OrderDetailViewController *viewController = [[OrderDetailViewController alloc] init];
    viewController.orderNo = order.no;
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
    
}

@end
