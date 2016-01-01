//
//  PickerViewController.m
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 5/8/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "PickerViewController.h"
#import "UILabel+UIDatePickerLabels.h"
#import "UIViewController+PresentViewControllerOverCurrentContext.h"


typedef enum {
    // * Show year for only prev/next year, not for current year
    // * "dd MMM, hh:mm a" or "yyyy dd MMM, hh:mm a"
    DateFormatDateWithFlexibleYearAndTime = 1,
    // * "dd MMM yyyy"
    DateFormatDate,
    // * Time(if dates the same) or Date With Flexible Year
    // * "hh:mm a" or "dd MMM" or "yyyy dd MMM"
    DateFormatTimeOrDateWithFlexibleYear,
    //! Date format used to interact with server
    DateFormatForBackend,
    //! Date format used to interact with server with no time value
    DateFormatForBackendNoTime,
    //! Date With Flexible Year
    // * "dd MMM" or "yyyy dd MMM"
    DateFormatDateWithFlexibleYear,
    //! Time only
    // * "hh:mm a"
    DateFormatTime,
    //! Date only with slashes
    // * MM/dd/yyyy
    DateFormatFacebook
    
} DateFormat;


@interface PickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
// * Save selected item with CustomPickerType to property
@property (nonatomic) NSUInteger indexOfSelectedRowInPicker;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end


@implementation PickerViewController 


#pragma mark - Getters/Setters


- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (NSDateFormatter *)dateFormatterWithFormat:(DateFormat)dateFormat withPickedDate:(NSDate *)pickedDate
{
    switch (dateFormat)
    {
        case DateFormatDateWithFlexibleYearAndTime:
        {
            if (!pickedDate) {
                NSLog(@"Error: dateFormatterWithFormat:DateFormatDateWithFlexibleYearAndTime required pickedDate");
                return self.dateFormatter;
            }
            
            // * Show year for only prev/next year, not for current year
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *pickedDateComponents = [calendar components:NSCalendarUnitYear fromDate:pickedDate];
            NSDateComponents *currentDateComponents = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
            NSUInteger pickedYear = [pickedDateComponents year];
            NSUInteger currentYear = [currentDateComponents year];
            if (pickedYear == currentYear && self.enableShortDates) {
                [self.dateFormatter setDateFormat:@"dd MMM, hh:mm a"];
            } else {
                [self.dateFormatter setDateFormat:@"yyyy dd MMM, hh:mm a"];
            }
        } break;
            
        case DateFormatTimeOrDateWithFlexibleYear:
        {
            if (!pickedDate) {
                NSLog(@"Error: dateFormatterWithFormat:DateFormatDateWithFlexibleYearAndTime required pickedDate");
                return self.dateFormatter;
            }
            
            // * Show Hours and Minutes - if it of current day; if not - show Day and Month if it of current year; if not - show Year, Day, Month
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
            NSDateComponents *pickedDateComponents = [calendar components:units fromDate:pickedDate];
            NSDateComponents *currentDateComponents = [calendar components:units fromDate:[NSDate date]];
            NSUInteger pickedDay = [pickedDateComponents day];
            NSUInteger currentDay = [currentDateComponents day];
            NSUInteger pickedYear = [pickedDateComponents year];
            NSUInteger currentYear = [currentDateComponents year];
            if (pickedDay == currentDay) {
                [self.dateFormatter setDateFormat:@"hh:mm a"];
            } else
                if (pickedYear == currentYear)
                {
                    [self.dateFormatter setDateFormat:@"dd MMM"];
                } else {
                    [self.dateFormatter setDateFormat:@"yyyy, dd MMM"];
                }
        } break;
            
        case DateFormatDateWithFlexibleYear:
        {
            if (!pickedDate) {
                NSLog(@"Error: dateFormatterWithFormat:DateFormatDateWithFlexibleYearAndTime required pickedDate");
                return self.dateFormatter;
            }
            
            // * Show Day and Month if it of current year; if not - show Year, Day, Month
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
            NSDateComponents *pickedDateComponents = [calendar components:units fromDate:pickedDate];
            NSDateComponents *currentDateComponents = [calendar components:units fromDate:[NSDate date]];
            NSUInteger pickedYear = [pickedDateComponents year];
            NSUInteger currentYear = [currentDateComponents year];
            if (pickedYear == currentYear && self.enableShortDates)
            {
                [self.dateFormatter setDateFormat:@"dd MMM"];
            } else {
                [self.dateFormatter setDateFormat:@"yyyy, dd MMM"];
            }
        } break;
            
        case DateFormatTime:
        {
            [self.dateFormatter setDateFormat:@"hh:mm a"];
        } break;
            
        case DateFormatDate:
        {
            [self.dateFormatter setDateFormat:@"dd MMM yyyy"];
        } break;
            
        case DateFormatForBackend:
        {
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        } break;
            
        case DateFormatForBackendNoTime:
        {
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        } break;
            
        case DateFormatFacebook:
        {
            [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
        } break;
            
        default:
            break;
    }
    
    return self.dateFormatter;
}


#pragma mark - LifeCycle


- (instancetype)initFromNib
{
    return [self initWithNibName:@"PickerViewController" bundle:nil];
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.view.backgroundColor = [UIColor clearColor];
    
    self.toolbar.backgroundColor = [UIColor blueColor];
    
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.doneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:20];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.doneButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.picker.backgroundColor = [UIColor whiteColor];
    
    self.enableShortDates = YES;
}


