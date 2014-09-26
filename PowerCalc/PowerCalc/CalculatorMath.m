//
//  CalculatorMath.m
//  PowerCalc
//
//  Created by Eugene Dimitrow on 9/24/14.
//  Copyright (c) 2014 Eugene Dimitrow. All rights reserved.
//

#import "CalculatorMath.h"

@implementation CalculatorMath

#pragma mark math 

- (double)choosenOperation:(NSString *)operation withNumber:(NSString *)number
{
    double result = 0;
    
    [[self operations] addObject:operation];
    [[self numbers] addObject:number];
    NSString *action = [[self operations] firstObject];
    
    double firstOperator = [[[self numbers] firstObject] doubleValue];
    double secondOperator = [[[self numbers] lastObject] doubleValue];
    
    
    if ([[self numbers] count] == 1) {
        
        result = [[[self numbers] lastObject] doubleValue];
        
    } else {
        
        if ([action isEqual:@"+"]) {
            
            result = firstOperator + secondOperator;
            
        }
        else if ([action isEqual:@"−"]) {
            
            result = firstOperator - secondOperator;
            
        }
        else if ([action isEqual:@"×"]) {
            
            result = firstOperator * secondOperator;
            
        }
        else if ([action isEqual:@"÷"]) {
            
            result = firstOperator / secondOperator;
            
        }
        
        [[self numbers] removeAllObjects];
        [[self numbers] addObject:[NSString stringWithFormat:@"%g", result]];
        [[self operations] removeAllObjects];
        [[self operations] addObject:operation];
        
    }

    self.mathResult = [NSString stringWithFormat:@"%g", result];
    return result;
}

- (void)clear
{
    [numbers removeAllObjects];
    [operations removeAllObjects];
}

#pragma mark lazy initialization of arrays

- (NSMutableArray *)operations
{
    if (!operations) {
        operations = [[NSMutableArray alloc] init];
    }
    return operations;
}

- (NSMutableArray *)numbers
{
    if (!numbers) {
        numbers = [[NSMutableArray alloc] init];
    }
    return numbers;
}
@end
