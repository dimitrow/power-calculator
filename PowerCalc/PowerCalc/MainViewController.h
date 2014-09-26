//
//  MainViewController.h
//  PowerCalc
//
//  Created by Eugene Dimitrow on 9/17/14.
//  Copyright (c) 2014 Eugene Dimitrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorMath.h"

@interface MainViewController : UIViewController <UIScrollViewDelegate>
{
    CalculatorMath *calculator;
}

@property (weak, nonatomic) IBOutlet UIScrollView *keyboardView;
@property (weak, nonatomic) IBOutlet UIPageControl *keyboardIndicator;

@property (weak, nonatomic) IBOutlet UIView *screenView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;
@property (weak, nonatomic) IBOutlet UIView *functionView;

@end
