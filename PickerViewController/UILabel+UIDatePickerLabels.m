//
//  UILabel+UIDatePickerLabels.m
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 5/28/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "UILabel+UIDatePickerLabels.h"
#import <objc/runtime.h>


@implementation UILabel (UIDatePickerLabels)


//////////////////////// Customization


- (UIFont *)labelFont
{
    return [UIFont systemFontOfSize:22];
}

- (UIColor *)labelTextColor
{
    return [UIColor blackColor];
}


//////////////////////// Implementation


+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setTextColor:)
                      withNewSelector:@selector(swizzledSetTextColor:)];
        [self swizzleInstanceSelector:@selector(setFont:)
                      withNewSelector:@selector(swizzledSetFont:)];
        [self swizzleInstanceSelector:@selector(willMoveToSuperview:)
                      withNewSelector:@selector(swizzledWillMoveToSuperview:)];
    });
}

// Forces the text colour of the label to be black only for UIDatePicker and its components
-(void) swizzledSetTextColor:(UIColor *)textColor
{
    if([self view:self hasSuperviewOfClass:[UIDatePicker class]] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerWeekMonthDayView")] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerContentView")]){
        [self swizzledSetTextColor:[self labelTextColor]];
    } else {
        //Carry on with the default
        [self swizzledSetTextColor:textColor];
    }
}

// Forces the font of the label to be custom only for UIDatePicker and its components
-(void) swizzledSetFont:(UIFont *)font
{
    if([self view:self hasSuperviewOfClass:[UIDatePicker class]] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerWeekMonthDayView")] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerContentView")]){
        [self swizzledSetFont:[self labelFont]];
    } else {
        //Carry on with the default
        [self swizzledSetFont:font];
    }
}


// Some of the UILabels haven't been added to a superview yet so listen for when they do.
- (void) swizzledWillMoveToSuperview:(UIView *)newSuperview
{
    [self swizzledSetTextColor:self.textColor];
    [self swizzledSetFont:self.font];
    [self swizzledWillMoveToSuperview:newSuperview];
}

// -- helpers --
- (BOOL) view:(UIView *) view hasSuperviewOfClass:(Class) class
{
    if(view.superview) {
        if ([view.superview isKindOfClass:class]) {
            return true;
        }
        return [self view:view.superview hasSuperviewOfClass:class];
    }
    return false;
}

+ (void) swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    BOOL methodAdded = class_addMethod([self class],
                                       originalSelector,
                                       method_getImplementation(newMethod),
                                       method_getTypeEncoding(newMethod));
    
    if (methodAdded) {
        class_replaceMethod([self class],
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}


@end
