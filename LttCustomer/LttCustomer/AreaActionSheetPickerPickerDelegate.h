//
//  AreaActionSheetPickerPickerDelegate.h
//  ActionSheetPicker
//
//  Created by Xu Wenfeng on 14-6-3.
//
//

#import <Foundation/Foundation.h>
#import "ActionSheetPicker.h"

@interface AreaActionSheetPickerPickerDelegate : NSObject<ActionSheetCustomPickerDelegate>

@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *areas;

@property(nonatomic,strong) NSString *selectedProvince;
@property(nonatomic,strong) NSString *selectedCity;
@property(nonatomic,strong) NSString *selectedAreas;



@end
