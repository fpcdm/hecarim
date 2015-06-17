//
//  AreaActionSheetPickerPickerDelegate.h
//  ActionSheetPicker
//
//  Created by Xu Wenfeng on 14-6-3.
//
//

#import <Foundation/Foundation.h>
#import "ActionSheetPicker.h"

@protocol AppAddressPickerDelegate <NSObject>

//@todo: 增加其他参数
- (void) pickFinish: (NSString *) province city:(NSString *) city area:(NSString *)area;

@end

@interface AppAddressPicker : NSObject<ActionSheetCustomPickerDelegate>

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *areas;

@property(nonatomic,strong) NSString *selectedProvince;
@property(nonatomic,strong) NSString *selectedCity;
@property(nonatomic,strong) NSString *selectedAreas;

@property (retain, nonatomic) id<AppAddressPickerDelegate> delegate;

@end
