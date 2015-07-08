//
//  HomeView.m
//  LttCustomer
//
//  Created by wuyong on 15/6/10.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "HomeView.h"

@implementation HomeView
{
    UILabel *addressLabel;
    UILabel *infoLabel;
    
    UIView *topView;
    UIView *middleView;
    UIView *bottomView;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    //背景颜色
    self.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG];
    
    //顶部视图
    [self topView];
    
    //底部视图
    [self bottomView];
    
    //中部视图
    [self middleView];
    
    return self;
}

- (void) topView
{
    //顶部视图
    topView = [[UIView alloc] init];
    topView.layer.backgroundColor = [UIColor colorWithHexString:COLOR_HIGHLIGHTED_BG].CGColor;
    [self addSubview:topView];
    
    UIView *superview = self;
    [topView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.height.equalTo(superview.mas_height).multipliedBy(0.35);
    }];
    
    //地址视图
    UIView *addressView = [[UIView alloc] init];
    addressView.layer.cornerRadius = 3.0f;
    addressView.layer.backgroundColor = [UIColor colorWithHexString:@"CE2D2F"].CGColor;
    [topView addSubview:addressView];
    
    superview = topView;
    [addressView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top).offset(15);
        make.left.equalTo(superview.mas_left).offset(30);
        make.right.equalTo(superview.mas_right).offset(-30);
        
        make.height.equalTo(@60);
    }];
    
    //地址标签
    addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"正在定位";
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.font = [UIFont boldSystemFontOfSize:20];
    [addressView addSubview:addressLabel];
    
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(addressView.mas_top).offset(5);
        make.left.equalTo(addressView.mas_left).offset(10);
    }];
    
    //信息标签
    infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.font = [UIFont boldSystemFontOfSize:SIZE_MIDDLE_TEXT];
    [addressView addSubview:infoLabel];
    
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(addressLabel.mas_bottom).offset(5);
        make.left.equalTo(addressView.mas_left).offset(10);
    }];
    
    //标记图片
    UIImageView *pointView = [[UIImageView alloc] init];
    pointView.image = [UIImage imageNamed:@"point"];
    pointView.contentMode = UIViewContentModeScaleAspectFit;
    pointView.userInteractionEnabled = YES;
    //点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionGps)];
    [pointView addGestureRecognizer:singleTap];
    [addressView addSubview:pointView];
    
    [pointView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(addressView.mas_right).offset(-8);
        make.centerY.equalTo(addressView.mas_centerY);
        
        make.width.equalTo(@18);
        make.height.equalTo(@30);
    }];
    
    //开始视图
    UIView *beginView = [[UIView alloc] init];
    beginView.layer.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_BG].CGColor;
    beginView.layer.cornerRadius = 3.0f;
    [topView addSubview:beginView];
    
    [beginView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left).offset(20);
        make.bottom.equalTo(superview.mas_bottom).offset(3.0f);
        
        make.width.equalTo(@95);
        make.height.equalTo(@33);
    }];
    
    //开始文字
    UILabel *beginLabel = [[UILabel alloc] init];
    beginLabel.text = @"我们开始吧!";
    beginLabel.font = [UIFont boldSystemFontOfSize:SIZE_MIDDLE_TEXT];
    beginLabel.textAlignment = NSTextAlignmentCenter;
    beginLabel.textColor = [UIColor colorWithHexString:COLOR_MAIN_TEXT_HIGHLIGHTED];
    [beginView addSubview:beginLabel];
    
    [beginLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(beginView.mas_top);
        make.bottom.equalTo(beginView.mas_bottom);
        make.left.equalTo(beginView.mas_left);
        make.right.equalTo(beginView.mas_right);
    }];
}

