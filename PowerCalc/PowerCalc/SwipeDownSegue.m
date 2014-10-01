//
//  SwipeDownSegue.m
//  PowerCalc
//
//  Created by Eugene Dimitrow on 9/24/14.
//  Copyright (c) 2014 Eugene Dimitrow. All rights reserved.
//

#import "SwipeDownSegue.h"

@implementation SwipeDownSegue

-(void)perform
{
    UIViewController *source = self.sourceViewController;
    UIViewController *destination = self.destinationViewController;
    
    
    destination.view.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.85];
    source.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [source.view addSubview:destination.view];
    
    destination.view.transform = CGAffineTransformMakeTranslation(0, -(destination.view.frame.size.height)*0.9);
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
        destination.view.transform = CGAffineTransformMakeTranslation(0, 0);

    } completion:^(BOOL finished) {
        [destination.view removeFromSuperview];
        [source presentViewController:destination animated:NO completion:NULL];

    }];
    
}

@end
