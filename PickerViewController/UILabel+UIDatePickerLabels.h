//
//  UILabel+UIDatePickerLabels.h
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 5/28/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>


// * Custom fonts, textColor for labels in UIDatePicker
// *  Force the label's text colour to be white when the setTextColor: message is sent to the label. In order to not do this for every label in the app I've filtered it to only apply if it's a subview of a UIDatePicker class. Finally, some of the labels have their colours set before they are added to their superviews. To catch these the code overrides the willMoveToSuperview: method.
@interface UILabel (UIDatePickerLabels)

@end
