//
//  BusinessListView.m
//  LttMerchant
//
//  Created by 杨海锋 on 16/3/1.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessListView.h"

@implementation BusinessListView
{
    NSMutableArray *rowArr;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    

    //初始化空视图
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 20)];
    emptyLabel.font = [UIFont systemFontOfSize:18];
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"你还没有发布生意圈信息";
    self.tableView.emptyView = emptyLabel;
    
    [self.tableView setLoadingFooter:self action:@selector(actionLoadMore)];
    
    
    return self;
}

- (CGFloat)getContentHeight:(NSString *)content
{
    if (!content || content.length < 1) return 0;
    
    CGSize textSize=[content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT_MAIN} context:nil].size;
    CGRect textF=CGRectMake(0, 0, textSize.width, textSize.height);
    
    CGFloat cellHeight = CGRectGetMaxY(textF)+10;
    return cellHeight;
}

#pragma mark - RenderData
- (void)display
{
    //显示数据
    NSMutableArray *businessList = [self fetch:@"businessList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    rowArr = [[NSMutableArray alloc] init];
    if (businessList != nil) {
        for (BusinessEntity *business in businessList) {
            CGFloat cellHeight = [self getContentHeight:business.newsContent];
            
            [tableData addObject:@[@{
                                       @"id" : @"business",
                                       @"type" : @"custom",
                                       @"action": @"actionDetail:",
                                       @"height": @(cellHeight+50),
                                       @"data": business
                                       }]];
        }
    }
    self.tableData = tableData;
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    BusinessEntity *businessList = [cellData objectForKey:@"data"];
    cell.backgroundColor = [UIColor whiteColor];

    //间距配置
    int padding = 10;
    UIView *superview = cell;
    
    CGFloat textHeight = [self getContentHeight:businessList.newsContent];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = businessList.newsContent;
    contentLabel.numberOfLines = 0;
    contentLabel.font = FONT_MAIN;
    contentLabel.textColor = COLOR_MAIN_BLACK;
    [cell addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(5);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@(textHeight));
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = businessList.createTime;
    timeLabel.textColor = COLOR_MAIN_GRAY;
    timeLabel.font = FONT_MAIN;
    [cell addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.bottom.equalTo(superview.mas_bottom).offset(-padding);
        
        make.height.equalTo(@20);
    }];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section > 0 ? HEIGHT_TABLE_MARGIN_ZERO : HEIGHT_TABLE_MARGIN_DEFAULT;
}

- (void)actionLoadMore
{
    [self.delegate actionLoadMore];
}

- (void)actionDetail:(NSDictionary *)cellData
{
    BusinessEntity *businessEntity = [cellData objectForKey:@"data"];
    
    [self.delegate actionDetail:businessEntity];
}


@end
