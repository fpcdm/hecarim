//
//  BusinessListView.m
//  LttMember
//
//  Created by wuyong on 16/3/2.
//  Copyright © 2016年 Gilbert. All rights reserved.
//

#import "BusinessListView.h"

@implementation BusinessListView

- (BOOL)hasTabBar
{
    return YES;
}

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    [self.tableView setRefreshingHeader:self action:@selector(actionRefresh)];
    [self.tableView setLoadingFooter:self action:@selector(actionLoad)];
    [self.tableView startLoading];
    
    return self;
}

#pragma mark - RenderData
- (void)display
{
    //显示数据
    NSMutableArray *businessList = [self fetch:@"businessList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    if (businessList != nil) {
        for (BusinessEntity *business in businessList) {
            //计算高度
            CGFloat cellHeight = [self cellHeight:business];
            
            [tableData addObject:@{@"type" : @"custom", @"action": @"actionDetail:", @"height": @(cellHeight), @"data": business}];
        }
    }
    self.tableData = [[NSMutableArray alloc] initWithObjects:tableData, nil];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    BusinessEntity *business = [cellData objectForKey:@"data"];
    
    //公司名称
    UILabel *merchantLabel = [[UILabel alloc] init];
    merchantLabel.font = FONT_MAIN;
    merchantLabel.textColor = [UIColor colorWithHex:@"#0099CC"];
    merchantLabel.text = business.merchantName;
    [cell addSubview:merchantLabel];
    
    UIView *superview = cell;
    [merchantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@16);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = FONT_MAIN;
    contentLabel.textColor = COLOR_MAIN_BLACK;
    contentLabel.numberOfLines = 0;
    contentLabel.text = business.content;
    [cell addSubview:contentLabel];
    
    CGFloat textHeight = [self adjustTextHeight:business.content];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(merchantLabel.mas_bottom).offset(10);
        make.left.equalTo(superview.mas_left).offset(10);
        make.right.equalTo(superview.mas_right).offset(-10);
        make.height.equalTo(@(textHeight + 4));
    }];
    
    //渲染图片
    [self cellImages:cell business:business];
    
    return cell;
}

- (CGFloat) adjustTextHeight:(NSString *)content
{
    if (!content || content.length < 1) return 0;
    
    CGSize size = [content boundingSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) withFont:FONT_MAIN];
    return size.height;
}

//计算cell高度
- (CGFloat)cellHeight:(BusinessEntity *)business
{
    //计算高度
    CGFloat textHeight = [self adjustTextHeight:business.content];
    CGFloat cellHeight = 50 + textHeight;
    
    //含有图片
    if (business.images.isNotEmpty) {
        //计算宽高
        NSInteger buttonSize = 3;
        CGFloat spaceWidth = 10;
        CGFloat spaceHeight = 10;
        CGFloat buttonWidth = (SCREEN_WIDTH - (buttonSize + 1) * spaceWidth) / buttonSize;
        CGFloat buttonHeight = buttonWidth + spaceHeight;
        
        //绘制图片
        NSInteger imagesCount = [business.images count];
        CGFloat frameX = 0;
        CGFloat frameY = 0;
        for (int i = 0; i < imagesCount; i++) {
            //计算位置
            NSInteger itemRow = (int)(i / buttonSize) + 1;
            NSInteger itemCol = i % buttonSize + 1;
            frameX = spaceWidth + (buttonWidth + spaceWidth) * (itemCol - 1);
            frameY = buttonHeight * (itemRow - 1);
        }
        
        //计算容器宽高
        cellHeight += frameY + buttonHeight;
    }
    
    return cellHeight;
}

- (void)cellImages:(UITableViewCell *)cell business:(BusinessEntity *)business
{
    //是否含有图片
    NSArray *images = business.images;
    if (!images.isNotEmpty) return;
    
    //计算高度
    CGFloat textHeight = [self adjustTextHeight:business.content];
    CGFloat cellHeight = 50 + textHeight - 10;
    
    //计算宽高
    NSInteger buttonSize = 3;
    CGFloat spaceWidth = 10;
    CGFloat spaceHeight = 10;
    CGFloat buttonWidth = (SCREEN_WIDTH - (buttonSize + 1) * spaceWidth) / buttonSize;
    CGFloat buttonHeight = buttonWidth + spaceHeight;
    
    //绘制图片
    NSInteger imagesCount = [images count];
    CGFloat frameX = 0;
    CGFloat frameY = 0;
    for (int i = 0; i < imagesCount; i++) {
        //计算位置
        NSInteger itemRow = (int)(i / buttonSize) + 1;
        NSInteger itemCol = i % buttonSize + 1;
        frameX = spaceWidth + (buttonWidth + spaceWidth) * (itemCol - 1);
        frameY = buttonHeight * (itemRow - 1);
        
        //添加按钮
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(frameX, frameY + cellHeight + spaceHeight, buttonWidth, buttonHeight - spaceHeight)];
        [button addTarget:self action:@selector(actionPreview:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = COLOR_MAIN_CLEAR;
        button.tag = i;
        [cell addSubview:button];
        
        //添加图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:button.bounds];
        [button addSubview:imageView];
        
        //加载图片
        ImageEntity *image = [images objectAtIndex:i];
        [imageView setImageUrl:image.thumbUrl indicator:YES];
    }
    
    //计算容器宽高
    cellHeight += frameY + buttonHeight;
}

//让分割线左侧不留空白
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Action
- (void)actionRefresh
{
    [self.delegate actionRefresh:self.tableView];
}

- (void)actionLoad
{
    [self.delegate actionLoad:self.tableView];
}

- (void)actionDetail:(NSDictionary *)cellData
{
    BusinessEntity *business = [cellData objectForKey:@"data"];
    
    [self.delegate actionDetail:business];
}

- (void)actionPreview:(UIButton *)button
{
    UITableViewCell *cell = (UITableViewCell *) [button superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSDictionary *cellData = [self tableView:self.tableView cellDataForRowAtIndexPath:indexPath];
    BusinessEntity *business = [cellData objectForKey:@"data"];
    [self.delegate actionPreview:business index:button.tag];
}

@end