//中部视图
- (void)middleView
{
    middleView = [UIView new];
    [self addSubview:middleView];
    
    UIView *superview = self;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    //左间距定义
    int leftMargin = 20;
    
    //买手机视图
    UIView *mobileView = [UIView new];
    [middleView addSubview:mobileView];
    
    superview = middleView;
    [mobileView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(superview.mas_top);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.height.equalTo(superview.mas_height).multipliedBy(0.48);
    }];
    
    //即时响应
    UILabel *mobileDesc = [[UILabel alloc] init];
    mobileDesc.text = @"即时响应，两小时送货上门";
    mobileDesc.textColor = [UIColor grayColor];
    mobileDesc.font = [UIFont boldSystemFontOfSize:18];
    [mobileView addSubview:mobileDesc];
    
    [mobileDesc mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(mobileView.mas_centerY).offset(-5);
        make.left.equalTo(mobileView.mas_left).offset(leftMargin);
    }];
    
    //买手机标题
    UILabel *mobileTitle = [[UILabel alloc] init];
    mobileTitle.text = @"买手机";
    mobileTitle.textColor = [UIColor colorWithHexString:@"585858"];
    mobileTitle.font = [UIFont boldSystemFontOfSize:26];
    [mobileView addSubview:mobileTitle];
    
    [mobileTitle mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(mobileDesc.mas_top).offset(-5);
        make.left.equalTo(mobileView.mas_left).offset(leftMargin);
    }];
    
    //自己选
    UIButton *chooseButton = [[UIButton alloc] init];
    chooseButton.layer.backgroundColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    chooseButton.layer.cornerRadius = 3.0f;
    chooseButton.titleLabel.text = nil;
    //[chooseButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [mobileView addSubview:chooseButton];
    
    [chooseButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(mobileView.mas_right).offset(-12);
        make.top.equalTo(mobileView.mas_centerY);
        
        make.height.equalTo(IS_IPHONE5_PLUS ? @60 : @50);
        make.width.equalTo(@120);
    }];
    
    UILabel *chooseLabel = [[UILabel alloc] init];
    chooseLabel.text = @"自己选";
    chooseLabel.textColor = [UIColor colorWithHexString:@"585858"];
    chooseLabel.font = [UIFont boldSystemFontOfSize:20];
    [chooseButton addSubview:chooseLabel];
    
    [chooseLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(chooseButton.mas_top).offset(7);
        make.left.equalTo(chooseButton.mas_left).offset(5);
    }];
    
    UILabel *chooseDescLabel = [[UILabel alloc] init];
    chooseDescLabel.text = @"我知道要买什么手机";
    chooseDescLabel.textColor = [UIColor grayColor];
    chooseDescLabel.font = [UIFont boldSystemFontOfSize:12];
    [chooseButton addSubview:chooseDescLabel];
    
    [chooseDescLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(chooseButton.mas_bottom).offset(-7);
        make.left.equalTo(chooseButton.mas_left).offset(5);
    }];
    
    //呼叫客服
    UIButton *customerButton = [[UIButton alloc] init];
    customerButton.layer.backgroundColor = [UIColor colorWithHexString:COLOR_HIGHLIGHTED_BG].CGColor;
    customerButton.layer.cornerRadius = 3.0f;
    customerButton.titleLabel.text = nil;
    customerButton.tag = LTT_TYPE_MOBILE;
    [customerButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [mobileView addSubview:customerButton];
    
    [customerButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(mobileView.mas_left).offset(leftMargin);
        make.right.equalTo(chooseButton.mas_left).offset(-12);
        make.top.equalTo(chooseButton.mas_top);
        
        make.height.equalTo(chooseButton.mas_height);
    }];
    
    UILabel *customerLabel = [[UILabel alloc] init];
    customerLabel.text = @"呼叫客服";
    customerLabel.textColor = [UIColor colorWithHexString:COLOR_MAIN_BUTTON];
    customerLabel.font = [UIFont boldSystemFontOfSize:20];
    [customerButton addSubview:customerLabel];
    
    [customerLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(customerButton.mas_top).offset(7);
        make.left.equalTo(customerButton.mas_left).offset(5);
    }];
    
    UILabel *customerDescLabel = [[UILabel alloc] init];
    customerDescLabel.text = @"我不是很懂，找客服帮我选";
    customerDescLabel.textColor = [UIColor colorWithHexString:COLOR_MAIN_BUTTON];
    customerDescLabel.font = [UIFont boldSystemFontOfSize:12];
    [customerButton addSubview:customerDescLabel];
    
    [customerDescLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(customerButton.mas_bottom).offset(-7);
        make.left.equalTo(customerButton.mas_left).offset(5);
    }];
    
    //间隔
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = [UIColor colorWithHexString:@"979797"];
    [mobileView addSubview:sepView];
    
    [sepView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(mobileView.mas_bottom);
        make.left.equalTo(mobileView.mas_left).offset(leftMargin);
        make.right.equalTo(mobileView.mas_right);
        
        make.height.equalTo(@1.5);
    }];
    
    //手机上门
    UIView *mobileDoorView = [[UIView alloc] init];
    [middleView addSubview:mobileDoorView];
    
    [mobileDoorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(mobileView.mas_bottom);
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        
        make.height.equalTo(superview.mas_height).multipliedBy(0.26);
    }];
    
    //手机上门维修
    UIButton *mobileDoorButton = [[UIButton alloc] init];
    [mobileDoorButton setTitle:@"手机上门维修" forState:UIControlStateNormal];
    [mobileDoorButton setTitleColor:[UIColor colorWithHexString:@"585858"] forState:UIControlStateNormal];
    mobileDoorButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    mobileDoorButton.tag = LTT_TYPE_MOBILEDOOR;
    [mobileDoorButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [mobileDoorView addSubview:mobileDoorButton];
    
    [mobileDoorButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(mobileDoorView.mas_centerY);
        make.left.equalTo(mobileDoorView.mas_left).offset(leftMargin);
        
        make.height.equalTo(@20);
    }];
    
    //手机上门维修介绍
    UILabel *mobileDoorDesc = [[UILabel alloc] init];
    mobileDoorDesc.text = @"手机维修，贴膜，系统清理，软件安装...";
    mobileDoorDesc.textColor = [UIColor grayColor];
    mobileDoorDesc.font = [UIFont boldSystemFontOfSize:14];
    [mobileDoorView addSubview:mobileDoorDesc];
    
    [mobileDoorDesc mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(mobileDoorView.mas_centerY).offset(5);
        make.left.equalTo(mobileDoorView.mas_left).offset(leftMargin);
    }];
    
    //间隔
    UIView *doorSepView = [[UIView alloc] init];
    doorSepView.backgroundColor = [UIColor colorWithHexString:@"979797"];
    [mobileDoorView addSubview:doorSepView];
    
    [doorSepView mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(mobileDoorView.mas_bottom);
        make.left.equalTo(mobileDoorView.mas_left).offset(leftMargin);
        make.right.equalTo(mobileDoorView.mas_right);
        
        make.height.equalTo(@1.5);
    }];
    
    //电脑上门
    UIView *computerDoorView = [UIView new];
    [middleView addSubview:computerDoorView];
    
    [computerDoorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(mobileDoorView.mas_bottom);
        
        make.height.equalTo(superview.mas_height).multipliedBy(0.26);
    }];
    
    //电脑上门维修
    UIButton *computerDoorButton = [[UIButton alloc] init];
    [computerDoorButton setTitle:@"电脑上门维修" forState:UIControlStateNormal];
    [computerDoorButton setTitleColor:[UIColor colorWithHexString:@"585858"] forState:UIControlStateNormal];
    computerDoorButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    computerDoorButton.tag = LTT_TYPE_COMPUTERDOOR;
    [computerDoorButton addTarget:self action:@selector(actionCase:) forControlEvents:UIControlEventTouchUpInside];
    [computerDoorView addSubview:computerDoorButton];
    
    [computerDoorButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(computerDoorView.mas_centerY);
        make.left.equalTo(computerDoorView.mas_left).offset(leftMargin);
        
        make.height.equalTo(@20);
    }];
    
    //电脑上门维修介绍
    UILabel *computerDoorDesc = [[UILabel alloc] init];
    computerDoorDesc.text = @"电脑维修，系统清理，软件安装...";
    computerDoorDesc.textColor = [UIColor grayColor];
    computerDoorDesc.font = [UIFont boldSystemFontOfSize:14];
    [computerDoorView addSubview:computerDoorDesc];
    
    [computerDoorDesc mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(computerDoorView.mas_centerY).offset(5);
        make.left.equalTo(computerDoorView.mas_left).offset(leftMargin);
    }];
}

