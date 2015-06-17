//
//  AreaActionSheetPickerPickerDelegate.m
//  ActionSheetPicker
//
//  Created by Xu Wenfeng on 14-6-3.
//
//

#import "AreaActionSheetPickerPickerDelegate.h"

@implementation AreaActionSheetPickerPickerDelegate


- (id)init
{
    if (self = [super init]) {
        _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
        _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
        
        self.selectedProvince=[[_provinces objectAtIndex:0] objectForKey:@"state"];
        if ([_cities count]>0) {
            self.selectedCity=[[_cities objectAtIndex:0] objectForKey:@"city"];
        }
        if ([_areas count]>0) {
            self.selectedAreas=[_areas objectAtIndex:0];
        }

    }
    return self;
}
/////////////////////////////////////////////////////////////////////////
#pragma mark - ActionSheetCustomPickerDelegate Optional's
/////////////////////////////////////////////////////////////////////////
- (void)configurePickerView:(UIPickerView *)pickerView
{
    // Override default and hide selection indicator
    pickerView.showsSelectionIndicator = NO;
}

- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    NSString *resultMessage = [NSString stringWithFormat:@"%@ %@ %@", self.selectedProvince, self.selectedCity,self.selectedAreas, nil];
    
    UITextField *txt=(UITextField*)origin;
    txt.text=resultMessage;
    
    //[[[UIAlertView alloc] initWithTitle:@"Success!" message:resultMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - UIPickerViewDataSource Implementation
/////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////////////
#pragma mark UIPickerViewDelegate Implementation
/////////////////////////////////////////////////////////////////////////

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return 100.0f;
}
/*- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
 {
 return
 }
 */
// these methods return either a plain UIString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[_provinces objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[_cities objectAtIndex:row] objectForKey:@"city"];
            break;
        case 2:
            if ([_areas count] > 0) {
                return [_areas objectAtIndex:row];
                break;
            }
        default:
            return  @"";
            break;
    }
    return nil;
}

/////////////////////////////////////////////////////////////////////////

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Row %i selected in component %i", row, component);
    switch (component) {
        case 0:
            _cities = [[_provinces objectAtIndex:row] objectForKey:@"cities"];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:1];
            
            self.selectedProvince=[[_provinces objectAtIndex:row] objectForKey:@"state"];
            _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView reloadComponent:2];
            if ([_cities count]>0) {
                self.selectedCity=[[_cities objectAtIndex:0] objectForKey:@"city"];
            }
            if ([_areas count]>0) {
                self.selectedAreas=[_areas objectAtIndex:0];
            }

            break;
        case 1:
            _areas = [[_cities objectAtIndex:row] objectForKey:@"areas"];
            self.selectedCity=[[_cities objectAtIndex:row] objectForKey:@"city"];
            [pickerView  selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
            if ([_areas count]>0) {
                 self.selectedAreas=[_areas objectAtIndex:0];
            }
           
            break;
        case 2:
            self.selectedAreas=[_areas objectAtIndex:row];
            break;
        default:
            break;
    }
}




@end
