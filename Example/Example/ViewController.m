//
//  ViewController.m
//  Example
//
//  Created by IgorBizi@mail.ru on 12/16/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "ViewController.h"
#import "PickerViewController.h"


@interface ViewController ()
@end


@implementation ViewController


- (IBAction)birthdayButtonAction:(id)sender
{
    PickerViewController *pickerViewController = [[PickerViewController alloc] initFromNib];
    pickerViewController.pickerType = DatePickerType;
//    [pickerViewController setInitialDate:nil];
//    pickerViewController.delegate = self;
    [self presentViewControllerOverCurrentContext:pickerViewController animated:YES completion:nil];
}

- (IBAction)dateAndTimeButtonAction:(id)sender
{
    PickerViewController *pickerViewController = [[PickerViewController alloc] initFromNib];
    pickerViewController.pickerType = DateAndTimePickerType;
//    pickerViewController.delegate = self;
//    [pickerViewController setInitialDate:[NSDate date]];
//    [pickerViewController setminimalDate:[NSDate date]];
    [self presentViewControllerOverCurrentContext:pickerViewController animated:YES completion:nil];
}

- (IBAction)itemsButtonAction:(id)sender
{
    PickerViewController *pickerViewController = [[PickerViewController alloc] initFromNib];
    pickerViewController.pickerType = CustomPickerType;
    pickerViewController.dataSourceForCustomPickerType = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    [pickerViewController setInitialItemAtIndex:5];
//    pickerViewController.delegate = self;
    [self presentViewControllerOverCurrentContext:pickerViewController animated:YES completion:nil];
}

@end
