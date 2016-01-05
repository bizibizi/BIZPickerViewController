# BIZPickerViewController

*Wait for gif presentation, it's loading...*

![alt tag](https://github.com/bizibizi/BIZPickerViewController/blob/master/presentation.gif)


BIZPickerViewController is a useful picker with simple customization and handy features.


# Installation

### Manually
- Copy ```Classes``` folder to your project 

### From CocoaPods:
```objective-c
pod 'BIZPickerViewController' 
```


# Usage

- ```#import "PickerViewController.h"``` 
- create and setup ```BIZPickerViewController``` 
```objective-c
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
```


# Contact

Igor Bizi
- https://www.linkedin.com/in/igorbizi
- igorbizi@mail.ru


# License
 
The MIT License (MIT)

Copyright (c) 2015-present Igor Bizi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
