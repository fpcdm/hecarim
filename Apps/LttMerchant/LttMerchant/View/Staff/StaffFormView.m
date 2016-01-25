//
//  StaffFormView.m
//  LttMerchant
//
//  Created by 杨海锋 on 15/12/29.
//  Copyright © 2015年 Gilbert. All rights reserved.
//

#import "StaffFormView.h"
#import "TPKeyboardAvoidingScrollView.h"

@implementation StaffFormView
{
    UITextField *noField;
    UITextField *nameField;
    UITextField *nicknameField;
    UITextField *mobileField;
    
    UIView *superView;
    int padding;
}

- (UIScrollView *)loadScrollView
{
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc] init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = NO;
    return scrollView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    superView = self.contentView;
    padding = 10;
    
    //编号
    noField = [[UITextField alloc] init];
    UIView *noView = [self inputView:self labelName:@"编号" field:noField topButtom:YES];
    
    //姓名
    nameField = [[UITextField alloc] init];
    UIView *nameView = [self inputView:noView labelName:@"姓名" field:nameField topButtom:NO];
    
    //昵称
    nicknameField = [[UITextField alloc] init];
    UIView *nicknameView = [self inputView:nameView labelName:@"昵称" field:nicknameField topButtom:NO];
    
    //电话
    mobileField = [[UITextField alloc] init];
    mobileField.keyboardType = UIKeyboardTypeNumberPad;
    UIView *mobileView = [self inputView:nicknameView labelName:@"电话" field:mobileField topButtom:NO];
    
    UIButton *button = [AppUIUtil makeButton:@"保存"];
    [button addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mobileView.mas_bottom).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo([NSNumber numberWithFloat:HEIGHT_MAIN_BUTTON]);
    }];
    self.contentSize = CGSizeMake(SCREEN_WIDTH, 265);
    return self;
}

- (void)display
{
    StaffEntity *staff = [self fetch:@"staff"];
    noField.text = staff.no;
    nameField.text = staff.name;
    nicknameField.text = staff.nickname;
    mobileField.text = staff.mobile;
}

- (void)actionSave
{
    StaffEntity *staffEntity = [[StaffEntity alloc] init];
    staffEntity.no = noField.text;
    staffEntity.name = nameField.text;
    staffEntity.nickname = nicknameField.text;
    staffEntity.mobile = mobileField.text;
    [self.delegate actionSave:staffEntity];
}

- (UIView *)inputView:(UIView *)inputView labelName:(NSString *)labelName field:(UITextField *)field topButtom:(BOOL)type
{
    padding = 10;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = COLOR_MAIN_WHITE;
    bgView.layer.borderWidth = 0.5f;
    bgView.layer.borderColor = CGCOLOR_MAIN_BORDER;
    bgView.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (type) {
            make.top.equalTo(superView.mas_top).offset(padding);
        } else {
            make.top.equalTo(inputView.mas_bottom).offset(padding);
        }
        make.left.equalTo(superView.mas_left).offset(padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
        make.height.equalTo(@40);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = labelName;
    tipLabel.font = FONT_MAIN;
    [bgView addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.equalTo(bgView.mas_left).offset(10);
        make.width.equalTo(@40);
    }];
    
    field.font = FONT_MAIN;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bgView addSubview:field];
    
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.left.equalTo(tipLabel.mas_right).offset(5);
        make.right.equalTo(bgView.mas_right);
        make.height.equalTo(@30);
    }];
    return bgView;
}


@end
