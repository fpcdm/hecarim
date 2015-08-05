//
//  联动选择器，支持一级，两级，三级联动
//
//  依赖：ActionSheetPicker
//
//  示例代码：
//  PickerUtil *pickerUtil = [[PickerUitl alloc] init];
//  pickerUitl.grade = 1;
//  pickerUtil.title = nil;
//  pickerUtil.origin = self.view;
//  pickerUtil.firstLoadBlock = ^(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler){ completionHandler(rows); };
//  pickerUtil.resultBlock = ^(NSArray *selectedRows){ PickerUtilRow *row = [selectedRows objectAtIndex:0]; };
//  [pickerUtil show];
//
//  Created by Wuyong on 15-8-4.
//
//

#import <Foundation/Foundation.h>
#import "ActionSheetPicker.h"

//加载数据完成句柄
typedef void (^PickerUtilCompletionHandler)(NSArray *rows);

//加载数据代码块
typedef void (^PickerUtilLoadBlock)(NSArray *selectedRows, PickerUtilCompletionHandler completionHandler);

//选择完成代码块
typedef void (^PickerUtilResultBlock)(NSArray *selectedRows);

//选择器行数据
@interface PickerUtilRow : NSObject

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) id value;

- (instancetype) initWithName: (NSString *) name value: (id) value;
+ (instancetype) rowWithName: (NSString *) name value: (id) value;

@end

//选择器接口
@interface PickerUtil : NSObject<ActionSheetCustomPickerDelegate>

//选择器级别
@property (assign, nonatomic) NSUInteger grade;

//选择器标题
@property (retain, nonatomic) NSString *title;

//来源对象（UIBarButtonItem或UIView）
@property (retain, nonatomic) id origin;

//加载数据代码块
@property (copy) PickerUtilLoadBlock firstLoadBlock;
@property (copy) PickerUtilLoadBlock secondLoadBlock;
@property (copy) PickerUtilLoadBlock thirdLoadBlock;

//全部选择完成代码块，部分选择不会回调
@property (copy) PickerUtilResultBlock resultBlock;

//初始化
- (instancetype) initWithTitle: (NSString *) title grade: (NSUInteger) grade origin: (id) origin;

//显示选择器
- (void) show;

@end
