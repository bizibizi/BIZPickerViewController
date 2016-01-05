//
//  TransparentViewController.m
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 6/11/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "TransparentViewController.h"


#define k_DURATION_appearDisappear 0.5


@interface TransparentViewController ()
@end


@implementation TransparentViewController


#pragma mark - LifeCycle


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    self.view.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startAppearance];
}


#pragma mark - Animations


- (void)startAppearance
{
    [UIView animateWithDuration:k_DURATION_appearDisappear
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         self.view.alpha = 1;
                     }
                     completion:nil];
}

- (void)startDisappearance
{
    [UIView animateWithDuration:k_DURATION_appearDisappear
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void) {
                         self.view.alpha = 0.0;
                     }
                     completion:nil];
}


@end
