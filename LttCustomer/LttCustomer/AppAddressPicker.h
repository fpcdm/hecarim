//
//  AreaActionSheetPickerPickerDelegate.h
//  ActionSheetPicker
//
//  Created by Xu Wenfeng on 14-6-3.
//
//

#import <Foundation/Foundation.h>
#import "ActionSheetPicker.h"
#import "AddressEntity.h"

@protocol AppAddressPickerDelegate <NSObject>

- (void) pickFinish: (AddressEntity *) address;

@end

@interface AppAddressPicker : NSObject<ActionSheetCustomPickerDelegate>

@property (nonatomic, strong) AddressEntity *address;

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *areas;

@property (retain, nonatomic) id<AppAddressPickerDelegate> delegate;

//加载初始数据
- (void)loadData:(void (^)()) callback;

@end
