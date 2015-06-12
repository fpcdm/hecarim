//
//  BaseTableView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseTableView.h"

//默认cell标识
static NSString *cellReuseIdentifier = @"cell";

@interface BaseTableView ()

@end

@implementation BaseTableView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    /****************************************************************
     tableData数据格式介绍：
     默认字段：id,index,type,action,text,image,height,data
     type取值: normal|action|custom
     自定义字段：可自定义字段，加入更多默认功能
     优化：可以将NSDictionry改为TableCellEntity之类的数据固定格式，从而简化访问
     
     self.tableData = [[NSMutableArray alloc] initWithObjects:
        @[
            @{@"id" : @"info", @"index" : @0, @"type" : @"custom", @"action": @"", @"image": @"", @"text" : @"TODO", @"data" : @"", @"height": @0},
        ],
        @[
            @{@"id" : @"address", @"index" : @1, @"type" : @"action", @"action": @"actionAddress", @"image": @"", @"text" : @"管理我的地址", @"data" : @"", @"height": @0},
            @{@"id" : @"profile", @"index" : @2, @"type" : @"action", @"action": @"actionProfile:", @"image": @"", @"text" : @"个人资料", @"data" : @"", @"height": @0},
            @{@"id" : @"safety", @"index" : @3, @"type" : @"action", @"action": @"actionSafety:indexPath:", @"image": @"", @"text" : @"账户与安全", @"data" : @"", @"height": @0},
        ],
        @[
            @{@"id" : @"feedback", @"index" : @4, @"type" : @"action", @"action": @"actionFeedback:", @"image": @"", @"text" : @"意见反馈", @"data" : @"", @"height": @0},
            @{@"id" : @"contact", @"index" : @5, @"type" : @"custom", @"action": @"actionContact", @"image": @"", @"text" : @"客服电话", @"data" : @"400-820-5555", @"height": @0},
        ],
        nil];
     ****************************************************************/
    
    if (self.tableData == nil) {
        self.tableData = [[NSMutableArray alloc] initWithObjects:nil];
    }
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    [self addSubview:self.tableView];
    
    UIView *superview = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //空白tableFooterView
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.frame = CGRectMake(0, 0, 0, 0);
    self.tableView.tableFooterView = tableFooterView;
    
    return self;
}

#pragma mark - reloadData
- (void) reloadData
{
    NSLog(@"dddd:");
    return;
    
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionData = [self.tableData objectAtIndex:section];
    if (sectionData == nil) {
        return 0;
    } else {
        return [(NSArray *)sectionData count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    
    NSNumber *height = [cellData objectForKey:@"height"];
    if (height != nil && [height floatValue] > 0.0f) {
        return [height floatValue];
    } else {
        return HEIGHT_TABLE_CELL_DEFAULT;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT_TABLE_SECTION_HEADER_DEFAULT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return HEIGHT_TABLE_SECTION_FOOTER_DEFAULT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    
    NSString *type = [cellData objectForKey:@"type"];
    //normal
    if ([@"normal" isEqualToString:type]) {
        cell.textLabel.text = [cellData objectForKey:@"text"];
        if (FONT_TABLE_CELL_DEFAULT > 0) {
            cell.textLabel.font = [UIFont systemFontOfSize:FONT_TABLE_CELL_DEFAULT];
        }
        
        NSString *image = [cellData objectForKeyedSubscript:@"image"];
        if (image != nil && [image length] > 0) {
            cell.imageView.image = [UIImage imageNamed:image];
        }
        
        return cell;
        //action
    } else if ([@"action" isEqualToString:type]) {
        cell.textLabel.text = [cellData objectForKey:@"text"];
        if (FONT_TABLE_CELL_DEFAULT > 0) {
            cell.textLabel.font = [UIFont systemFontOfSize:FONT_TABLE_CELL_DEFAULT];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSString *image = [cellData objectForKeyedSubscript:@"image"];
        if (image != nil && [image length] > 0) {
            cell.imageView.image = [UIImage imageNamed:image];
        }
        
        return cell;
        //custom
    } else {
        //默认设置了值保留原视图，原始图基础上自定义，没设置则直接忽略，下同
        NSString *text = [cellData objectForKey:@"text"];
        if (text != nil && [text length] > 0) {
            cell.textLabel.text = [cellData objectForKey:@"text"];
            if (FONT_TABLE_CELL_DEFAULT > 0) {
                cell.textLabel.font = [UIFont systemFontOfSize:FONT_TABLE_CELL_DEFAULT];
            }
        }
        
        NSString *image = [cellData objectForKeyedSubscript:@"image"];
        if (image != nil && [image length] > 0) {
            cell.imageView.image = [UIImage imageNamed:image];
        }
        
        //自定义视图方法，重写即可，可以忽略cell完全重写，默认直接返回cell
        cell = [self tableView:tableView customCellForRowAtIndexPath:indexPath withCell:cell];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    NSString *action = [cellData objectForKey:@"action"];
    if (action == nil || [action length] < 1) {
        return;
    }
    
    //分析SEL参数个数
    NSArray *components = [action componentsSeparatedByString:@":"];
    NSUInteger paramCount = (components != nil) ? [components count] : 0;
    if (paramCount < 1) {
        return;
    }
    
    //根据参数个数传参数，最多支持两个参数
    SEL selector = NSSelectorFromString(action);
    if (paramCount == 1) {
        [self performSelector:selector];
    } else if (paramCount == 2) {
        [self performSelector:selector withObject:cellData];
    } else {
        [self performSelector:selector withObject:tableView withObject:indexPath];
    }
}

- (NSDictionary *)tableView:(UITableView *)tableView cellDataForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionData = [self.tableData objectAtIndex:indexPath.section];
    NSDictionary *cellData = [sectionData objectAtIndex:indexPath.row];
    return cellData;
}

- (UITableViewCell *)tableView:(UITableView *)tableView customCellForRowAtIndexPath:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
{
    return cell;
}

@end
