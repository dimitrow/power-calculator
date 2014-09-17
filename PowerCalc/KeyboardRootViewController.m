//
//  KeyboardRootViewController.m
//  PowerCalc
//
//  Created by Eugene Dimitrow on 9/17/14.
//  Copyright (c) 2014 Eugene Dimitrow. All rights reserved.
//

#import "KeyboardRootViewController.h"

@interface KeyboardRootViewController ()

@property (nonatomic, retain) BasicViewController *basicKeyboardVC;
@property (nonatomic, retain) AdvancedViewController *advancedKeyboardVC;

@end

@implementation KeyboardRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = self;
    [self setViewControllers:@[self.basicKeyboardVC]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BasicViewController *)basicKeyboardVC {
    
    if (!_basicKeyboardVC) {
        UIStoryboard *storyboard = self.storyboard;
        _basicKeyboardVC = [storyboard instantiateViewControllerWithIdentifier:@"basic"];
    }
    
    return _basicKeyboardVC;
}

- (AdvancedViewController *)advancedKeyboardVC {
    
    if (!_advancedKeyboardVC) {
        UIStoryboard *storyboard = self.storyboard;
        _advancedKeyboardVC = [storyboard instantiateViewControllerWithIdentifier:@"advanced"];
    }
    
    return _advancedKeyboardVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    UIViewController *nextViewController = nil;
    
    if (viewController == self.basicKeyboardVC) {
        nextViewController = self.advancedKeyboardVC;
    }
    
    return nextViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    UIViewController *prevViewController = nil;
    
    if (viewController == self.advancedKeyboardVC) {
        prevViewController = self.basicKeyboardVC;
    }
    
    return prevViewController;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
