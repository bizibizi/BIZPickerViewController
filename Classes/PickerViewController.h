//
//  PickerViewController.h
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 5/8/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+PresentViewControllerOverCurrentContext.h"


typedef enum {
    DateAndTimePickerType = 1, // * Event Date and Time
    DatePickerType, // * Birthday Date
    CustomPickerType // * Custom picker of any items
} PickerType;


@protocol PickerViewControllerDelegate <NSObject>
@optional
- (void)didSelectDate:(NSDate *)date formattedString:(NSString *)dateString; // * For DateAndTimePickerType, DatePickerType
- (void)didSelectItemAtIndex:(NSUInteger)index; // * For CustomPickerType
@end


// * ViewController with picker/datePicker
@interface PickerViewController : UIViewController
//! Designated initializer
- (instancetype)initFromNib;

@property (nonatomic, weak) id <PickerViewControllerDelegate> delegate;
@property (nonatomic) PickerType pickerType;

//** For Customization
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

//! Enable short format for picked 'date String'. YES as default
@property (nonatomic) BOOL enableShortDates;

// * For CustomPickerType only
@property (nonatomic, strong) NSArray *dataSourceForCustomPickerType; // of NSString, of NSNumber

// * Set predefined date
- (void)setInitialDate:(NSDate *)date;

//! Minimum date for date picker
- (void)setMinimalDate:(NSDate*)date;

// * Set predefined item
- (void)setInitialItemAtIndex:(NSUInteger)index;


@end
