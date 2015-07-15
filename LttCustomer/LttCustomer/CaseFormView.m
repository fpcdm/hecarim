//
//  CaseFormView.m
//  LttCustomer
//
//  Created by wuyong on 15/7/14.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "CaseFormView.h"

@implementation CaseFormView

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"address", @"type" : @"custom", @"view": @"cellAddress:", @"action": @"actionAddress", @"height":@150},
                        ],
                      @[
                        @{@"id" : @"remark", @"type" : @"custom", @"view": @"cellRemark:"},
                        ],
                      nil];
    
    //呼叫按钮
    UIButton *button = [AppUIUtil makeButton:@"呼叫"];
    [button addTarget:self action:@selector(actionSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UIView *superview = self;
    int padding = 10;
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.tableView.tableFooterView.mas_bottom);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo([NSNumber numberWithInt:HEIGHT_MIDDLE_BUTTON]);
    }];
    
    return self;
}

#pragma mark - RenderData
- (void) renderData
{
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? HEIGHT_TABLE_MARGIN_DEFAULT : HEIGHT_TABLE_MARGIN_ZERO;
}

- (UITableViewCell *) cellAddress: (UITableViewCell *) cell
{
    return cell;
}

- (UITableViewCell *) cellRemark: (UITableViewCell *) cell
{
    return cell;
}

#pragma mark - Action
- (void) actionAddress
{
    [self.delegate actionAddress];
}

- (void) actionSubmit
{
    [self.delegate actionSubmit:@""];
}

@end
