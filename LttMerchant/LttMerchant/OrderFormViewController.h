//
//  OrderFormViewController.h
//  LttMerchant
//
//  Created by wuyong on 15/4/30.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface OrderFormViewController : AppViewController

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *brandSegment;

@property (weak, nonatomic) IBOutlet UISegmentedControl *modelSegment;

@property (weak, nonatomic) IBOutlet UILabel *specLabel1;

@property (weak, nonatomic) IBOutlet UISegmentedControl *specSegment1;

@property (weak, nonatomic) IBOutlet UILabel *specLabel2;

@property (weak, nonatomic) IBOutlet UISegmentedControl *specSegment2;

@property (weak, nonatomic) IBOutlet UILabel *specLabel3;

@property (weak, nonatomic) IBOutlet UISegmentedControl *specSegment3;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UITextField *numberField;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *modelEmptyLabel;

@property (weak, nonatomic) IBOutlet UILabel *specEmptyLabel;

@property (weak, nonatomic) IBOutlet UITextField *mobileServiceName;

@property (weak, nonatomic) IBOutlet UITextField *mobileServicePrice;

@property (weak, nonatomic) IBOutlet UITextField *computerServiceName;

@property (weak, nonatomic) IBOutlet UITextField *computerServicePrice;

- (IBAction)orderSubmitAction:(id)sender;

@property (nonatomic, retain) NSNumber *intentionId;

@property (nonatomic, retain) NSString *orderNo;

@end
