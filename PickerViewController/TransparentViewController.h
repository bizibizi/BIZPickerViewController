//
//  TransparentViewController.h
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 6/11/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>


// * Class defines ViewController that used as a background VC(above status, nav bar, tab bar etc) for custom alerts, actionSheets and any other staff that needs Transparent dark background
// * Should present it modaly without animation
@interface TransparentViewController : UIViewController
// * Starting appearance runs with viewDidAppear
// * Use method to start Disappearance VC
- (void)startDisappearance;
@end