#pragma mark - Getters/Setters


- (void)setPickerType:(PickerType)pickerType
{
    _pickerType = pickerType;
    switch (pickerType)
    {
        case DateAndTimePickerType:
        {
            self.picker.hidden = YES;
            self.datePicker.hidden = NO;
            
            self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//            self.datePicker.minimumDate = [NSDate date];
            self.datePicker.minuteInterval = 5;
            self.datePicker.date = [NSDate date];
        } break;
            
        case DatePickerType:
        {
            self.picker.hidden = YES;
            self.datePicker.hidden = NO;

            self.datePicker.datePickerMode = UIDatePickerModeDate;
            /*
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *currentDate = [NSDate date];
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            // * Max birthday year is -13 then current
            [dateComponents setYear:-13];
            NSDate *maxDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];
            [dateComponents setYear:-150];
            NSDate *minDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];
            self.datePicker.maximumDate = maxDate;
            self.datePicker.minimumDate = minDate;
            self.datePicker.date = maxDate;
            */
        } break;
            
        case CustomPickerType:
        {
            self.picker.hidden = NO;
            self.datePicker.hidden = YES;
            
            self.picker.dataSource = self;
            self.picker.delegate = self;
            self.picker.showsSelectionIndicator = YES;
            self.indexOfSelectedRowInPicker = 0;
        } break;
            
        default:
        {
            NSLog(@"Unnown PickerType");
        } break;
    }
}

- (void)setInitialDate:(NSDate *)date
{
    if (date) {
        self.datePicker.date = date;
    }
}

- (void)setMinimalDate:(NSDate *)date
{
    if (date) {
        self.datePicker.minimumDate = date;
    }
}

- (void)setInitialItemAtIndex:(NSUInteger)index
{
    if (index < self.dataSourceForCustomPickerType.count) {
        [self.picker selectRow:index inComponent:0 animated:NO];
    } 
}


#pragma mark - Events


- (IBAction)dismissButtonAction:(UIButton *)sender
{
    [self dismissViewControllerOverCurrentContextAnimated:YES completion:nil];
}

- (IBAction)cancelButtonAction:(UIButton *)sender
{
    [self dismissViewControllerOverCurrentContextAnimated:YES completion:nil];
}

- (IBAction)doneButtonAction:(UIButton *)sender
{
    // * DateAndTimePickerType
    // * DatePickerType
    if (self.pickerType == DateAndTimePickerType ||
        self.pickerType == DatePickerType)
    {
        // * Format date
        NSDateFormatter *dateFormatter;
        if (self.pickerType == DateAndTimePickerType)
        {
            dateFormatter = [self dateFormatterWithFormat:DateFormatDateWithFlexibleYearAndTime withPickedDate:self.datePicker.date];
        } else
            if (self.pickerType == DatePickerType)
            {
                dateFormatter = [self dateFormatterWithFormat:DateFormatDate withPickedDate:nil];
            }
        
        [self.delegate didSelectDate:self.datePicker.date formattedString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.datePicker.date]]];
    } else
        
        // * CustomPickerType
        if (self.pickerType == CustomPickerType) {
            [self.delegate didSelectItemAtIndex:self.indexOfSelectedRowInPicker];
        }
    
    [self dismissViewControllerOverCurrentContextAnimated:YES completion:nil];
}


#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return self.dataSourceForCustomPickerType.count;
}

// * Customize PickerView
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *tView = (UILabel *)view;
    if (!tView) {
        tView = [[UILabel alloc] init];
        tView.font = [UIFont systemFontOfSize:22];
        tView.textColor = [UIColor blackColor];
        tView.textAlignment = NSTextAlignmentCenter;
    }
    
    // * Supported formats
    if ([self.dataSourceForCustomPickerType.firstObject isKindOfClass:[NSString class]]) {
        tView.text = self.dataSourceForCustomPickerType[row];
    } else if ([self.dataSourceForCustomPickerType.firstObject isKindOfClass:[NSNumber class]]) {
        tView.text = [self.dataSourceForCustomPickerType[row] stringValue];
    }
    
    return tView;
}


#pragma mark - UIPickerViewDataSource Events


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        // * Save to return then 'Done' button pressed
        self.indexOfSelectedRowInPicker = row;
    }
}


@end
