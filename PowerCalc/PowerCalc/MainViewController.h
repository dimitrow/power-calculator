//
//  MainViewController.h
//  PowerCalc
//
//  Created by Eugene Dimitrow on 9/17/14.
//  Copyright (c) 2014 Eugene Dimitrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardRootViewController.h"

#import "BasicViewController.h"
#import "AdvancedViewController.h"

@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *keyboardView;

@property (strong, nonatomic) BasicViewController *basicKeyboardVC;
@property (strong, nonatomic) AdvancedViewController *advancedKeyboardVC;

@end
