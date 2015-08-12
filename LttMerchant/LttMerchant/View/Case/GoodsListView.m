//
//  GoodsListView.m
//  LttMerchant
//
//  Created by wuyong on 15/8/12.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "GoodsListView.h"
#import "GoodsEntity.h"

@implementation GoodsListView

@synthesize delegate;

@dynamic editing;

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableView.scrollEnabled = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    return self;
}

#pragma mark - RenderData
- (void)renderData
{
    //显示数据
    NSArray *goodsList = [self getData:@"goodsList"];
    NSMutableArray *tableData = [[NSMutableArray alloc] init];
    for (GoodsEntity *goods in goodsList) {
        [tableData addObject:@[@{
                                   @"id" : @"goods",
                                   @"type" : @"custom",
                                   @"height": @50,
                                   @"data": goods
                                   }]];
    }
    
    self.tableData = tableData;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    //选中样式
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    GoodsEntity *goods = [cellData objectForKey:@"data"];
    
    //间距：分编辑和非编辑
    CGFloat paddingLeft = self.editing ? 40 : 20;
    
    //名称
    UILabel *nameLabel = [self makeCellLabel:goods.name];
    nameLabel.tag = 101;
    [cell addSubview:nameLabel];
    
    UIView *superview = cell;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(5);
        make.left.equalTo(cell.mas_left).offset(paddingLeft);
        
        make.height.equalTo(@20);
    }];
    
    //描述
    UILabel *specLabel = [self makeCellLabel:goods.specName];
    specLabel.tag = 102;
    specLabel.textColor = COLOR_MAIN_GRAY;
    [cell addSubview:specLabel];
    
    [specLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_bottom).offset(-5);
        make.left.equalTo(cell.mas_left).offset(paddingLeft);
        
        make.height.equalTo(@20);
    }];
    
    //单价
    UILabel *priceLabel = [self makeCellLabel:[NSString stringWithFormat:@"￥%.2f", [goods.price floatValue]]];
    priceLabel.tag = 201;
    priceLabel.font = [UIFont boldSystemFontOfSize:16];
    [cell addSubview:priceLabel];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(5);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@20);
    }];
    
    //数量
    UILabel *numberLabel = [self makeCellLabel:[NSString stringWithFormat:@"x%@", goods.number]];
    numberLabel.tag = 202;
    numberLabel.textColor = COLOR_MAIN_GRAY;
    [cell addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(superview.mas_bottom).offset(-5);
        make.right.equalTo(superview.mas_right).offset(-10);
        
        make.height.equalTo(@20);
    }];
    
    //数量操作
    UIButton *plusButton = [self makeCellButton:@"+"];
    plusButton.tag = 301;
    plusButton.hidden = YES;
    [plusButton addTarget:self action:@selector(actionPlusNumber:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:plusButton];
    
    [plusButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(superview.mas_right).offset(-10);
        make.top.equalTo(superview.mas_top).offset(5);
        make.bottom.equalTo(superview.mas_bottom).offset(-5);
        
        make.width.equalTo(@30);
    }];
    
    UIButton *numberButton = [self makeCellButton:[NSString stringWithFormat:@"%@", goods.number]];
    numberButton.tag = 302;
    numberButton.hidden = YES;
    [cell addSubview:numberButton];
    
    [numberButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(plusButton.mas_top);
        make.bottom.equalTo(plusButton.mas_bottom);
        make.right.equalTo(plusButton.mas_left).offset(-5);
        
        make.width.equalTo(@50);
    }];
    
    UIButton *minusButton = [self makeCellButton:@"-"];
    minusButton.tag = 303;
    minusButton.hidden = YES;
    [minusButton addTarget:self action:@selector(actionMinusNumber:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:minusButton];
    
    [minusButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(plusButton.mas_top);
        make.bottom.equalTo(plusButton.mas_bottom);
        make.right.equalTo(numberButton.mas_left).offset(-5);
        
        make.width.equalTo(@30);
    }];
    
    return cell;
}

//绘制cell中的label
- (UILabel *) makeCellLabel: (NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.font = FONT_MAIN;
    return label;
}

- (UIButton *) makeCellButton: (NSString *)text
{
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:COLOR_MAIN_DARK forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = FONT_MAIN;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 0.5f;
    return button;
}

#pragma mark - Editing
- (BOOL) editing
{
    return self.tableView.editing;
}

- (void) setEditing:(BOOL)editing
{
    self.tableView.editing = editing;
    
    //切换显示内容
    NSInteger goodsCount = [self.tableData count];
    //获取所有单元格(indexPathsForVisibleRows只含有可见行，不含有滚动后可见的)
    for (int section = 0; section < goodsCount; section++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        [self toggleRowAtIndexPath:indexPath editing:editing];
    }
}

//切换编辑和普通状态
- (void) toggleRowAtIndexPath: (NSIndexPath *) indexPath editing: (BOOL) editing
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (!cell) return;
    
    if (editing) {
        [cell viewWithTag:201].hidden = YES;
        [cell viewWithTag:202].hidden = YES;
        [cell viewWithTag:301].hidden = NO;
        [cell viewWithTag:302].hidden = NO;
        [cell viewWithTag:303].hidden = NO;
    } else {
        [cell viewWithTag:201].hidden = NO;
        [cell viewWithTag:202].hidden = NO;
        [cell viewWithTag:301].hidden = YES;
        [cell viewWithTag:302].hidden = YES;
        [cell viewWithTag:303].hidden = YES;
    }
    
    //更新视图布局
    UIView *nameLabel = [cell viewWithTag:101];
    UIView *specLabel = [cell viewWithTag:102];
    CGFloat paddingLeft = editing ? 40 : 20;
    
    UIView *superview = cell;
    [nameLabel mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(paddingLeft);
    }];
    [specLabel mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(paddingLeft);
    }];
}

#pragma mark - TableView
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section >= [self.tableData count] - 1 ? HEIGHT_TABLE_MARGIN_ZERO : HEIGHT_TABLE_MARGIN_DEFAULT;
}

#pragma mark - Action
- (void) actionEditNumber: (UIButton *) sender plus: (BOOL) plus
{
    UITableViewCell *cell = (UITableViewCell *) sender.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) return;
    
    NSDictionary *cellData = [self tableView:self.tableView cellDataForRowAtIndexPath:indexPath];
    GoodsEntity *goods = [cellData objectForKey:@"data"];
    NSInteger number = [goods.number integerValue];
    
    //操作：加或减
    if (plus) {
        number++;
    } else {
        number--;
        if (number < 1) number = 1;
    }
    
    goods.number = [NSNumber numberWithInteger:number];
    
    //更新视图
    UILabel *numberLabel = (UILabel *) [cell viewWithTag:202];
    numberLabel.text = [NSString stringWithFormat:@"x%@", goods.number];
    
    UIButton *numberButton = (UIButton *) [cell viewWithTag:302];
    [numberButton setTitle:[NSString stringWithFormat:@"%@", goods.number] forState:UIControlStateNormal];
}

- (void) actionPlusNumber: (UIButton *) sender
{
    [self actionEditNumber:sender plus:YES];
}

- (void) actionMinusNumber: (UIButton *) sender
{
    [self actionEditNumber:sender plus:NO];
}

@end
