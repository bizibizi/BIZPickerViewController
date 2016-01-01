//
//  UIViewController+PresentViewControllerOverCurrentContext.m
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 6/6/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "UIViewController+PresentViewControllerOverCurrentContext.h"
#import "TransparentViewController.h"


#define k_DURATION_dismissVC 0.5
#define IS_IOS_LowThen8 [[[UIDevice currentDevice]systemVersion]floatValue] < 8
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height


@implementation UIViewController (PresentViewControllerOverCurrentContext)


- (void)presentViewControllerOverCurrentContext:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion
{
     UIViewController *presentingVC = self;
    
    if (IS_IOS_LowThen8) {
        
        if (animated) {
            
            TransparentViewController *transparentViewController = [[TransparentViewController alloc]init];
            [presentingVC presentIOS7ViewController:transparentViewController animated:NO completion:^{
                // * Present viewControllerToPresent from TransparentViewController
                [transparentViewController presentIOS7ViewController:viewControllerToPresent animated:animated completion:completion];
            }];
            
        } else {
            [presentingVC presentIOS7ViewController:viewControllerToPresent animated:animated completion:completion];
        }
        
    } else {
        
        if (animated) {
            
            TransparentViewController *transparentViewController = [[TransparentViewController alloc]init];
            [self presentIOS8PlusViewController:transparentViewController animated:NO completion:completion];
            // * Present viewControllerToPresent from TransparentViewController
            [transparentViewController presentIOS8PlusViewController:viewControllerToPresent animated:YES completion:completion];
            
        } else {
            [self presentIOS8PlusViewController:viewControllerToPresent animated:NO completion:completion];
        }
    }
}

- (void)presentIOS7ViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *presentingVC = self;
    
    UIViewController *root = presentingVC;
    while (root.parentViewController) {
        root = root.parentViewController;
    }
    
    [presentingVC presentViewController:viewControllerToPresent animated:animated completion:^{
        [viewControllerToPresent dismissViewControllerAnimated:NO completion:^{
            UIModalPresentationStyle orginalStyle = root.modalPresentationStyle;
            if (orginalStyle != UIModalPresentationCurrentContext) {
                root.modalPresentationStyle = UIModalPresentationCurrentContext;
            }
            [presentingVC presentViewController:viewControllerToPresent animated:NO completion:completion];
            if (orginalStyle != UIModalPresentationCurrentContext) {
                root.modalPresentationStyle = orginalStyle;
            }
        }];
    }];
}

- (void)presentIOS8PlusViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion
{
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:viewControllerToPresent animated:animated completion:completion];
}

- (void)dismissViewControllerOverCurrentContextAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (!animated) {
        [self dismissViewControllerWithCompletion:completion];
    } else {
        
        // * Set destination frame of viewControllerToPresent to bottom
        CGRect frame = self.view.frame;
        frame.origin.y = ScreenHeight + [UIApplication sharedApplication].statusBarFrame.size.height;
        
        [UIView animateWithDuration:k_DURATION_dismissVC
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             // * Slide down viewControllerToPresent
                             self.view.frame = frame;
                             // * Hide TransparentViewController
                             if ([self.presentingViewController isKindOfClass:[TransparentViewController class]]) {
                                 [(TransparentViewController *)self.presentingViewController startDisappearance];
                             }
                             
                         } completion:^(BOOL finished) {
                             [self dismissViewControllerWithCompletion:completion];
                         }];
    }
}

- (void)dismissViewControllerWithCompletion:(void (^)(void))completion
{
    if (IS_IOS_LowThen8) {
        [self dismissIOS7ViewControllerWithCompletion:completion];
    } else {
        [self dismissIOS8PlusViewControllerWithCompletion:completion];
    }
}

- (void)dismissIOS7ViewControllerWithCompletion:(void (^)(void))completion
{
    // * Dismiss VC from VC that present it
    if ([self.presentingViewController isKindOfClass:[TransparentViewController class]]) {
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:completion];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:NO completion:completion];
    }
}

- (void)dismissIOS8PlusViewControllerWithCompletion:(void (^)(void))completion
{
    // * Dismiss VC from VC that present it
    if ([self.presentingViewController isKindOfClass:[TransparentViewController class]]) {
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
    [self.presentingViewController dismissViewControllerAnimated:NO completion:completion];
}


@end
