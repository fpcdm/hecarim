//
//  AreaActionSheetPickerPickerDelegate.m
//  ActionSheetPicker
//
//  Created by Xu Wenfeng on 14-6-3.
//
//

#import "AppAddressPicker.h"
#import "HelperHandler.h"

@implementation AppAddressPicker
{
    HelperHandler *helperHandler;
    AreaEntity *requestArea;
}

- (id)init
{
    if (self = [super init]) {
        
        _provinces = @[];
        _cities = @[];
        _areas = @[];
        
        _address = [[AddressEntity alloc] init];
        helperHandler = [[HelperHandler alloc] init];
        
    }
    return self;
}

- (void)loadData:(void (^)()) callback
{
    //查询省列表
    requestArea = [[AreaEntity alloc] init];
    requestArea.code = @0;
    
    [helperHandler queryAreas:requestArea success:^(NSArray *result){
        _provinces = result;
        
        NSLog(@"省列表：");
        for (AreaEntity *area in _provinces) {
            NSLog(@"%@", [area toDictionary]);
        }
        
        [self loadCities:[_provinces objectAtIndex:0] callback:callback];
    } failure:^(ErrorEntity *error){
    }];
}

- (void)loadCities:(AreaEntity *) province callback: (void (^)()) callback
{
    //获取选中省
    requestArea = province;
    _address.provinceId = requestArea.code;
    _address.provinceName = requestArea.name;
    
    //查询市列表
    [helperHandler queryAreas:requestArea success:^(NSArray *result){
        _cities = result;
        
        NSLog(@"市列表：");
        for (AreaEntity *area in _cities) {
            NSLog(@"%@", [area toDictionary]);
        }
        
        [self loadAreas:[_cities objectAtIndex:0] callback:callback];
    } failure:^(ErrorEntity *error){
    }];
}

- (void)loadAreas:(AreaEntity *) city callback: (void (^)()) callback
{
    //获取选中区
    requestArea = city;
    _address.cityId = requestArea.code;
    _address.cityName = requestArea.name;
    
    //查询市列表
    [helperHandler queryAreas:requestArea success:^(NSArray *result){
        _areas = result;
        
        NSLog(@"县列表：");
        for (AreaEntity *area in _areas) {
            NSLog(@"%@", [area toDictionary]);
        }
        
        //获取选中县
        requestArea = [_areas objectAtIndex:0];
        if (requestArea) {
            _address.countyId = requestArea.code;
            _address.countyName = requestArea.name;
        }
        
        callback();
    } failure:^(ErrorEntity *error){
    }];
}

#pragma mark - ActionSheetCustomPickerDelegate Optional's
- (void)configurePickerView:(UIPickerView *)pickerView
{
    pickerView.showsSelectionIndicator = NO;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    [self.delegate pickFinish:_address];
}

#pragma mark - UIPickerViewDataSource Implementation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component) {
        case 0: return [_provinces count];
        case 1: return [_cities count];
        case 2: return [_areas count];
    }
    return 0;
}

#pragma mark UIPickerViewDelegate Implementation
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    AreaEntity *area = nil;
    switch (component) {
        case 0:
        {
            if ([_provinces count] > 0) {
                area = [_provinces objectAtIndex:row];
                return area.name;
                break;
            }
        }
            break;
        case 1:
        {
            if ([_cities count] > 0) {
                area = [_cities objectAtIndex:row];
                return area.name;
                break;
            }
        }
            break;
        case 2:
        {
            if ([_areas count] > 0) {
                area = [_areas objectAtIndex:row];
                return area.name;
                break;
            }
        }
            break;
        default:
            return  @"";
            break;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            //获取选中省
            requestArea = [_provinces objectAtIndex:row];
            [self loadCities:requestArea callback:^{
                [pickerView selectRow:0 inComponent:1 animated:YES];
                [pickerView reloadComponent:1];
                
                [pickerView selectRow:0 inComponent:2 animated:YES];
                [pickerView reloadComponent:2];
            }];
        }
            break;
        case 1:
        {
            //获取选中区
            requestArea = [_cities objectAtIndex:row];
            [self loadAreas:requestArea callback:^{
                [pickerView  selectRow:0 inComponent:2 animated:YES];
                [pickerView reloadComponent:2];
            }];
        }
            break;
        case 2:
        {
            //获取选中县
            requestArea = [_areas objectAtIndex:row];
            _address.countyId = requestArea.code;
            _address.countyName = requestArea.name;
        }
            break;
        default:
            break;
    }
}

@end
