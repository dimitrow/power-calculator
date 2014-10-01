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

@property (retain, nonatomic) IBOutlet UIScrollView *keyboardView;
@property (retain, nonatomic) IBOutlet UIPageControl *keyboardIndicator;

@property (retain, nonatomic) IBOutlet UIView *screenView;
@property (retain, nonatomic) IBOutlet UILabel *resultLabel;
@property (retain, nonatomic) IBOutlet UILabel *expressionLabel;
@property (retain, nonatomic) IBOutlet UIView *functionView;

@end
