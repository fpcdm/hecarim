//
//  AboutView.m
//  LttAutoFinance
//
//  Created by wuyong on 15/6/29.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AboutView.h"

@interface AboutView ()

@end

@implementation AboutView
{
    UITextView *textView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //表格单元格
    self.tableData = [[NSMutableArray alloc] initWithObjects:
                      @[
                        @{@"id" : @"score", @"type" : @"action", @"action": @"actionScore", @"text" : @"去App Store评分"},
                        ],
                      nil];
    
    //头视图
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 170);
    headerView.backgroundColor = COLOR_MAIN_BG;
    self.tableView.tableHeaderView = headerView;
    
    //介绍
    textView = [[UITextView alloc] init];
    textView.text = @"关于手机两条腿";
    textView.editable = NO;
    textView.font = FONT_MAIN;
    textView.layer.backgroundColor = CGCOLOR_MAIN_WHITE;
    textView.layer.cornerRadius = 3.0;
    textView.layer.borderColor = [UIColor colorWithHexString:@"D8D8D8"].CGColor;
    textView.layer.borderWidth = 0.5f;
    [headerView addSubview:textView];
    
    UIView *superview = headerView;
    int padding = 10;
    [textView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(padding);
        make.left.equalTo(superview.mas_left).offset(padding);
        make.right.equalTo(superview.mas_right).offset(-padding);
        
        make.height.equalTo(@150);
    }];
    
    return self;
}

#pragma mark - Action
- (void)actionScore
{
    [self.delegate actionScore];
}

@end
