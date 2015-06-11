//
//  ApplyDetailViewController.h
//  LttMerchant
//
//  Created by wuyong on 15/4/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"

@interface ApplyDetailViewController : AppViewController

@property (weak, nonatomic) IBOutlet UILabel *brandLabel;

@property (weak, nonatomic) IBOutlet UILabel *modelLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UIButton *employeeButton;

- (IBAction)cancelSubmitAction:(id)sender;

- (IBAction)createSubmitAction:(id)sender;

@property (nonatomic, retain) NSNumber *intentionId;

@end
