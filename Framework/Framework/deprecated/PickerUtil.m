//
//  ActionSheetPicker
//
//  Created by Wuyong on 15-8-4.
//
//

#import "PickerUtil.h"

@implementation PickerUtilRow

@synthesize name;
@synthesize value;

+ (instancetype) rowWithName:(NSString *)name value:(id)value
{
    return [[self alloc] initWithName:name value:value];
}

- (instancetype) initWithName:(NSString *)initName value:(id)initValue
{
    self = [super init];
    
    if (self) {
        self.name = initName;
        self.value = initValue;
    }
    
    return self;
}

@end

@implementation PickerUtil
{
    NSArray *firstRows;
    NSArray *secondRows;
    NSArray *thirdRows;
    
    NSArray *selectedRows;
}

- (instancetype) init
{
    return [self initWithTitle:nil grade:1 origin:nil];
}

- (instancetype) initWithTitle:(NSString *)title grade:(NSUInteger)grade origin:(id)origin
{
    self = [super init];
    if (!self) return nil;
    
    self.title = title;
    self.grade = grade;
    self.origin = origin;
    
    firstRows = @[];
    secondRows = @[];
    thirdRows = @[];
    
    selectedRows = @[];
    
    return self;
}

- (void) show
{
    [self loadFirst:^{
        [ActionSheetCustomPicker showPickerWithTitle:self.title delegate:self showCancelButton:YES origin:self.origin];
    }];
}

- (void) loadFirst: (void (^)()) callback
{
    self.firstLoadBlock(@[], ^(NSArray *rows){
        firstRows = rows ? rows : @[];
        
        if ([firstRows count] > 0) {
            selectedRows = @[
                             [firstRows objectAtIndex:0]
                             ];
        }
        
        if (self.grade > 1 && [firstRows count] > 0) {
            [self loadSecond:callback];
        } else {
            callback();
        }
    });
}

- (void) loadSecond: (void (^)()) callback;
{
    self.secondLoadBlock(selectedRows, ^(NSArray *rows){
        secondRows = rows ? rows : @[];
        
        if ([secondRows count] > 0) {
            selectedRows = @[
                             [selectedRows objectAtIndex:0],
                             [secondRows objectAtIndex:0]
                             ];
        }
        
        if (self.grade > 2 && [secondRows count] > 0) {
            [self loadThird:callback];
        } else {
            callback();
        }
    });
    
}

- (void) loadThird: (void (^)()) callback
{
    self.thirdLoadBlock(selectedRows, ^(NSArray *rows){
        thirdRows = rows ? rows : @[];
        
        if ([thirdRows count] > 0) {
            selectedRows = @[
                             [selectedRows objectAtIndex:0],
                             [selectedRows objectAtIndex:1],
                             [thirdRows objectAtIndex:0]
                             ];
        }
        
        callback();
    });
}

#pragma mark - ActionSheetCustomPickerDelegate
- (void)configurePickerView:(UIPickerView *)pickerView
{
    pickerView.showsSelectionIndicator = NO;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    //全部选择完成才回调
    if (selectedRows && [selectedRows count] == self.grade) {
        self.resultBlock(selectedRows);
    }
}

#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.grade;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0: return [firstRows count];
        case 1: return [secondRows count];
        case 2: return [thirdRows count];
    }
    return 0;
}

#pragma mark UIPickerViewDelegate Implementation
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return pickerView.frame.size.width / self.grade;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    PickerUtilRow *data = nil;
    switch (component) {
        case 0:
        {
            if ([firstRows count] > row) {
                data = [firstRows objectAtIndex:row];
                return data.name;
                break;
            }
        }
            break;
        case 1:
        {
            if ([secondRows count] > row) {
                data = [secondRows objectAtIndex:row];
                return data.name;
                break;
            }
        }
            break;
        case 2:
        {
            if ([thirdRows count] > row) {
                data = [thirdRows objectAtIndex:row];
                return data.name;
                break;
            }
        }
            break;
        default:
            return  nil;
            break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            //获取选中
            if ([firstRows count] > row) {
                selectedRows = @[
                                 [firstRows objectAtIndex:row]
                                 ];
                
                //选中了才加载，下同
                if (self.grade > 1) {
                    [self loadSecond:^{
                        [pickerView selectRow:0 inComponent:1 animated:YES];
                        [pickerView reloadComponent:1];
                        
                        if (self.grade > 2) {
                            [pickerView selectRow:0 inComponent:2 animated:YES];
                            [pickerView reloadComponent:2];
                        }
                    }];
                }
            }
        }
            break;
        case 1:
        {
            //获取选中
            if ([secondRows count] > row) {
                selectedRows = @[
                                 [selectedRows objectAtIndex:0],
                                 [secondRows objectAtIndex:row]
                                 ];
                
                //选中了才加载
                if (self.grade > 2) {
                    [self loadThird:^{
                        [pickerView selectRow:0 inComponent:2 animated:YES];
                        [pickerView reloadComponent:2];
                    }];
                }
            }
        }
            break;
        case 2:
        {
            //获取选中
            if ([thirdRows count] > row) {
                selectedRows = @[
                                 [selectedRows objectAtIndex:0],
                                 [selectedRows objectAtIndex:1],
                                 [thirdRows objectAtIndex:row]
                                 ];
            }
        }
            break;
        default:
            break;
    }
}

@end
