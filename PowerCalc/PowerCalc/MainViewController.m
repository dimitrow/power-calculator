//
//  MainViewController.m
//  PowerCalc
//
//  Created by Eugene Dimitrow on 9/17/14.
//  Copyright (c) 2014 Eugene Dimitrow. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    NSMutableArray *keyboards;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.keyboardView.pagingEnabled = YES;
    self.keyboardView.contentSize = CGSizeMake(320*2, 140);
    keyboards = [[NSMutableArray alloc] initWithCapacity:0];
    _basicKeyboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"basic"];
    _advancedKeyboardVC = [self.storyboard instantiateViewControllerWithIdentifier:@"advanced"];
    
    [self.keyboardView addSubview:_basicKeyboardVC.view];
    [self.keyboardView addSubview:_advancedKeyboardVC.view];
    
    CGRect frame = _advancedKeyboardVC.view.frame;
    frame.origin.x = 320;
    _advancedKeyboardVC.view.frame = frame;
    
    [keyboards addObject:self.keyboardView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