//底部视图
- (void)bottomView
{
    bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor colorWithHexString:COLOR_MAIN_BG];
    [self addSubview:bottomView];
    
    UIView *superview = self;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(superview.mas_left);
        make.right.equalTo(superview.mas_right);
        make.bottom.equalTo(superview.mas_bottom);
        
        make.height.equalTo(@35);
    }];
    
    //文本框
    UILabel *label = [[UILabel alloc] init];
    label.text = @"我们的信使将实时响应您的需求";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    [bottomView addSubview:label];
    
    superview = bottomView;
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(superview.mas_centerY);
        make.left.equalTo(superview.mas_left).offset(50);
    }];
    
    //图标
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"top"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bottomView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(superview.mas_right).offset(-20);
        make.centerY.equalTo(superview.mas_centerY);
        
        make.width.equalTo(@17);
    }];
}

#pragma mark - RenderData
- (void) renderData
{
    NSString *address = [self getData:@"address"];
    addressLabel.text = address;
    
    NSNumber *count = [self getData:@"count"];
    if (!count || [@-1 isEqualToNumber:count]) {
        infoLabel.text = @"";
    } else {
        infoLabel.text = [NSString stringWithFormat:@"有%@个信使等待为您服务", count];
    }
}

- (void) actionCase: (UIButton *)sender
{
    NSNumber *type = [NSNumber numberWithInteger:sender.tag];
    [self.delegate actionCase:type];
}

- (void)actionGps
{
    [self.delegate actionGps];
}

@end
