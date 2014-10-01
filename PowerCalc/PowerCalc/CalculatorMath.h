//
//  CalculatorMath.h
//  PowerCalc
//
//  Created by Eugene Dimitrow on 9/24/14.
//  Copyright (c) 2014 Eugene Dimitrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorMath : NSObject
{
    NSMutableArray *operations;
    NSMutableArray *numbers;
}

@property (retain, nonatomic) NSString *mathResult;
- (double)mathOperation:(NSString *)operation withValue:(NSString *)value;
- (double)choosenOperation:(NSString *)operation withNumber:(NSString *)number;
- (void)clear;
@end
