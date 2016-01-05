//
//  UIViewController+PresentViewControllerOverCurrentContext.h
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 6/6/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>


// * For ios7, ios8
// * Class presents VC with clear background, during it's presentation VC's background can become darker
@interface UIViewController (PresentViewControllerOverCurrentContext)

/// @warning Some method of viewControllerToPresent will called twice before iOS 8, e.g. viewWillAppear:.
- (void)presentViewControllerOverCurrentContext:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion;

// * Use custom animated dismission because dismissViewControllerAnimated have very fast animation
- (void)dismissViewControllerOverCurrentContextAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
