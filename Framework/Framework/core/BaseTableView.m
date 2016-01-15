//
//  BaseTableView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "BaseTableView.h"

@interface BaseTableView ()

@end

@implementation BaseTableView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    /****************************************************************
     tableData数据格式介绍：
     默认字段：id,index,type,view,action,text,image,height,data,style,detail,font,detailFont
     type取值: normal|action|custom，默认normal
     style取值：default|subtitle|value1|value2，默认default
     action说明：参数个数为1时，参数为cellData字典；为2时参数为tableView和indexPath
     view说明：定义了view且type为custom时，使用该方法的返回值作为视图；参数个数为1时为cell,为2时为cell和cellData
     customCell说明：type为custom且未定义view或view参数不满足需求时，使用此方式
     自定义字段：可自定义字段，加入更多默认功能
     备注：没有值的字段可不配置，会自动忽略
     优化：可以将NSDictionry改为TableCellEntity之类的数据固定格式，从而简化访问
     
     self.tableData = [[NSMutableArray alloc] initWithObjects:
        @[
            @{@"id" : @"info", @"index" : @0, @"type" : @"custom", @"view": @"", @"action": @"", @"image": @"", @"text" : @"TODO", @"data" : @"", @"height": @0, @font: @14, @"style": @"default", @"detail": @"文字"},
        ],
        @[
            @{@"id" : @"address", @"index" : @1, @"type" : @"action", @"action": @"actionAddress", @"image": @"", @"text" : @"管理我的地址", @"data" : @"", @"height": @0},
            @{@"id" : @"profile", @"index" : @2, @"type" : @"action", @"action": @"actionProfile:", @"image": @"", @"text" : @"个人资料", @"data" : @"", @"height": @0, @"style":@"value1", @"detail":@"你好"},
            @{@"id" : @"safety", @"index" : @3, @"type" : @"action", @"action": @"actionSafety:indexPath:", @"image": @"", @"text" : @"账户与安全", @"data" : @"", @"height": @0},
        ],
        @[
            @{@"id" : @"feedback", @"index" : @4, @"type" : @"action", @"action": @"actionFeedback:", @"image": @"", @"text" : @"意见反馈", @"data" : @"", @"height": @0},
            @{@"id" : @"contact", @"index" : @5, @"type" : @"custom", @"action": @"actionContact", @"image": @"", @"text" : @"客服电话", @"data" : @"400-820-5555", @"height": @0},
        ],
        nil];
     ****************************************************************/
    
    if (self.tableData == nil) {
        self.tableData = [NSMutableArray array];
    }
    
    //默认TableView
    self.tableView = [self loadTableView];
    if (self.tableView == nil) {
        UITableViewStyle tableStyle = IS_IOS7_PLUS ? UITableViewStyleGrouped : UITableViewStylePlain;
        self.tableView = [[UITableView alloc] initWithFrame:[self bounds] style:tableStyle];
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_REUSE_IDENTIFIER_DEFAULT];
        self.tableView.backgroundView = nil;
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self addSubview:self.tableView];
    
    UIView *superview = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(superview).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //空白tableFooterView
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.frame = CGRectMake(0, 0, 0, 0);
    self.tableView.tableFooterView = tableFooterView;
    
    //自定义表格视图钩子，子类可以实现(不会影响别的子类)，也可以利用类分类实现(会影响别的子类)
    if ([self respondsToSelector:@selector(customTableView)]) {
        [self performSelector:@selector(customTableView)];
    }
    
    return self;
}

- (UITableView *)loadTableView
{
    return nil;
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

- (UITableViewCell *)tableView:(UITableView *)tableView loadReuseTableViewCell:(NSIndexPath *)indexPath
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //默认TableViewCell
    UITableViewCell *cell = [self tableView:tableView loadReuseTableViewCell:indexPath];
    //单元格数据
    NSDictionary *cellData = [self tableView:tableView cellDataForRowAtIndexPath:indexPath];
    
    //初始化默认Cell
    if (cell == nil) {
        //获取样式
        NSString *style = [cellData objectForKey:@"style"];
        NSUInteger cellStyle = UITableViewCellStyleDefault;
        if ([@"subtitle" isEqualToString:style]) {
            cellStyle = UITableViewCellStyleSubtitle;
        } else if ([@"value1" isEqualToString:style]) {
            cellStyle = UITableViewCellStyleValue1;
        } else if ([@"value2" isEqualToString:style]) {
            cellStyle = UITableViewCellStyleValue2;
        }
        
        //cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER_DEFAULT forIndexPath:indexPath];
        cell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:CELL_REUSE_IDENTIFIER_DEFAULT];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //全局配置
    NSString *text = [cellData objectForKey:@"text"];
    if (text != nil && [text length] > 0) {
        cell.textLabel.text = [cellData objectForKey:@"text"];
        NSNumber *font = [cellData objectForKey:@"font"];
        if (font != nil && [font floatValue] > 0.0f) {
            cell.textLabel.font = [UIFont systemFontOfSize:[font floatValue]];
        } else if (FONT_TABLE_CELL_DEFAULT > 0) {
            cell.textLabel.font = [UIFont systemFontOfSize:FONT_TABLE_CELL_DEFAULT];
        }
    }
    NSString *image = [cellData objectForKeyedSubscript:@"image"];
    if (image != nil && [image length] > 0) {
        cell.imageView.image = [UIImage imageNamed:image];
    }
    NSString *detail = [cellData objectForKey:@"detail"];
    if (detail != nil && [detail length] > 0) {
        cell.detailTextLabel.text = detail;
        NSNumber *detailFont = [cellData objectForKey:@"detailFont"];
        if (detailFont != nil && [detailFont floatValue] > 0.0f) {
            cell.detailTextLabel.font = [UIFont systemFontOfSize:[detailFont floatValue]];
        } else if (FONT_TABLE_CELL_DETAIL_DEFAULT > 0) {
            cell.detailTextLabel.font = [UIFont systemFontOfSize:FONT_TABLE_CELL_DETAIL_DEFAULT];
        }
    }
    
    NSString *type = [cellData objectForKey:@"type"];
    //normal
    if ([@"normal" isEqualToString:type]) {
        return cell;
    //action
    } else if ([@"action" isEqualToString:type]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    //custom
    } else {
        //默认设置了值保留原视图，原始图基础上自定义，没设置则直接忽略，下同
        //自定义视图钩子，仅支持最多两个参数
        NSString *view = [cellData objectForKey:@"view"];
        if (view != nil && [view length] > 0) {
            //分析SEL参数个数
            NSArray *components = [view componentsSeparatedByString:@":"];
            NSUInteger paramCount = (components != nil) ? [components count] : 0;
            if (paramCount < 1) {
                return cell;
            }
            
            //根据参数个数传参数，最多支持两个参数
            SEL selector = NSSelectorFromString(view);
            if (paramCount == 1) {
                [self performSelector:selector];
            } else if (paramCount == 2) {
                [self performSelector:selector withObject:cell];
            } else {
                [self performSelector:selector withObject:cell withObject:cellData];
            }
        //自定义视图方法，重写即可，可以忽略cell完全重写，默认直接返回cell
        } else {
            cell = [self tableView:tableView customCellForRowAtIndexPath:indexPath withCell:cell];
        }
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
