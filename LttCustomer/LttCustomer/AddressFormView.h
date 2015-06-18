//
//  AddressFormView.h
//  LttCustomer
//
//  Created by wuyong on 15/6/16.
//  Copyright (c) 2015年 Gilbert. All rights reserved.
//

#import "AppTableView.h"

@protocol AddressFormViewDelegate <NSObject>

@required
- (void)actionArea;
- (void)actionStreet;

@end

@interface AddressFormView : AppTableView

@property (retain, nonatomic) id<AddressFormViewDelegate> delegate;

@property (retain, nonatomic) UITextField *nameField;

@property (retain, nonatomic) UITextField *mobileField;

@property (retain, nonatomic) UITextView *addressView;

@end
