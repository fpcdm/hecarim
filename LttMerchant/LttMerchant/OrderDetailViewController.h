//
//  OrderDetailViewController.h
//  LttMerchant
//
//  Created by wuyong on 15/4/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"

@interface OrderDetailViewController : AppViewController

@property (weak, nonatomic) IBOutlet UIView *qrcodeView;

@property (weak, nonatomic) IBOutlet UIView *finishView;

@property (weak, nonatomic) IBOutlet UITextView *goodsTextView;

@property (weak, nonatomic) IBOutlet UIButton *employeeButton;

@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *finishTextLabel;

- (IBAction)changeOrderAction:(id)sender;

- (IBAction)qrcodeScanAction:(id)sender;

@property (nonatomic, retain) NSString *orderNo;

@end
